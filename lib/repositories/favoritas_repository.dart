import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/moeda.dart';
import '../pages/detalhes_moedas_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = [];

  // chave usada para armazenar a lista de moedas favoritas no SharedPreferences
  static String moedaListKey = 'moeda_listkey';

  // SharedPreferences usado para armazenar a lista de moedas favoritas
  late SharedPreferences _listprefs;

  // getter que retorna uma visualização não modificável da lista de moedas favoritas
  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  // adiciona uma nova lista de moedas favoritas e notifica os ouvintes
  set lista(List<Moeda> novaLista) {
    _lista.addAll(novaLista);
    notifyListeners();
  }

  // construtor que inicia a leitura da lista de moedas favoritas do SharedPreferences
  FavoritasRepository() {
    _startFavoritas();
  }

  // inicializa o SharedPreferences
  Future<void> _startFavoritas() async {
    _listprefs = await SharedPreferences.getInstance();
    _readPrefs();
  }

  // lê a lista de moedas favoritas do SharedPreferences
  _readPrefs() async {
    final moedaList = _listprefs.getString(moedaListKey);

    if (moedaList != null) {
      final decodedMoedaList = Moeda.decode(moedaList);
      lista = decodedMoedaList;

      // define todas as moedas como favoritas
      for (var moeda in _lista) {
        moeda.setFavorita(true);
      }
      notifyListeners();
    }
  }

  // mostra a tela de detalhes da moeda selecionada
  mostrarDetalhes(BuildContext context, Moeda moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: moeda),
      ),
    );
    notifyListeners();
  }

  // remove uma moeda da lista de moedas favoritas
  Future<void> remove(Moeda moeda) async {
    _lista.remove(moeda);
    moeda.setFavorita(false);
    final encodedMoedaList = Moeda.encode(_lista);
    await _listprefs.setString(moedaListKey, encodedMoedaList);
    notifyListeners();
  }

  // salva a lista de moedas favoritas no SharedPreferences
  Future<void> toggleFavorite(List<Moeda> moedas) async {
    for (var moeda in moedas) {
      if (!_lista.contains(moeda)) {
        // se a moeda ainda não está na lista, adiciona e marca como favorita
        _lista.add(moeda);
        moeda.setFavorita(true);
        
      } else {
        // se a moeda já está na lista, remove e desmarca como favorita
        remove(moeda);
       
      }
      final encodedMoedaList = Moeda.encode(_lista);
        await _listprefs.setString(moedaListKey, encodedMoedaList);
        notifyListeners();
    }
  }
}
