import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/interest_point.dart';
import '../services/interest_point_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final InterestPointService _service = InterestPointService();
  List<InterestPoint> _points = [];

  @override
  void initState() {
    super.initState();
    _loadInterestPoints();
  }

  Future<void> _loadInterestPoints() async {
    try {
      final data = await _service.fetchAll();
      for (var p in data) {
        debugPrint('🧭 ${p.name} → ${p.lat}, ${p.lon}');
      }
      setState(() {
        _points = data;
      });
    } catch (e) {
      debugPrint('Erro ao carregar pontos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mapa Histórico")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-30.8831, -55.5306),
          zoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.turista_app',
          ),
          MarkerLayer(
            markers: [
              ..._points
                  .where((p) => !p.lat.isNaN && !p.lon.isNaN)
                  .map(
                    (p) => Marker(
                      point: LatLng(p.lat, p.lon),
                      width: 60,
                      height: 60,
                      child: Tooltip(
                        message: '${p.name}\n${p.tipo}',
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.purple,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
            ],
          ),
        ],
      ),
    );
  }
}
