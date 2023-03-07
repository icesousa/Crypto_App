import 'package:flutter/material.dart';
import 'package:flutter_aula_1/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/historico.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  late List<Posicao> _carteira = []; //Lista de posições das moedas na carteira do usuário
  late List<Historico> _historico = []; //Lista de operações de compra de moedas do usuário
  double _saldo = 0; //Saldo do usuário

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository() {
    initContaRepository();
  }

  //Inicializa o repositório da conta do usuário
  initContaRepository() async {
    await getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  //Recupera o saldo atual da conta do usuário do banco de dados
  getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  //Atualiza o saldo atual da conta do usuário no banco de dados
  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  //Executa uma operação de compra de moedas pelo usuário
  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      //Verificar se a moeda já foi comprada
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
      //Se não tem a moeda em carteira
      if (posicaoMoeda.isEmpty) {
        await txn.insert('carteira', {
          'sigla': moeda.sigla,
          'moeda': moeda.nome,
          'quantidade': (valor / moeda.preco).toString()
        });
      }
      //ja tem a moeda em carteira
      else {
        final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
        await txn.update(
          'carteira',
          {
            'quantidade': (atual + (valor / moeda.preco)).toString(),
          },
          where: 'sigla = ?',
          whereArgs: [moeda.sigla],
        );
      }
      //inserir a compra no historico
      await txn.insert('historico', {
        'sigla': moeda.sigla,
        'moeda': moeda.nome,
        'quantidade': (valor / moeda.preco).toString(),
        'valor': valor,
        'tipo_operacao': 'compra',
        'data_operacao': DateTime.now().millisecondsSinceEpoch,
      });

      await txn.update('conta', {'saldo': saldo - valor});
    });

    await initContaRepository();
    notifyListeners();
  }

  //Recupera a carteira atual do usuário do banco de dados


_getCarteira() async {
  // Zera a lista de carteira para evitar duplicidade
  _carteira = [];
  
  // Faz uma consulta no banco de dados SQLite e retorna uma lista de resultados
  List posicoes = await db.query('carteira');
  
  // Itera sobre cada resultado da consulta
  for (var posicao in posicoes) {
    // Procura na tabela de moedas a moeda correspondente à sigla da posição atual
    Moeda moeda = MoedaRepository.tabela.firstWhere(
      (m) => m.sigla == posicao['sigla'],
    );
    
    // Cria uma nova posição com a moeda encontrada e a quantidade da posição atual
    _carteira.add(
      Posicao(
        moeda: moeda, 
        quantidade: double.parse(posicao['quantidade']),
      ),
    );
  }
  
  // Notifica todos os ouvintes de que houve uma mudança na carteira
  notifyListeners();
}




_getHistorico() async {
  // Zera a lista de histórico para evitar duplicidade
  _historico = [];
  
  // Faz uma consulta no banco de dados SQLite e retorna uma lista de resultados
  List operacoes = await db.query('historico');
  
  // Itera sobre cada resultado da consulta
  for (var operacao in operacoes) {
    // Procura na tabela de moedas a moeda correspondente à sigla da operação atual
    Moeda moeda = MoedaRepository.tabela.firstWhere(
      (m) => m.sigla == operacao['sigla'],
    );
    
    // Cria um novo objeto Historico com as informações da operação atual
    _historico.add(
      Historico(
        dataOperacao: DateTime.fromMillisecondsSinceEpoch(
          operacao['data_operacao'],
        ),
        tipoOperacao: operacao['tipo_operacao'], 
        moeda: moeda,
        valor: operacao['valor'], 
        quantidade: double.parse(operacao['quantidade']),
      ),
    );
  }
  
  // Notifica todos os ouvintes de que houve uma mudança no histórico
  notifyListeners();
}

}
