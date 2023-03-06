import 'package:flutter/material.dart';
import 'package:flutter_aula_1/pages/moedas_page.dart';

import 'carteira_page.dart';
import 'conta_page.dart';
import 'favoritas_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    super.initState();
  }

  setPage(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(label: 'Moedas', icon: Icon(Icons.monetization_on)),
          BottomNavigationBarItem(label: 'Favoritas', icon: Icon(Icons.star)),
          BottomNavigationBarItem(label: 'Carteira',icon: Icon(Icons.account_balance)),
           BottomNavigationBarItem(label: 'Conta', icon: Icon(Icons.account_balance_wallet)),
        ],
        onTap: ((pagina) {
          pageController.animateToPage(pagina,
              duration: const Duration(milliseconds: 400), curve: Curves.ease);
        }),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: setPage,
        children: const [
          MoedasPage(),
          FavoritasPage(),
          CarteiraPage(),
          ContaPage(),
        ],
      ),
    );
  }
}
