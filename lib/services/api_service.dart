import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/price_point.dart';

class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:8000'; // <-- εναλλακτικά βάλε το local IP σου

  static Future<List<PricePoint>> fetchLiveData() async {
    final response = await http.get(Uri.parse('$baseUrl/get-live-data'));

    print('📦 [LIVE DATA] Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('✅ [LIVE DATA] Decoded JSON: $decoded');

      final List data = decoded['data']; // Εδώ θα σκάσει αν δεν έχει "data"
      return data.map((json) => PricePoint.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load live data');
    }
  }

  static Future<List<PricePoint>> fetchPredictions() async {
    final response = await http.get(Uri.parse('$baseUrl/get-predictions'));

    print('📦 [PREDICTIONS] Raw response body: ${response.body}');

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      print('✅ [PREDICTIONS] Decoded JSON: $decoded');

      final List data = decoded; // Εδώ περιμένει σκέτη λίστα
      return data
          .map(
            (json) => PricePoint(
              date: DateTime.parse(json['date']),
              price: json['close'].toDouble(),
            ),
          )
          .toList();
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}
