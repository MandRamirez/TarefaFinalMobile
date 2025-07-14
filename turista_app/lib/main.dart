import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/configuracoes_page.dart'; // 👈 Página de configurações

void main() {
  runApp(const TuristaApp());
}

class TuristaApp extends StatelessWidget {
  const TuristaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 👈 Remove a faixa "DEBUG"
      title: 'Uncovering History - Turista',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange, // 👈 Cor base laranja agradável
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.orange),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: const HomePageTurista(),
      routes: {
        '/configuracoes': (context) => const ConfiguracoesPage(),
      },
    );
  }
}
