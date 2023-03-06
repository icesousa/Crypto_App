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
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  final _form = GlobalKey<FormState>();
  final _valor = TextEditingController();
  double quantidade = 0;


  late ContaRepository conta;

  comprarmoeda() async {
    if (_form.currentState!.validate()) {
    final conta = Provider.of<ContaRepository>(context, listen: false);

      await conta.comprar(widget.moeda, double.parse(_valor.text));


      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text( '${quantidade.toStringAsFixed(4)}  ${widget.moeda.sigla} ordem de  compra enviada'),
              const Icon(Icons.check, color: Colors.white,)
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

        final conta = Provider.of<ContaRepository>(context, listen: false);
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
            quantidade > 0
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24, top: 10),
                      alignment: Alignment.center,
                      child: Text('$quantidade ${widget.moeda.sigla}',
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
                    quantidade = value.isEmpty
                        ? 0
                        : quantidade = double.parse(value) / widget.moeda.preco;
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
