import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import 'kitchen_screen.dart';
import 'bathroom_screen.dart';
import 'game_room_screen.dart';
import 'sleep_screen.dart';
import 'top_status_bar.dart'; // Asegúrate de tener tu barra de estados o menú

class MainGameScreen extends StatefulWidget {
  final int userId;

  // Eliminamos 'pet' del constructor porque se obtendrá vía Provider
  const MainGameScreen({super.key, required this.userId});

  @override
  State<MainGameScreen> createState() => _MainGameScreenState();
}

class _MainGameScreenState extends State<MainGameScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Usamos un Stack para que el menú de navegación o barra de estados 
      // flote sobre las pantallas si es necesario.
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            // Bloqueamos el scroll manual para usar navegación por botones
            physics: const NeverScrollableScrollPhysics(), 
            children: [
              // 0: Sala (Home) - Solo pasamos controller y userId
              HomeScreen(
                controller: _pageController, 
                userId: widget.userId
              ),
              
              // 1: Baño
              BathroomScreen(
                controller: _pageController, 
                userId: widget.userId
              ),

              // 2: Cocina
              KitchenScreen(
                controller: _pageController, 
                userId: widget.userId
              ),

              // 3: Dormitorio
              SleepScreen(
                controller: _pageController, 
                userId: widget.userId
              ),

              // 4: Cuarto de Juegos
              GameRoomScreen(
                controller: _pageController, 
                userId: widget.userId
              ),
            ],
          ),
          
          // Opcional: Aquí podrías añadir un widget de navegación inferior
          // que llame a _pageController.animateToPage(index, ...)
        ],
      ),
    );
  }
}