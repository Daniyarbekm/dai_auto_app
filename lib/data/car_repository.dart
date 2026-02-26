import 'dart:async';
import 'package:flutter/material.dart';
import '../models/car.dart';

abstract class CarRepository {
  Future<Car> getCarById(String id);
}

class MockCarRepository implements CarRepository {
  @override
  Future<Car> getCarById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));

    return const Car(
      id: 'car_1',
      brand: 'TESLA',
      model: 'Model 3',
      rating: 4.9,
      imageUrl:
      'https://images.unsplash.com/photo-1549921296-3c81f0f89a44?auto=format&fit=crop&w=1500&q=80',
      seats: 5,
      fuel: 'Electric',
      type: 'Auto',
      year: 2024,
      features: ['Autopilot', 'Premium Audio', 'Heated Seats', 'Navigation'],
      pricePerHour: 15,
      pricePerDay: 89,
      accentColor: Color(0xFFD6A34A),
    );
  }
}