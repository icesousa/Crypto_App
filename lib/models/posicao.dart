import 'package:flutter_aula_1/models/moeda.dart';

class Posicao {
  Moeda moeda;
  double quantidade;

Posicao({required this.moeda,
required this.quantidade});



factory Posicao.fromMap(Map<String, dynamic> map){
  return Posicao
  (
    moeda: map['moeda'] , quantidade: map['quantidade']
  );
}


Map<String, dynamic> toMap(){
  return {
    'moeda': moeda,
    'quantidade' : quantidade,
  };
}

@override
  String toString() {
    return 'Posicao{moeda: $moeda, quantidade: $quantidade}';
  }


}