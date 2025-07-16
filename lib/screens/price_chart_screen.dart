import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceChartScreen extends StatefulWidget {
  @override
  _PriceChartScreenState createState() => _PriceChartScreenState();
}

class _PriceChartScreenState extends State<PriceChartScreen> {
  String selectedTab = 'All';
  String selectedTime = '1H';

  final List<String> tabs = ['Prices', 'Prediction', 'All'];
  final List<String> timeOptions = ['1H', '24H', '7D', '1M', '3M', '6M'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF665D45), // Custom olive background
      appBar: AppBar(
        title: const Text('CrEst'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(icon: const Icon(Icons.menu), onPressed: () {})],
      ),
      body: Padding(
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
            const SizedBox(height: 16),

            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabs.map((tab) {
                final isSelected = selectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTab = tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade700,
                        borderRadius: BorderRadius.circular(12),
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

            const SizedBox(height: 12),

            // Time Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: timeOptions.map((time) {
                final isSelected = selectedTime == time;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTime = time),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue : Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        time,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Chart (dummy data)
            Container(
              height: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [FlSpot(1, 40), FlSpot(2, 65), FlSpot(3, 50)],
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: [FlSpot(4, 44), FlSpot(5, 84), FlSpot(6, 44)],
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

            const SizedBox(height: 16),

            // Prices and Predictions
            Row(
              children: [
                Expanded(
                  child: _buildPriceList("Prices", [
                    {'time': 'Apr 01 10:00', 'price': '\$44,000'},
                    {'time': 'Apr 01 11:00', 'price': '\$65,000'},
                    {'time': 'Apr 01 12:00', 'price': '\$50,000'},
                  ]),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildPriceList("Prediction", [
                    {'time': 'Apr 01 13:00', 'price': '\$44,000'},
                    {'time': 'Apr 01 14:00', 'price': '\$84,000'},
                    {'time': 'Apr 01 15:00', 'price': '\$44,000'},
                  ]),
                ),
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

  Widget _buildPriceList(String title, List<Map<String, String>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        ...data.map(
          (item) => Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['time']!,
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  item['price']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
