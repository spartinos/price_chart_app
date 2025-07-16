import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'settings_screen.dart'; // Ensure this file exists in your screens folder

class PriceChartScreen extends StatefulWidget {
  @override
  _PriceChartScreenState createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends State<PriceChartScreen> {
  String selectedTab = 'Prices';
  String selectedTime = '1H';

  final List<String> tabs = ['Prices', 'Prediction', 'All'];
  final List<String> timeOptions = ['1H', '24H', '7D', '1M', '3M', '6M'];

  final List<Map<String, String>> priceData = [
    {'time': 'Apr 01 10:00', 'price': '\$44,000'},
    {'time': 'Apr 01 11:00', 'price': '\$65,000'},
    {'time': 'Apr 01 12:00', 'price': '\$50,000'},
  ];

  final List<Map<String, String>> predictionData = [
    {'time': 'Apr 01 13:00', 'price': '\$44,000'},
    {'time': 'Apr 01 14:00', 'price': '\$84,000'},
    {'time': 'Apr 01 15:00', 'price': '\$44,000'},
  ];

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title
            const Text(
              'Price Chart',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // Tabs
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

            // Time filters
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
                        color: isSelected ? Colors.blue : Colors.grey.shade600,
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

            // Chart
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 40),
                        FlSpot(1, 65),
                        FlSpot(2, 50),
                        FlSpot(3, 70),
                        FlSpot(4, 30),
                        FlSpot(5, 90),
                      ],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    ),
                    LineChartBarData(
                      spots: [
                        FlSpot(0, 44),
                        FlSpot(1, 84),
                        FlSpot(2, 44),
                        FlSpot(3, 60),
                        FlSpot(4, 80),
                        FlSpot(5, 40),
                      ],
                      isCurved: true,
                      color: Colors.orange,
                      barWidth: 3,
                      dashArray: [5, 5],
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Data Tables
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDataColumn("Prices", priceData),
                const SizedBox(width: 16),
                _buildDataColumn("Prediction", predictionData),
              ],
            ),
            const SizedBox(height: 16),

            // Market Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Market Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Current Price:",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text("\$70,000", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Next Prediction:",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text("\$44,000", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataColumn(String title, List<Map<String, String>> data) {
    return SizedBox(
      width: 150,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade700,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: data
                  .map((item) => _buildTableRow(item['time']!, item['price']!))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(String time, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            time,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(color: Colors.grey, height: 16),
        ],
      ),
    );
  }
}
