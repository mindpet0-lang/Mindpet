import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart';

class MascotaView extends StatelessWidget {
  final double ancho;

  const MascotaView({super.key, this.ancho = 300});

  @override
  Widget build(BuildContext context) {

    return Consumer<Pet>(
      builder: (context, pet, child) {
        return Center(
          child: pet.isSleeping 
            ? _buildSleepingPet() 
            : _buildActivePet(pet),
        );
      },
    );
  }

  // Widget cuando la nutria está despierta
  Widget _buildActivePet(Pet pet) {
    return Image.asset(
      pet.imagenActual, // Lógica dinámica de GIFs según estados críticos
      width: ancho,
      fit: BoxFit.contain,
      // En caso de que haya un error con la ruta del archivo
      errorBuilder: (context, error, stackTrace) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 10),
            Text("Error al cargar: ${pet.imagenActual}", 
                 style: const TextStyle(fontSize: 10, color: Colors.red)),
          ],
        );
      },
    );
  }

  // Widget cuando la nutria está durmiendo (puedes usar un GIF específico o un icono)
  Widget _buildSleepingPet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Representación visual del sueño
        const Icon(Icons.bedtime, color: Colors.indigo, size: 80),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "Zzz... Descansando",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}