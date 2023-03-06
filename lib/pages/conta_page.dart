import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aula_1/configs/app_settings.dart';
import 'package:flutter_aula_1/repositories/conta_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ContaPage extends StatefulWidget {
  const ContaPage({super.key});

  @override
  State<ContaPage> createState() => _ContaPageState();
}

class _ContaPageState extends State<ContaPage> {
  @override
  Widget build(BuildContext context) {
    final conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    NumberFormat real =
        NumberFormat.currency(locale: loc['locale'], name: loc['name']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conigurações de Conta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Saldo'),
              subtitle: Text(
                real.format(conta.saldo),
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.indigo,
                ),
              ),
              trailing: IconButton(onPressed: updateSaldo,
               icon: const Icon(Icons.edit)
               ),
            )
          ],
        ),
      ),
    );
  }

updateSaldo() async{
final form = GlobalKey<FormState>();
final valor = TextEditingController();
final conta = context.read<ContaRepository>();

valor.text = conta.saldo.toString();

AlertDialog dialog = AlertDialog(
title: const Text('Atualizar Saldo'),
content: Form(  
key: form,

child:TextFormField(

  controller: valor,
  keyboardType: TextInputType.number,
  inputFormatters: [
    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
  ],
  validator: (value) {
    
    if(value!.isEmpty) return 'Informe o valor do saldo';
    return null;
  },
  
),


),
actions: [
  TextButton(onPressed: ()=> Navigator.pop(context), child: const Text('CANCELAR')),
    TextButton(onPressed: (){
      if(form.currentState!.validate()) { 
        conta.setSaldo(double.parse(valor.text));
        Navigator.pop(context);
      }
    }, child: const Text('SALVAR')),

],
);

showDialog(context: context, builder: (context) => dialog);
}


}

