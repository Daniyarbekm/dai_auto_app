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

  factory Car.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final rawName = json['name']?.toString();
    final brand = json['brand']?.toString() ??
        (rawName != null && rawName.contains(' ')
            ? rawName.split(' ').first
            : (rawName ?? ''));
    final model = json['model']?.toString() ??
        (rawName != null && rawName.contains(' ')
            ? rawName.split(' ').skip(1).join(' ')
            : 'Model');

    final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;

    final imageUrl = json['imageUrl']?.toString() ??
        json['image']?.toString() ??
        '';

    final seats = (json['seats'] as num?)?.toInt() ?? 4;
    final fuel = json['fuel']?.toString() ?? 'Petrol';
    final type = json['type']?.toString() ?? '';
    final year = (json['year'] as num?)?.toInt() ?? DateTime.now().year;

    final featuresRaw = json['features'];
    final features = featuresRaw is List
        ? featuresRaw.map((e) => e.toString()).toList()
        : <String>[];

    final pricePerHour = (json['pricePerHour'] as num?)?.toInt() ??
        (json['price'] as num?)?.toInt() ??
        0;
    final pricePerDay = (json['pricePerDay'] as num?)?.toInt() ??
        (json['price'] as num?)?.toInt() ??
        0;

    final accentColorValue = json['accentColor']?.toString();
    final accentColor = accentColorValue != null
        ? Color(int.tryParse(accentColorValue) ?? 0xFFD6A34A)
        : const Color(0xFFD6A34A);

    return Car(
      id: id,
      brand: brand,
      model: model,
      rating: rating,
      imageUrl: imageUrl,
      seats: seats,
      fuel: fuel,
      type: type,
      year: year,
      features: features,
      pricePerHour: pricePerHour,
      pricePerDay: pricePerDay,
      accentColor: accentColor,
    );
  }
}