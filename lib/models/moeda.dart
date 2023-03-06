import 'dart:convert';

class Moeda {
  String icone;
  String nome;
  String sigla;
  double preco;
  bool isFavorita;

  Moeda(
      {required this.nome,
      required this.sigla,
      required this.icone,
      required this.preco,
      required this.isFavorita});

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'sigla': sigla,
      'icone': icone,
      'preco': preco,
      'isFavorita': isFavorita,
    };
  }

  factory Moeda.fromJson(Map<String, dynamic> jsonData) {
    return Moeda(
        nome: jsonData['nome'],
        sigla: jsonData['sigla'],
        icone: jsonData['icone'],
        preco: jsonData['preco'],
        isFavorita: jsonData['isFavorita']);
  }

  static Map<String, dynamic> toMap(Moeda moeda) => {
        'nome': moeda.nome,
        'sigla': moeda.sigla,
        'icone': moeda.icone,
        'preco': moeda.preco,
        'isFavorita': moeda.isFavorita,
      };

  static String encode(List<Moeda> moedas) => json.encode(
      moedas.map<Map<String, dynamic>>((moeda) => Moeda.toMap(moeda)).toList()
      );

  static List<Moeda> decode(String moedas) =>
      (json.decode(moedas) as List<dynamic>)
          .map<Moeda>((item) => Moeda.fromJson(item))
          .toList();

  void setFavorita(value) {
    isFavorita = value;
  }
}
