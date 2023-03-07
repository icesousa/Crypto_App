import 'package:flutter/material.dart';
import 'package:flutter_aula_1/configs/app_settings.dart';
import 'package:flutter_aula_1/repositories/conta_repository.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/posicao.dart';

class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});

  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  int index = 0;
  double totalCarteira = 0;
  double saldo = 0;
  late NumberFormat real;
  late ContaRepository conta;

  String graficoLabel = '';
  double graficoValor = 0;
  List<Posicao> carteira = [];
  
  

  @override
  Widget build(BuildContext context) {
    conta = context.watch<ContaRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    saldo = conta.saldo;
        setTotalCarteira();


    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 48, bottom: 8),
                  child: Text(
                    'Valor da Carteira',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              real.format(totalCarteira),
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            loadGrafico(),
            loadHistorico(),
            operacoesButton(),
          ],
        ),
      ),
    );
  }

  setTotalCarteira() {
    final carteiraList = conta.carteira;
    setState(() {
      totalCarteira = conta.saldo;
      for (var posicao in carteiraList) {
        totalCarteira += posicao.moeda.preco * posicao.quantidade;
      }
    });
  }



setGraficoDados(int index) {
if (index < 0 ) return;
if( index == carteira.length){
  graficoLabel = 'Saldo';
  graficoValor  = conta.saldo;
}else{
  graficoLabel = '${carteira[index].moeda.nome} | ${carteira[index].quantidade.toStringAsFixed(3)}';
  graficoValor = carteira[index].moeda.preco * carteira[index].quantidade;
}

}



loadCarteira(){

  setGraficoDados(index);
  carteira = conta.carteira;
  final tamanhoLista = carteira.length + 1;

  return List.generate(tamanhoLista, (i) {
    final isTouched = i == index;
    final isSaldo = i == tamanhoLista -1;
    final fontSize = isTouched ? 18.0 : 14.0;
    final radius = isTouched ? 60.0 : 50.0;
    final color = isTouched ? Colors.tealAccent : Colors.tealAccent[400];
  double porcentagem = 0;

  if(!isSaldo){
    porcentagem =
      carteira[i].moeda.preco * carteira[i].quantidade / totalCarteira;

  }else{
    porcentagem = (conta.saldo > 0) ? conta.saldo / totalCarteira : 0;
  }
  porcentagem *= 100;

  return PieChartSectionData(
    color: color,
    value: porcentagem,
    title: '${porcentagem.toStringAsFixed(0)}%',
    radius: radius,
    titleStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    )
  );





  });

}

int maxHistorico = 5;

loadHistorico(){
  final historico = conta.historico;
  final date = DateFormat('dd/MM/yyyy - hh:mm');
    List<Widget> widgets = [];


 


for(var i = 0; i < historico.length && i < maxHistorico; i++){
  var operacao = historico[i];
      widgets.add(ListTile( 
    title: Row(
      children: [
        Text(operacao.moeda.nome, style:  const TextStyle(
          fontWeight: FontWeight.w500
        ), ),
        
        Text(' | ${operacao.quantidade.toStringAsFixed(3)}')
      ],
    ),
    subtitle: Text(date.format(operacao.dataOperacao)),
    trailing: Text(real.format(operacao.moeda.preco * operacao.quantidade)
    )));    
        widgets.add( const Divider());


}
return Column(children: widgets,);

}

operacoesButton(){
 final  historico = conta.historico;
  if(historico.length >5 && maxHistorico <=5) {
    return TextButton(onPressed: (){
      setState(() {
        maxHistorico = historico.length;
      });
    }, child: const Text('Ver todas transações', style: TextStyle(fontSize: 18),));
  }
  return TextButton(onPressed: (){
      setState(() {
        maxHistorico = 5;
      });
    }, child: const Text('Ver menos', style: TextStyle(fontSize: 18),),);
}

  







  loadGrafico() {
    return (conta.saldo <= 0)
        ? Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                      sectionsSpace: 5,
                      centerSpaceRadius: 110,
                      sections: loadCarteira(),
                      pieTouchData: PieTouchData(touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        setState(() {
                          if (event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                            index = -1;
                            return;
                          }
                          index = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          setGraficoDados(index);
                        });
                      },
                          
                          
                          
                          
                          )
                      
                      ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graficoLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Text(real.format(graficoValor),
                      style: const TextStyle(fontSize: 28, color: Colors.teal))
                ],
              )
            ],
          );
  }
}
