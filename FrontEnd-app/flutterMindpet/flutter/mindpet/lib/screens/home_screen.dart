import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart'; // Asegúrate de que esta ruta sea correcta

class HomeScreen extends StatelessWidget {
  final PageController controller;
  final int userId;

  const HomeScreen({
    super.key,
    required this.controller,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios en el modelo Pet
    return Consumer<Pet>(
      builder: (context, pet, child) {
        return Stack(
          children: [
            // Fondo de la sala (puedes usar un color o una imagen)
            Container(color: const Color(0xFFE5EBF0)), 

            Column(
              children: [
                const SizedBox(height: 50),
                // 1. Barras de estado superiores
                _buildStatusSection(pet),

                const Expanded(child: SizedBox()),

<<<<<<< Updated upstream
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
=======
                // 2. Visualización de la Nutria
                Center(
                  child: pet.isSleeping
                      ? _buildSleepingIndicator()
                      : Image.asset(
                          pet.imagenActual, // Lógica dinámica de GIFs
                          width: 320,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100, color: Colors.red),
                        ),
                ),
>>>>>>> Stashed changes

                const Expanded(child: SizedBox()),

                // 3. Menú de acciones rápidas
                _buildQuickActions(context, pet),
                
                const SizedBox(height: 100), // Espacio para el menú inferior
              ],
            ),
          ],
        );
      },
    );
  }

  // Widget para las barras de progreso
  Widget _buildStatusSection(Pet pet) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          _barItem("Hambre", pet.hambre, Colors.orange),
          const SizedBox(height: 8),
          _barItem("Energía", pet.energia, Colors.blue),
          const SizedBox(height: 8),
          _barItem("Higiene", pet.higiene, Colors.green),
        ],
      ),
    );
  }

  Widget _barItem(String label, int value, Color color) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: value / 100,
              backgroundColor: Colors.white.withOpacity(0.5),
              color: color,
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text("$value%"),
      ],
    );
  }

  // Indicador visual de sueño
  Widget _buildSleepingIndicator() {
    return Column(
      children: [
        const Icon(Icons.bedtime, color: Colors.indigo, size: 60),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffa9c7da).withOpacity(0.8), // Estética del Diario
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text("Zzz... Durmiendo"),
        ),
      ],
    );
  }

  // Botones de interacción rápida
  Widget _buildQuickActions(BuildContext context, Pet pet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _actionBtn(Icons.restaurant, "Comer", () => pet.comer()),
        _actionBtn(Icons.videogame_asset, "Jugar", () => pet.jugar()),
        _actionBtn(Icons.save, "Guardar", () => pet.saveToServer(pet.id)),
      ],
    );
  }

  Widget _actionBtn(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label,
          onPressed: onTap,
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(icon, color: Colors.blueAccent),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }
}