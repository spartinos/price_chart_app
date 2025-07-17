// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/price_point.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<PricePoint>> fetchLiveData() async {
    final response = await http.get(Uri.parse('$baseUrl/get-live-data'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      return data.map((json) => PricePoint.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load live data');
    }
  }

  static Future<List<PricePoint>> fetchPredictions() async {
    final response = await http.get(Uri.parse('$baseUrl/get-predictions'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map(
            (json) => PricePoint(
              date: DateTime.parse(json['date']),
              price: json['prediction'].toDouble(),
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
