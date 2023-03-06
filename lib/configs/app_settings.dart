import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Esta classe é responsável por gerenciar as configurações do aplicativo
class AppSettings extends ChangeNotifier{
  // O objeto SharedPreferences é usado para armazenar e recuperar informações no armazenamento persistente
  late SharedPreferences _preferences;
  
  // Variável que armazena a configuração atual de localização e nome da moeda
  Map<String, String> locale = {
    'locale' : 'pt_BR' 
  };

  // O construtor da classe inicia as configurações do aplicativo
  AppSettings(){
    _startSettings();
  }

  // Este método é responsável por inicializar as configurações do aplicativo
  _startSettings() async{
    await _startPreferences();
    await _readLocale();
  }

  // Este método é responsável por inicializar o objeto SharedPreferences
  Future<void> _startPreferences() async{
    _preferences = await SharedPreferences.getInstance();
  } 

  // Este método é responsável por ler as configurações do aplicativo do armazenamento persistente
  _readLocale()  {
    final local = _preferences.getString('local') ?? 'pt_BR';
    final name = _preferences.getString('name') ?? 'R\$';
    locale = {
      'locale' : local,
      'name' : name,
    };
    // Notifica outros objetos de que ocorreram mudanças nas configurações
    notifyListeners();
  }

  // Este método é responsável por definir as configurações do aplicativo
  setLocale(String local, String name) async{
    // Grava os valores de localização e nome da moeda no armazenamento persistente
    await _preferences.setString('local', local);
    await _preferences.setString('name', name);
    // Atualiza a variável locale com os novos valores e notifica outros objetos de que ocorreram mudanças nas configurações
    await _readLocale();
  }  
}
