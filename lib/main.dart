import 'package:flutter/material.dart';
import 'screens/car_details_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CarDetailsScreen(carId: '1'),
    );
  }
}
