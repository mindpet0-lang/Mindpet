import 'package:flutter/material.dart';
import 'package:mindpet/screens/chat_screen.dart';
import 'package:mindpet/screens/tienda/tienda_screen.dart';
import '../models/pet.dart';
import '../screens/diario/diario_screen.dart';
import '../screens/acount_screen.dart';

class TopStatusBar extends StatelessWidget {
  final Pet pet;
  final int userId;
  final VoidCallback? onRegresoTienda; // 👈 1. Agregamos la propiedad opcional

  const TopStatusBar({
    super.key, 
    required this.pet, 
    required this.userId,
    this.onRegresoTienda, // 👈 2. Lo recibimos en el constructor
  });

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
                  const Color(0xFFFFA726),
                ),
                stat(Icons.flash_on, pet.energia, const Color(0xFFFFEB3B)),
                stat(Icons.restaurant, pet.hambre, const Color(0xFF8BC34A)),
                stat(Icons.clean_hands, pet.higiene, const Color(0xFF4FC3F7)),
              ],
            ),

            /// TIENDA
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TiendaScreen(userId: userId)),
                ).then((_) {
                  // 👈 3. ¡La magia ocurre aquí!
                  // Si la pantalla que instanció la barra configuró un callback,
                  // se ejecuta justo en el milisegundo en que el usuario vuelve de la tienda.
                  if (onRegresoTienda != null) {
                    onRegresoTienda!();
                  }
                });
              },
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [

             /// OPCIÓN ACOUNT
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Cuenta"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AccountScreen(userId: userId),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
        );
      },
    );
  }
}