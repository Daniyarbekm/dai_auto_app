import 'package:flutter/material.dart';

class Car {
  final String id;
  final String brand;
  final String model;
  final double rating;
  final String imageUrl;

  final int seats;
  final String fuel;
  final String type;
  final int year;

  final List<String> features;

  final int pricePerHour;
  final int pricePerDay;

  final Color accentColor;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.rating,
    required this.imageUrl,
    required this.seats,
    required this.fuel,
    required this.type,
    required this.year,
    required this.features,
    required this.pricePerHour,
    required this.pricePerDay,
    required this.accentColor,
  });
}