import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import 'bathroom_screen.dart';
import 'kitchen_screen.dart';
import 'sleep_screen.dart';
import 'game_room_screen.dart';

class MainGameScreen extends StatefulWidget {
  final Pet pet;
  final int userId;

  const MainGameScreen({super.key, required this.pet,required this.userId});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  // El controlador que moverá a la mascota entre salas
  late PageController controller;

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Aquí está el PageView que mencionabas, ahora fuera del main
      body: PageView(
        controller: controller,
        // Impedimos que se deslice con el dedo si prefieres que solo sea por botones
        // physics: const NeverScrollableScrollPhysics(), 
        children: [
          HomeScreen(pet: widget.pet, controller: controller,userId: widget.userId,),
          BathroomScreen(pet: widget.pet, controller: controller,userId: widget.userId,),
          KitchenScreen(pet: widget.pet, controller: controller,userId: widget.userId,),
          SleepScreen(pet: widget.pet, controller: controller,userId: widget.userId),
          GameRoomScreen(pet: widget.pet, controller: controller,userId: widget.userId,),
        ],
      ),
    );
  }
}