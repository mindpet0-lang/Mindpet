import 'package:flutter/material.dart';
import 'package:mindpet/screens/chat_screen.dart';
import '../models/pet.dart';
import '../screens/diario_screen.dart';

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
              onPressed: () {
                mostrarMenu(context);
              },
              icon: const Icon(Icons.menu, size: 30),
            ),

            /// ESTADOS
            Row(
              children: [
                stat(
                  Icons.sentiment_satisfied,
                  pet.felicidad,
                  Color(0xFFFFA726),
                ),
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

void mostrarMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      // Usamos un Column para tener varias opciones en el menú
      return Column(
        mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
        children: [
          /// OPCIÓN: DIARIO
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text("Diario"),
            onTap: () {
              Navigator.pop(context); // cerrar menú
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DiarioScreen(),
                ),
              );
            },
          ),

          /// OPCIÓN: CHAT CON IA (AQUÍ LA REDIRECCIÓN)
          ListTile(
            leading: const Icon(Icons.chat_bubble), // Icono de chat
            title: const Text("Hablar con mi mascota"),
            onTap: () {
              Navigator.pop(context); // Cierra el menú antes de navegar
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatScreen(), // Redirige a tu pantalla de chat
                ),
              );
            },
          ),
          
          const SizedBox(height: 10), // Espacio extra al final
        ],
      );
    },
  );
}

}
