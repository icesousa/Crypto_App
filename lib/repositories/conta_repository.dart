import 'package:flutter/material.dart';
import 'package:flutter_aula_1/repositories/moeda_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../database/db.dart';
import '../models/historico.dart';
import '../models/moeda.dart';
import '../models/posicao.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  late List<Posicao> _carteira = [];
    late List<Historico> _historico = [];

  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepository() {
    initContaRepository();
  }

  initContaRepository() async {
    await getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  comprar(Moeda moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      //Verificar se a moeda ja foi comprada
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

  _getCarteira() async {
    _carteira = [];
    List posicoes = await db.query('carteira');
    for (var posicao in posicoes) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(Posicao(moeda: moeda, quantidade: double.parse(posicao['quantidade'])),
      );
    }
  notifyListeners();
  }



   _getHistorico() async {
    _historico = [];
    List operacoes = await db.query('historico');
    for (var operacao in operacoes) {
      Moeda moeda = MoedaRepository.tabela.firstWhere(
        (m) => m.sigla == operacao['sigla'],
      );
      _historico.add(Historico(
        dataOperacao: DateTime.fromMillisecondsSinceEpoch(operacao['data_operacao'],),
         tipoOperacao: operacao['tipo_operacao'], 
         moeda: moeda,
          valor: operacao['valor'], 
         quantidade: double.parse(operacao['quantidade'])
         )
         
      );
      
    }
             

  notifyListeners();
  }
}
