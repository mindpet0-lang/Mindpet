import 'package:flutter/material.dart';

import 'models/pet.dart';

import 'screens/home_screen.dart';
import 'screens/bathroom_screen.dart';
import 'screens/kitchen_screen.dart';
import 'screens/sleep_screen.dart';
import 'screens/game_room_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final pet = await Pet.load();

  runApp(MyApp(pet: pet));
}

class MyApp extends StatefulWidget {

  final Pet pet;

  const MyApp({super.key, required this.pet});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late Pet pet;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    pet = widget.pet;
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageView(
        controller: controller,
        children: [

          HomeScreen(pet: pet, controller: controller),
          BathroomScreen(pet: pet, controller: controller),
          KitchenScreen(pet: pet, controller: controller),
          SleepScreen(pet: pet, controller: controller),
          GameRoomScreen(pet: pet, controller: controller),

        ],
      ),
    );
  }
}