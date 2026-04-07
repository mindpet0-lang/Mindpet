import 'package:flutter/material.dart';
import 'package:mindpet/screens/maingame_screen.dart';

// IMPORTANTE: Ajusta estas rutas según el nombre de tu proyecto
import '../models/pet.dart';
import '../services/audio_service.dart';

class PetLoader extends StatefulWidget {
  final int userId;

  const PetLoader({super.key , required this.userId});

  @override
  State<PetLoader> createState() => _PetLoaderState();
}

class _PetLoaderState extends State<PetLoader> {
  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  Future<void> _iniciarJuego() async {
    try {
      // 1. Cargamos los datos de la mascota
      final pet = await Pet.load();

      // 2. Iniciamos la música
      AudioService.playMusic();

      // 3. Saltamos al juego principal
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainGameScreen(pet: pet, userId: widget.userId),
          ),
        );
      }
    } catch (e) {
      // Si hay un error cargando (por ejemplo, no hay internet),
      // podrías mostrar un mensaje o volver al login
      print("Error cargando mascota: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "Cargando tu MindPet...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
