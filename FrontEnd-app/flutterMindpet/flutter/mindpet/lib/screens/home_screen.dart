import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../widgets/bottom_menu.dart';

class HomeScreen extends StatelessWidget {

  final Pet pet;
  final PageController controller;

  const HomeScreen({
    super.key,
    required this.pet,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          /// FONDO
          Image.asset(
            "assets/images/sala.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

           /// BARRA SUPERIOR
      Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: TopStatusBar(pet: pet),
      ),

          /// MASCOTA
          Center(
            child: Image.asset(
              "assets/images/pet.png",
              width: 200,
            ),
          ),

          /// MENU
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(controller,0),
          ),

        ],
      ),
    );
  }
}

