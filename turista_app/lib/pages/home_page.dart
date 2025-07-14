import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/user_sidebar.dart';
import 'flutter_map_page.dart';
import 'lista_pontos_page.dart';
import 'favoritos_page.dart';
import 'search_page.dart'; // <- Import da nova página de busca

class HomePageTurista extends StatefulWidget {
  const HomePageTurista({super.key});

  @override
  State<HomePageTurista> createState() => _HomePageTuristaState();
}

class _HomePageTuristaState extends State<HomePageTurista> {
  int _currentIndex = 0;

  // 🔑 Chave global para acessar o estado do mapa
  final GlobalKey<FlutterMapPageState> _mapKey = GlobalKey<FlutterMapPageState>();

  @override
  Widget build(BuildContext context) {
    // Lista de páginas na mesma ordem do CustomBottomNavBar
    final pages = [
      FlutterMapPage(key: _mapKey),         // 0 - Mapa
      const SearchPage(),                   // 1 - Busca com filtro
      const FavoritosPage(),                // 2 - Favoritos
      ListaPontosPage(                      // 3 - Lista com callback
        onPointSelected: (lat, lon) {
          setState(() {
            _currentIndex = 0;
          });

          // Aguarda o carregamento do mapa
          Future.delayed(const Duration(milliseconds: 300), () {
            final mapState = _mapKey.currentState;
            if (mapState != null) {
              mapState.goToLocation(LatLng(lat, lon));
            }
          });
        },
      ),
    ];

    return Scaffold(
      drawer: const UserSidebar(),
      appBar: AppBar(
        title: const Text('Uncovering History'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
