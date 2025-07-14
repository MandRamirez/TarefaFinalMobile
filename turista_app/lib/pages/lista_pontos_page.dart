import 'package:flutter/material.dart';
import '../models/interest_point.dart';
import '../services/interest_point_service.dart';

class ListaPontosPage extends StatefulWidget {
  final void Function(double lat, double lon)? onPointSelected;

  const ListaPontosPage({super.key, this.onPointSelected});

  @override
  State<ListaPontosPage> createState() => _ListaPontosPageState();
}

class _ListaPontosPageState extends State<ListaPontosPage> {
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
      setState(() {
        _points = data;
      });
    } catch (e) {
      debugPrint('Erro ao carregar pontos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _points.length,
      itemBuilder: (context, index) {
        final p = _points[index];
        return ListTile(
          leading: const Icon(Icons.place, color: Colors.deepPurple),
          title: Text(p.name),
          subtitle: Text('${p.tipo} — (${p.lat}, ${p.lon})'),
          onTap: () {
            if (widget.onPointSelected != null && p.lat != null && p.lon != null) {
              widget.onPointSelected!(p.lat!, p.lon!);
            }
          },
        );
      },
    );
  }
}
