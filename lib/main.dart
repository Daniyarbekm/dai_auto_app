// import 'package:flutter/material.dart';
// import 'screens/car_details_screen.dart';
//
// void main() => runApp(const MyApp());
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: const EditProfilePage(),
//   //    home: CarDetailsScreen(carId: 'car_1'),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:hermes/core/theme/app_theme.dart';
// import 'package:hermes/features/auth/presentation/login_page.dart';
// import 'package:hermes/features/home/home_page.dart';
// import 'package:hermes/features/profile/edit_profile_page.dart';
// import 'features/cars/car.dart';
// import 'package:hermes/features/cars/select_car_page.dart';
// import 'package:hermes/features/home/splash_page.dart'; // потом вернёшь
//
// void main() {
// runApp(const HermesApp());
// }
//
// class HermesApp extends StatelessWidget {
// const HermesApp({super.key});
//
// @override
// Widget build(BuildContext context) {
// // 🔥 Mock данные для теста страницы
// final List<Car> cars = [
// Car(
// id: 1,
// name: "Tesla Model 3",
// image:
// "https://images.unsplash.com/photo-1560958089-b8a1929cea89",
// price: 15,
// rating: 4.9,
// type: "Electric",
// ),
// Car(
// id: 2,
// name: "BMW M4",
// image:
// "https://images.unsplash.com/photo-1502877338535-766e1452684a",
// price: 20,
// rating: 4.8,
// type: "Sport",
// ),
// ];
//
// return MaterialApp(
// debugShowCheckedModeBanner: false,
// theme: AppTheme.darkTheme,
//
// // 🔥 Для теста SelectCarPage
// //home: SelectCarPage(cars: cars),
//
// // 🔁 Потом вернёшь обратно:
// home: const EditProfilePage(),
// );
// }
// }


import 'package:flutter/material.dart';
import 'package:dai_auto_app/theme/app_theme.dart';
import 'package:dai_auto_app/screens/splash_page.dart';
import 'package:dai_auto_app/theme/app_theme.dart';
import 'package:dai_auto_app/screens/splash_page.dart';
import 'package:dai_auto_app/screens/home_page.dart';
import 'package:dai_auto_app/screens/edit_profile_page.dart';// <-- добавить
import 'package:dai_auto_app/screens/select_car_page.dart';
import 'package:dai_auto_app/screens/login_page.dart';
void main() => runApp(const DaiAutoApp());

class DaiAutoApp extends StatelessWidget {
  const DaiAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const LoginPage(),
    );
  }
}
