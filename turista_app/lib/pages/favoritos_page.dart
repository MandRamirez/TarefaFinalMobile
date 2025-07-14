import 'package:flutter/material.dart';
import '../db/favorite_point_db.dart';
import '../models/favorite_point.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  List<FavoritePoint> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final points = await FavoritePointDatabase().getAllPoints();
    setState(() {
      _favorites = points;
    });
  }

  Future<void> _deleteFavorite(int id) async {
    await FavoritePointDatabase().delete(id);
    await _loadFavorites(); // Atualiza a lista após excluir
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ponto removido dos favoritos.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pontos Favoritos',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _favorites.isEmpty
                  ? const Center(child: Text('Nenhum ponto salvo.'))
                  : ListView.builder(
                      itemCount: _favorites.length,
                      itemBuilder: (context, index) {
                        final point = _favorites[index];
                        return ListTile(
                          leading: const Icon(Icons.favorite, color: Colors.pink),
                          title: Text(point.name),
                          subtitle: Text('Lat: ${point.lat}, Lon: ${point.lon}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteFavorite(point.id!);
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
