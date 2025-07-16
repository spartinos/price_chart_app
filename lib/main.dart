import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:price_chart_app/screens/price_chart_screen.dart';
// ignore: unused_import
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Login',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF756B49),
        useMaterial3: true,
      ),
      home: PriceChartScreen(),
    );
  }
}
