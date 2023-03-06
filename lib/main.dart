import 'package:flutter/material.dart';
import 'package:flutter_aula_1/configs/app_settings.dart';
import 'package:flutter_aula_1/repositories/conta_repository.dart';
import 'package:flutter_aula_1/repositories/favoritas_repository.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => ContaRepository())),

        ChangeNotifierProvider(create: ((context) => AppSettings())),
        ChangeNotifierProvider(create: ((context) => FavoritasRepository())),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HomePage()
    );
  }
}
