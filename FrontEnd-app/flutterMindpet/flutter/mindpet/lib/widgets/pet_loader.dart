import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Asegúrate de importar tu Home
import '../models/pet.dart';
import '../screens/maingame_screen.dart'; // Importa tu modelo Pet

class PetLoader extends StatefulWidget {
  final int userId;

  const PetLoader({super.key, required this.userId});

  @override
  State<PetLoader> createState() => _PetLoaderState();
}

class _PetLoaderState extends State<PetLoader> {
  @override
  void initState() {
    super.initState();
    // Iniciamos la carga apenas entre a la pantalla
    _loadAndNavigate();
  }

  Future<void> _loadAndNavigate() async {
    final String cleanId = widget.userId.toString().trim();
    // Si usas emulador recuerda cambiar a 10.0.2.2
    final url = Uri.parse('http://localhost:8080/mascotas/usuario/$cleanId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Convertimos el JSON al objeto Pet que ya configuramos
        Pet mascotaCargada = Pet.fromJson(data);

        if (!mounted) return;

        // Redirigimos a HomeScreen pasando la mascota cargada
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => MainGameScreen(
      pet: mascotaCargada,
      userId: widget.userId, // Pásalo directamente aquí
    ),
  ),
);
      } else {
        _handleError("No se encontró la mascota en el servidor");
      }
    } catch (e) {
      _handleError("Error de conexión: Revisa tu servidor Spring Boot");
    }
  }

  void _handleError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
    // Opcional: Volver al login si falla
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tu animación de la nutria o un loader circular
            const CircularProgressIndicator(color: Colors.blueAccent),
            const SizedBox(height: 20),
            Image.asset("images/nutria-acostada.gif", width: 150),
            const SizedBox(height: 20),
            const Text(
              "Despertando a tu mascota...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
