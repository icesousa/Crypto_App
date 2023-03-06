import 'package:flutter/material.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:flutter_aula_1/repositories/moeda_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';
import '../models/moeda.dart';

class CustomMoedaCard extends StatefulWidget {
  const CustomMoedaCard({ required this.moeda, super.key});

  @override
  State<CustomMoedaCard> createState() => _CustomCardState();
  final Moeda moeda;
}

class _CustomCardState extends State<CustomMoedaCard> {
  static Map<String, Color> precoColor = <String, Color>{
    'up' : Colors.teal,
    'down' : Colors.indigo
  } ;

   final List<String> list = [];
   late FavoritasRepository favoritas;

   late Map<String, String> loc;

   late NumberFormat real; 

   
    
   


readNumberFormart(){
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);

  }


  @override
  Widget build(BuildContext context) {
      readNumberFormart();

    favoritas = Provider.of<FavoritasRepository>(context);
    return  Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
      child: Card(
        margin: const EdgeInsets.only(top: 12),
        elevation: 2,
        child: InkWell(
          onTap: () => MoedaRepository().mostrarDetalhes(context, widget.moeda),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20,),
            child: Container(
            
              
              
              child: Row(children: [
                Image.asset(widget.moeda.icone, height: 45),
               const SizedBox(width: 15),
                
                Expanded(
                  child: Container(
                
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text( widget.moeda.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          
                
                        ),
                        ),
                        Text(widget.moeda.sigla,
                        style: const TextStyle( color: Colors.black45),),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                    color: precoColor['down']!.withOpacity(0.05),
                    border: Border.all(
                      color: precoColor['down']!.withOpacity(0.04),
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(100))
                  ),
                  
                  child: Text(real.format(widget.moeda.preco),
                  style: TextStyle(
                    fontSize: 16,
                    color: precoColor['down'],
                    letterSpacing: -1,
                  ),
                  ),
                  ),
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert),
                    
                    
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(
                        child: ListTile(title: const Text('Remover das favoritas'),
                        onTap: (() {
                          Navigator.pop(context);
                          Provider.of<FavoritasRepository>(context, listen: false)
                          .remove(widget.moeda);
                        }
                        ),
                        )
                        )
                    
                    ],
                    
                    
                  )
                ],
                ),
            
            ),
          ),
        ), 
        ),
    );
  }
}
