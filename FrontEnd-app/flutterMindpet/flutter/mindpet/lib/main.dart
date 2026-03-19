import 'package:flutter/material.dart';

import 'models/pet.dart';

import 'screens/home_screen.dart';
import 'screens/bathroom_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/sleep_screen.dart';
import 'screens/game_room_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final Pet pet = Pet();
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: PageView(

        controller: controller,

        children: [

          HomeScreen(
            pet: pet,
            controller: controller,
          ),

          BathroomScreen(
            pet: pet,
            controller: controller,
          ),

          KitchenScreen(
            pet: pet,
            controller: controller,
          ),

          SleepScreen(
            pet: pet,
            controller: controller,
          ),

          GameRoomScreen(
            pet: pet,
            controller: controller,
          ),

        ],

      ),

    );
  }
}