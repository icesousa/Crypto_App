import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';
import '../models/moeda.dart';
import 'package:intl/intl.dart';

import '../repositories/conta_repository.dart';

class MoedasDetalhesPage extends StatefulWidget {
  final Moeda moeda;
  const MoedasDetalhesPage({Key? key, required this.moeda}) : super(key: key);

  @override
  State<MoedasDetalhesPage> createState() => _MoedasDetalhesPageState();
}

class _MoedasDetalhesPageState extends State<MoedasDetalhesPage> {
  late NumberFormat real; 
  final _form = GlobalKey<FormState>(); //Key global para manipular formulario
  final _valor = TextEditingController(); // controller dos valores de form
  double quantidademoeda = 0; //quantidade de moeda comprada


  late ContaRepository conta; // declaração da instancia do ContaRepository

//Método para comprar e exibir uma snackbar na compra.
  comprarmoeda() async {
    if (_form.currentState!.validate()) { //se o formulario estiver com os campos validos / validado
    final conta = Provider.of<ContaRepository>(context, listen: false); //instancia do conta repository

      await conta.comprar(widget.moeda, double.parse(_valor.text)); // metodo compra a  ser executado se o formulario estiver valido

//Mostra a Snackbar com a quantidade de moedas seguido da sigla + texto
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text( '${quantidademoeda.toStringAsFixed(4)}  ${widget.moeda.sigla} ordem de  compra enviada'),
              const Icon(Icons.check, color: Colors.white,)
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  // inicio do build das telas
  Widget build(BuildContext context) {
// instancia do ContaRepository
        final conta = Provider.of<ContaRepository>(context, listen: false);
         //Definindo o formato do texto para PT/BR OU EN/US
         final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.moeda.nome)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 40, child: Image.asset(widget.moeda.icone)),
                const SizedBox(width: 10),
                Text(
                  real.format(widget.moeda.preco.toDouble()),
                  style: TextStyle(
                      fontSize: 24,
                      letterSpacing: -1,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w600
                      ),
                ),
              ],
            ),
            quantidademoeda > 0
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24, top: 10),
                      alignment: Alignment.center,
                      child: Text('$quantidademoeda ${widget.moeda.sigla}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(
                    height: 30,
                  ),
            Form(
              key: _form,
              child: TextFormField(
                maxLength: 8,
                onChanged: ((value) {
                  setState(() {
                    quantidademoeda = value.isEmpty
                        ? 0
                        : quantidademoeda = double.parse(value) / widget.moeda.preco;
                  });
                }),
                controller: _valor,
                style: const TextStyle(
                  fontSize: 20,
                ),
                decoration:  InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: 'Valor',
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  suffixText: loc['name'].toString(),
                ),
                
                inputFormatters: [
               
                 
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return ' Informe o valor da compra';
                  } else if (double.parse(value) < 50) {
                    return 'Compra minima é R\$ 50,00';
                  }else if(double.parse(value) > conta.saldo){
                  return 'saldo insuficiente';
              
                  }
                  return null;

                              }
  
                
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: comprarmoeda,
                style: const ButtonStyle(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Comprar'),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
