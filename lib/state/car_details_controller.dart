import 'package:flutter/material.dart';
import 'package:dai_auto_app/data/car_repository.dart';
import 'package:dai_auto_app/models/car.dart';

class CarDetailsController extends ChangeNotifier {
  CarDetailsController({required this.repo});

  final CarRepository repo;

  Car? car;
  bool isLoading = false;
  String? error;

  Future<void> load(String carId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      car = await repo.getCarById(carId);
    } catch (e) {
      error = 'Failed to load car details';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}