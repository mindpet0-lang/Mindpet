import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import 'kitchen_screen.dart';
import 'bathroom_screen.dart';
import 'game_room_screen.dart';
import 'sleep_screen.dart';

class MainGameScreen extends StatefulWidget {
  final Pet pet;
  final int userId;

  const MainGameScreen({super.key, required this.pet, required this.userId});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  // El controlador se crea aquí, una sola vez
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // Iniciamos en la página 0 (Home)
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose(); // Importante para liberar memoria
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // Bloqueamos el scroll manual para que solo se use el menú si prefieres
        physics: const NeverScrollableScrollPhysics(), 
        children: [
          // 0: Sala (Home)
          HomeScreen(
            pet: widget.pet, 
            controller: _pageController, 
            userId: widget.userId
          ),
          
          // 1: Baño
          BathroomScreen(
            pet: widget.pet, 
            controller: _pageController, 
            userId: widget.userId
          ),

          // 2: Cocina
          KitchenScreen(
            pet: widget.pet, 
            controller: _pageController, 
            userId: widget.userId
          ),

          // 3: Dormitorio
          SleepScreen(
            pet: widget.pet, 
            controller: _pageController, 
            userId: widget.userId
          ),

          // 4: Cuarto de Juegos
          GameRoomScreen(
            pet: widget.pet, 
            controller: _pageController, 
            userId: widget.userId
          ),
        ],
      ),
    );
  }
}