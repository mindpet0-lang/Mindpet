import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pet.dart'; // Ajusta la ruta a tu modelo

class VisorNutria extends StatelessWidget {
  final double width;
  
  const VisorNutria({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    // El Consumer hace que la imagen cambie SOLA cuando llamas a notifyListeners()
    return Consumer<Pet>(
      builder: (context, pet, child) {
        return Image.asset(
          pet.imagenActual,
          width: width,
          fit: BoxFit.contain,
        );
      },
    );
  }
}