import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/price_point.dart';
import '../services/api_service.dart';
import 'settings_screen.dart';

class PriceChartScreen extends StatefulWidget {
  @override
  _PriceChartScreenState createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends State<PriceChartScreen> {
  String selectedTab = 'Prices';
  String selectedTime = '1H';

  final List<String> tabs = ['Prices', 'Prediction', 'All'];
  final List<String> timeOptions = ['1H', '24H', '7D', '1M', '3M', '6M'];

  List<PricePoint> priceData = [];
  List<PricePoint> predictionData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final live = await ApiService.fetchLiveData();
      final preds = await ApiService.fetchPredictions();
      setState(() {
        priceData = live;
        predictionData = preds;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  List<FlSpot> generateSpots(List<PricePoint> data) {
    return data.map((e) {
      final x = e.date.millisecondsSinceEpoch.toDouble();
      return FlSpot(x, e.price);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF665D45),
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final allData = [...priceData, ...predictionData];
    final minX = allData
        .map((e) => e.date.millisecondsSinceEpoch.toDouble())
        .reduce((a, b) => a < b ? a : b);
    final maxX = allData
        .map((e) => e.date.millisecondsSinceEpoch.toDouble())
        .reduce((a, b) => a > b ? a : b);
    final minY =
        allData.map((e) => e.price).reduce((a, b) => a < b ? a : b) * 0.95;
    final maxY =
        allData.map((e) => e.price).reduce((a, b) => a > b ? a : b) * 1.05;

    return Scaffold(
      backgroundColor: const Color(0xFF665D45),
      appBar: AppBar(
        title: const Text('CrEst'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Price Chart',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 40,
                child: Row(
                  children: tabs.map((tab) {
                    final isSelected = selectedTab == tab;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => selectedTab = tab),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : Colors.grey.shade700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            tab,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: timeOptions.map((time) {
                    final isSelected = selectedTime == time;
                    return GestureDetector(
                      onTap: () => setState(() => selectedTime = time),
                      child: Container(
                        width: 60,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue
                              : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          time,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 250,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: LineChart(
                        LineChartData(
                          minX: minX,
                          maxX: maxX,
                          minY: minY,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: generateSpots(priceData),
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: generateSpots(predictionData),
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                              dashArray: [5, 5],
                            ),
                          ],
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 5,
                                getTitlesWidget: (value, _) => Text(
                                  value.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: (maxX - minX) / 5,
                                getTitlesWidget: (value, _) {
                                  final date =
                                      DateTime.fromMillisecondsSinceEpoch(
                                        value.toInt(),
                                      );
                                  final formatted = DateFormat(
                                    'MM/dd',
                                  ).format(date);
                                  return Text(
                                    formatted,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 5,
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.white30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegendDot(Colors.blue, "Live Data"),
                        const SizedBox(width: 16),
                        _buildLegendDot(Colors.orange, "Prediction"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDataColumn("Prices", priceData),
                  const SizedBox(width: 16),
                  _buildDataColumn("Prediction", predictionData),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Market Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Current Price:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '\$${priceData.last.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Next Prediction:",
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          '\$${predictionData.last.price.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataColumn(String title, List<PricePoint> data) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final point = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MM/dd HH:mm').format(point.date),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '\$${point.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
