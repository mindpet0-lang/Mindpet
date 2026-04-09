import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'comida_screen.dart';
import 'aseo_screen.dart';

class TiendaScreen extends StatelessWidget {
  const TiendaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.background],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.arrow_back),
                    Text("Tienda",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    Icon(Icons.shopping_cart)
                  ],
                ),
              ),

              Image.asset("assets/nutria.png", height: 180),

              const SizedBox(height: 20),

              // BOTONES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _boton(context, "Comida", Icons.fastfood,
                      const ComidaScreen()),
                  _boton(context, "Aseo", Icons.soap, const AseoScreen()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _boton(BuildContext context, String texto, IconData icono, Widget screen) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => screen));
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6)
          ],
        ),
        child: Column(
          children: [
            Icon(icono, size: 40, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(texto,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}