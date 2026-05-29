
import 'dart:convert';
import 'dart:io'; // Para manejar excepciones de socket
import 'package:http/http.dart' as http;
import '../models/pet.dart'; // Asegúrate de usar el modelo Pet que extiende ChangeNotifier


class MascotaService {
  // Cambia esto según tu caso:
  // 10.0.2.2 para emulador Android
  // Tu IP local para dispositivo físico
  final String baseUrl = "https://backendmindpet-production.up.railway.app/mascotas"; 

  Future<Pet> fetchMascota(int usuarioId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/usuario/$usuarioId'),
        headers: {'Content-Type': 'application/json'},
         // 'Authorization': 'Bearer $token', // Si usas Spring Security
      ).timeout(const Duration(seconds: 10)); // Timeout por si el server no responde

      if (response.statusCode == 200) {
        // Usamos el factory de tu modelo Pet
        return Pet.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No se pudo conectar al servidor. Revisa tu red o IP.');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}