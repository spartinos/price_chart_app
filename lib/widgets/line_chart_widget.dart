import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/price_point.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> data;

  LineChartWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text('No data'));
    }

    data.sort((a, b) => a.date.compareTo(b.date));

    final spots = data
        .map((e) => FlSpot(e.date.millisecondsSinceEpoch.toDouble(), e.price))
        .toList();

    final minX = spots.first.x;
    final maxX = spots.last.x;
    final minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxX - minX) / 4,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text(
                  '${date.month}/${date.day}',
                  style: TextStyle(fontSize: 10),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: (maxY - minY) / 4,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1)),
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: spots,
            barWidth: 3,
            color: Colors.blueAccent,
            dotData: FlDotData(show: false),
          ),
        ],
        minX: minX,
        maxX: maxX,
        minY: minY,
        maxY: maxY,
      ),
    );
  }
}
