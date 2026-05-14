import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../widgets/bottom_menu.dart';

class HomeScreen extends StatelessWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const HomeScreen({
    super.key, 
    required this.pet, 
    required this.controller,
    required this.userId
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
        child: TopStatusBar(pet: pet,userId: userId,),
      ),

          /// MASCOTA (CON LÓGICA DE VISIBILIDAD)
          // Usamos Consumer para que la pantalla se entere si la nutria se despierta
       /// MASCOTA (CON LÓGICA DE VISIBILIDAD)
          Center(
            child: ListenableBuilder(
              listenable: pet, // Escucha directamente al objeto pet que ya tienes
              builder: (context, child) {
                return pet.isSleeping
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bedtime, color: Colors.white, size: 50),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: Colors.black54,
                            child: const Text(
                              "Tu mascota está durmiendo...",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Image.asset(
                        pet.imagenActual, // Usa la lógica de estados de pet.dart
                        width: 250,
                       
                      );
              },
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