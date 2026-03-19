import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

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
            "assets/sala.png",
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
              "assets/pet.png",
              width: 200,
            ),
          ),

          /// MENU
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: menu(controller,0),
          ),

        ],
      ),
    );
  }
}

Widget menu(PageController controller, int currentPage) {

  Widget buildIcon(IconData icon, int page) {

    bool activo = currentPage == page;

    return GestureDetector(
      onTap: () {
        controller.animateToPage(
          page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },

      child: Container(
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: activo ? Color.fromARGB(255, 81, 196, 255) : Colors.transparent,
        ),

        child: Icon(
          icon,
          size: 35,
          color: activo ? Colors.black : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [

      buildIcon(Icons.home, 0),
      buildIcon(Icons.shower, 1),
      buildIcon(Icons.fastfood, 2),
      buildIcon(Icons.nightlight_round, 3),
      buildIcon(Icons.sports_esports, 4),

    ],
  );
}