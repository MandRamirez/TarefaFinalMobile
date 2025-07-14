import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Imports do banco de dados
import '../db/favorite_point_db.dart';
import '../models/favorite_point.dart';

class FlutterMapPage extends StatefulWidget {
  const FlutterMapPage({super.key});

  @override
  FlutterMapPageState createState() => FlutterMapPageState();
}

class FlutterMapPageState extends State<FlutterMapPage> {
  final MapControllerImpl _mapController = MapControllerImpl();
  LatLng? _currentPosition;
  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _getCurrentLocation();
    await _loadInterestPoints();
    await _loadFavoritePoints(); // ✅ Carrega pontos locais do SQLite
  }

  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    if (!status.isGranted) return;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  Future<void> _loadInterestPoints() async {
    const apiUrl =
        'https://l8rlq1pr-8080.brs.devtunnels.ms/api/interest-points';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      final List<Marker> markers = data.map((item) {
        final lat = item['lat']?.toDouble() ?? 0.0;
        final lon = item['lon']?.toDouble() ?? 0.0;
        return Marker(
          point: LatLng(lat, lon),
          width: 40,
          height: 40,
          child: const Icon(
            Icons.location_on,
            color: Colors.deepPurple,
            size: 35,
          ),
        );
      }).toList();

      setState(() {
        _markers.addAll(markers);
      });
    } else {
      debugPrint('Erro ao carregar pontos: ${response.statusCode}');
    }
  }

  Future<void> _loadFavoritePoints() async {
    final favorites = await FavoritePointDatabase().getAllPoints();

    final localMarkers = favorites.map((fav) {
      return Marker(
        point: LatLng(fav.lat, fav.lon),
        width: 40,
        height: 40,
        child: const Icon(Icons.favorite, color: Colors.pink, size: 35),
      );
    }).toList();

    setState(() {
      _markers.addAll(localMarkers);
    });
  }

  void goToLocation(LatLng point) {
    _mapController.move(point, 16.0);
  }

  void _onMapLongPress(TapPosition tapPosition, LatLng point) {
    final nomeController = TextEditingController();
    final descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Ponto aos Favoritos'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final nome = nomeController.text.trim();
              final descricao = descricaoController.text.trim();

              if (nome.isNotEmpty) {
                // 1. Adiciona marcador no mapa
                setState(() {
                  _markers.add(
                    Marker(
                      point: point,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.pink,
                        size: 35,
                      ),
                    ),
                  );
                });

                // 2. Salva no banco local
                final novoFavorito = FavoritePoint(
                  name: nome,
                  lat: point.latitude,
                  lon: point.longitude,
                );

                await FavoritePointDatabase().insert(novoFavorito);

                // 3. Feedback e fecha diálogo
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ponto salvo nos favoritos!')),
                );
              } else {
                // Nome obrigatório
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um nome para o ponto.'),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_currentPosition == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition!,
        initialZoom: 14,
        onLongPress: _onMapLongPress,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.turista_app',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _currentPosition!,
              width: 80,
              height: 80,
              child: const Icon(
                Icons.person_pin_circle,
                size: 45,
                color: Colors.red,
              ),
            ),
            ..._markers,
          ],
        ),
      ],
    );
  }
}
