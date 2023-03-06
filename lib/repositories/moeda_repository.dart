

import 'dart:convert';

import 'package:flutter/material.dart';

import '../models/moeda.dart';
import '../pages/detalhes_moedas_page.dart';

class MoedaRepository {

bool favorita = false;

static List<Moeda> tabela = [
    Moeda(
      nome: 'Bitcoin',
      sigla: 'BTC',
      icone: 'images/bitcoin.png',
      preco: 242000,
      isFavorita: false,
    ),
    Moeda(
      nome: 'Litecoin',
      sigla: 'LTC',
      icone: 'images/litecoin.png',
      preco: 1000,
      isFavorita: false,
    ),
    Moeda(
      nome: 'XRP',
      sigla: 'XRP',
      icone: 'images/xrp.png',
      preco: 4.5,
       isFavorita: false,
    ),
    Moeda(
      nome: 'USDC',
      sigla: 'USDC',
      icone: 'images/usdc.png',
      preco: 5.4,
      isFavorita: false,
    ),
    Moeda(
      nome: 'Ethereum',
      sigla: 'ETH',
      icone: 'images/ethereum.png',
      preco: 14500,
      isFavorita: false,
    ),
     Moeda(
      nome: 'Cardano',
      sigla: 'ADA',
      icone: 'images/cardano.png',
      preco: 8.5,
      isFavorita: false,
    ),
  ];

  bool isFavorita = false;
  void setFavorita(bool value) {
    isFavorita = value;
  }


Map toJson(Moeda moeda) => {
  'nome': moeda.nome,
  'sigla' : moeda.sigla,
  'icone' : moeda.icone,
  'preco' : moeda.preco,

};





String jsonMoedas = jsonEncode(MoedaRepository.tabela.map((moeda) => moeda.toJson()).toList());



   
 mostrarDetalhes(BuildContext context, Moeda moeda) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: moeda),
      ),
      
    );
 }




}


  


