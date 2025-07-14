import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/interest_point.dart';

class InterestPointService {
  final String apiUrl = 'https://l8rlq1pr-8080.brs.devtunnels.ms/api/interest-points';

  Future<List<InterestPoint>> fetchAll() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => InterestPoint.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao buscar pontos (${response.statusCode}): ${response.body}');
    }
  }
}
