// lib/models/price_point.dart

class PricePoint {
  final DateTime date;
  final double price;

  PricePoint({required this.date, required this.price});

  factory PricePoint.fromJson(Map<String, dynamic> json) {
    return PricePoint(
      date: DateTime.parse(json['date']),
      price: (json['close'] ?? json['prediction']).toDouble(),
    );
  }
}
