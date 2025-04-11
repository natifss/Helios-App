import 'package:flutter/material.dart';
import 'package:helios/pages/pagina_principal_ocorrencias.dart';
import 'package:helios/pages/historico_ocorrencias_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Ocorrências',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: PaginaPrincipalOcorrencias(),
      routes: {
        '/historico': (context) => HistoricoOcorrenciasPage(),
      },
    );
  }
}
