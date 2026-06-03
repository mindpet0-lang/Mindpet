import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../widgets/bottom_menu.dart';
import './diario/diario_screen.dart';
import 'chat_screen.dart';

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
            child: TopStatusBar(pet: pet, userId: userId),
          ),

          /// MASCOTA (CON LÓGICA DE VISIBILIDAD)
          Center(
            child: pet.isSleeping
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bedtime, color: Colors.white, size: 50),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
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
                : Padding(
                    // Empujamos a Koko un poco hacia arriba para que no lo tapen los botones centrales
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: Image.asset(
                      pet.imagenActual, 
                      width: 250,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                  ),
          ),

          /// MENÚ CENTRAL (Diario, Habla con Koko, Retos)
         Positioned(
            bottom: 120, 
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// BOTÓN DIARIO
                _buildCentralButton(
                  imagePath: "assets/images/diario-icon.PNG", // Extensión .PNG corregida
                  label: "Diario",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DiarioScreen(userId: userId)));
                    print("Abriendo Diario...");
                  },
                ),

                /// BOTÓN HABLA CON KOKO
                _buildCentralButton(
                  imagePath: "assets/images/chat-icon.PNG",
                  label: "Habla con Koko",
                  isLarge: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(userId: userId,)));
                    print("Iniciando chat con la nutria...");
                  },
                ),

                /// BOTÓN RETOS
                _buildCentralButton(
                  imagePath: "assets/images/retos-icon.PNG",
                  label: "Retos",
                  onTap: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => const RetosScreen()));
                    print("Cargando retos diarios...");
                  },
                ),
              ],
            ),
          ),

          /// MENU INFERIOR
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(controller, 0),
          ),
        ],
      ),
    );
  }

  /// Widget auxiliar para crear cada uno de los 3 botones de manera limpia
  Widget _buildCentralButton({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
    bool isLarge = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: isLarge ? 95 : 80, // El botón central de chat destaca por tamaño
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 50),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Cambia el color según resalte mejor en tu fondo/tapete
              shadows: [
                Shadow(offset: Offset(0.5, 0.5), color: Colors.white, blurRadius: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}