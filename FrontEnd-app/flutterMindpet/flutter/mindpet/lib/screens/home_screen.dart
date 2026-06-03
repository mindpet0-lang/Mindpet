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
            "assets/images/fondo/sala2.png",
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
Center(
  child: pet.isSleeping
      ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bedtime, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration( // Añadí decoración para que se vea mejor
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
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
      // Cambiamos el path fijo por el getter dinámico de tu modelo
      : Image.asset(
          pet.imagenActual, 
          width: 250,
          // Añadimos errorBuilder por si hay un error en el nombre del archivo
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
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