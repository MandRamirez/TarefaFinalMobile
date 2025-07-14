import 'package:flutter/material.dart';

// Classe modelo para o ponto de interesse
class InterestPoint {
  final String nome;
  final String tipo;
  final double lat;
  final double lon;

  InterestPoint({
    required this.nome,
    required this.tipo,
    required this.lat,
    required this.lon,
  });
}

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  // Lista simulada dos pontos (substitua com dados reais depois)
  final List<InterestPoint> _allPoints = [
    InterestPoint(nome: 'Palácio Moysés Vianna', tipo: 'Prédio histórico', lat: -30.885, lon: -55.51),
    InterestPoint(nome: 'Catedral de Santana', tipo: 'Construção religiosa', lat: -30.8855, lon: -55.513),
    InterestPoint(nome: 'Praça General Osório', tipo: 'Praça', lat: -30.8859, lon: -55.5301),
    InterestPoint(nome: 'Teatro Municipal de Rivera', tipo: 'Teatro', lat: -30.8982, lon: -55.5511),
    InterestPoint(nome: 'Museu David Canabarro', tipo: 'Museu', lat: -30.8842, lon: -55.5288),
    InterestPoint(nome: 'Parque Internacional', tipo: 'Parque binacional', lat: -30.89, lon: -55.5355),
    InterestPoint(nome: 'Igreja Matriz de Rivera', tipo: 'Igreja', lat: -30.8989, lon: -55.5519),
    InterestPoint(nome: 'Praça General Artigas', tipo: 'Praça pública', lat: -30.905182, lon: -55.550468),
    InterestPoint(nome: 'Shopping Siñeriz', tipo: 'Centro comercial', lat: -30.915821, lon: -55.556998),
  ];

  List<InterestPoint> _filteredPoints = [];

  @override
  void initState() {
    super.initState();
    _filteredPoints = _allPoints;
    _searchController.addListener(_filterResults);
  }

  void _filterResults() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPoints = _allPoints.where((point) {
        return point.nome.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Campo de busca
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Buscar por nome...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        // Lista de resultados
        Expanded(
          child: ListView.builder(
            itemCount: _filteredPoints.length,
            itemBuilder: (context, index) {
              final point = _filteredPoints[index];
              return ListTile(
                leading: const Icon(Icons.location_on, color: Colors.deepPurple),
                title: Text(point.nome),
                subtitle: Text('${point.tipo} — (${point.lat}, ${point.lon})'),
              );
            },
          ),
        ),
      ],
    );
  }
}
