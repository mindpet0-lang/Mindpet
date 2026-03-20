import 'package:flutter/material.dart';
import '../models/pet.dart';

class TopStatusBar extends StatelessWidget {
  final Pet pet;

  const TopStatusBar({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// MENU
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu, size: 30),
            ),

            /// ESTADOS
            Row(
              children: [
                stat(Icons.sentiment_satisfied, pet.felicidad, Color(0xFFFFA726)),
                stat(Icons.flash_on, pet.energia, Color(0xFFFFEB3B)),
                stat(Icons.restaurant, 100 - pet.hambre, Color(0xFF8BC34A)),
                stat(Icons.clean_hands, pet.higiene, Color(0xFF4FC3F7)),
              ],
            ),

            /// TIENDA
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  /// CIRCULO CON BARRA INTERNA
  Widget stat(IconData icon, int value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: 50,
      height: 50,

      child: Stack(
        alignment: Alignment.center,
        children: [
          /// CONTENIDO RECORTADO (CIRCULO)
          ClipOval(
            child: Stack(
              children: [
                /// FONDO TRANSPARENTE
                Container(width: 50, height: 50, color: Colors.transparent),

                /// BARRA VERTICAL
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 50,
                    height: (value / 100) * 50,
                    color: color,
                  ),
                ),
              ],
            ),
          ),

          /// BORDE NEGRO ENCIMA
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),

          /// ICONO
          Icon(icon, color: Colors.black, size: 40),
        ],
      ),
    );
  }
}
