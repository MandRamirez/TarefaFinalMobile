class FavoritePoint {
  final int? id;
  final String name;
  final double lat;
  final double lon;

  FavoritePoint({
    this.id,
    required this.name,
    required this.lat,
    required this.lon,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'lat': lat,
      'lon': lon,
    };
  }

  factory FavoritePoint.fromMap(Map<String, dynamic> map) {
    return FavoritePoint(
      id: map['id'] as int?,
      name: map['name'] as String,
      lat: (map['lat'] as num).toDouble(),
      lon: (map['lon'] as num).toDouble(),
    );
  }
}
