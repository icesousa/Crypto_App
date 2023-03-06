import 'package:flutter/material.dart';
import 'package:flutter_aula_1/configs/app_settings.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:flutter_aula_1/repositories/moeda_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/moeda.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {

  // Declaração de variáveis
  late NumberFormat real;
  late Map<String, String> loc;
  late List<Moeda> selecionadas = [];
  final tabela = MoedaRepository.tabela;
  late FavoritasRepository favoritas;

  // Método para ler a formatação de número (currency) com base na configuração de idioma do App
  readNumberFormart(){
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  // Método para exibir um botão na AppBar que permite ao usuário trocar o idioma do App
  changeLanguageButton(){
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$' : 'R\$';
  
    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(child: ListTile(
          leading: const Icon(Icons.swap_vert),
          title: Text('Usar $locale'),
          onTap: (){
            context.read<AppSettings>().setLocale(locale, name);
            Navigator.pop(context);
          },
        ) 
        )
      ],
    );
  }

  // Método para limpar a lista de moedas selecionadas
  limparSelecionadas(){
    setState(() {
      selecionadas = [];
    });
  }
  
  // Método para construir a AppBar, dinamicamente, dependendo se há ou não moedas selecionadas
  appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        title: const Center(child: Text('Crypto')),
      );
    } else {
      return AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  for (var item in tabela) {
                    if (!selecionadas.contains(item)) {
                      selecionadas.add(item);
                    }
                  }
                });
              },
              icon: const Icon(Icons.check_circle)
          ),
          // Chamando o método para exibir o botão de troca de idioma na AppBar
          changeLanguageButton(),
        ],
        title: Text(selecionadas.length > 1
            ? ('${selecionadas.length} Moedas Selecionadas')
            : ('${selecionadas.length} Moeda Selecionada')),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        toolbarTextStyle: const TextTheme(
            titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )).bodyMedium,
        titleTextStyle: const TextTheme(
            titleLarge: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        )).titleLarge,
      );
    }
  }

selecionarMoeda(moeda){
  setState(() {
    selecionadas.contains(tabela[moeda]) 
    ? selecionadas.remove(tabela[moeda])
    : selecionadas.add(tabela[moeda]);
  });
}

///////////////// INICIO DO BUILD //////////////////
  @override
  Widget build(BuildContext context) {
    
    readNumberFormart();
    
favoritas = Provider.of<FavoritasRepository>(context);
    return Scaffold(
        appBar: appBarDinamica(),
        body: ListView.separated(
          itemBuilder: (BuildContext context, int moeda) {
            return ListTile(
              onTap: () => selecionadas.isEmpty ? MoedaRepository().mostrarDetalhes(context, tabela[moeda]) :  selecionarMoeda(moeda),
              onLongPress: () => selecionarMoeda(moeda),
               
              
              selected: selecionadas.contains(tabela[moeda]),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),


              leading: (selecionadas.contains(tabela[moeda]))
                  ? const CircleAvatar(
                      child: Icon(Icons.check),
                    )
                  : SizedBox(
                      width: 35,
                      child: Image.asset(tabela[moeda].icone),
                    ),


              title: 
                
             
                   Row(
                      children: [
                        Text(
                          tabela[moeda].nome,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        if (favoritas.lista.any((fav) => fav.sigla == tabela[moeda].sigla))
                        const Icon(Icons.star)
                      ],
                    ),
                  
                  
                    

                    
              trailing: Text(real.format(tabela[moeda].preco)),
              selectedTileColor: Colors.blueGrey[50],
            );
          },
          padding: const EdgeInsets.all(16),
          separatorBuilder: ((_, __) => const Divider()),
          itemCount: tabela.length,
        ),

///////////////////// ADICIONAR FAVORITO//////////////////////////        
        floatingActionButton: selecionadas.isNotEmpty
            ? FloatingActionButton(
                onPressed: () =>  favoritas.toggleFavorite(selecionadas),
                child: const Icon(Icons.star, color: Colors.blue,),
              )
            : null);
  }
}
