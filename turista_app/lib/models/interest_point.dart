class InterestPoint {
  final String id;
  final String name;
  final String tipo;
  final double lat;
  final double lon;

  InterestPoint({
    required this.id,
    required this.name,
    required this.tipo,
    required this.lat,
    required this.lon,
  });

  factory InterestPoint.fromJson(Map<String, dynamic> json) {
    return InterestPoint(
      id: json['objectId'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      tipo: json['tipo'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }
}
