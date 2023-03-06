import 'package:flutter/material.dart';
import 'package:flutter_aula_1/widgets/moedacard.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import '../models/moeda.dart';
import '../repositories/moeda_repository.dart';
import 'detalhes_moedas_page.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
    final tabela = MoedaRepository.tabela;
    late FavoritasRepository favoritas;


    mostrarDetalhes(Moeda moeda) {
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedasDetalhesPage(moeda: moeda),
      ),
    );


  }
  @override
  Widget build(BuildContext context) {

    favoritas = Provider.of<FavoritasRepository>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Moedas Favoritas')),
        
      ),
      body: Container(
        
        child: Consumer<FavoritasRepository>(
          builder: ((context, favoritas, child) {
          return  favoritas.lista.isEmpty 
            ? const ListTile(
              leading: Padding(
                padding: EdgeInsets.only(left: 30),
                child: Icon(Icons.star, size: 30),
              ),
              title: Text('Ainda não há moedas favoritas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              )),
              )
             : ListView.builder(
            itemBuilder: (BuildContext context, int moeda ){
              return CustomMoedaCard(moeda: favoritas.lista[moeda]);
             },
          itemCount: favoritas.lista.length,  
           
           );
            
          })
         
        ),
      ),
    );
  }
}