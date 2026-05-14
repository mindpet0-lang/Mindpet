import 'dart:convert';
import 'package:http/http.dart' as http;

class DiarioService {
  final String baseUrl = "http://localhost:8080/diarios";

  // Obtenemos los diarios filtrados por el ID del usuario
  Future<List<dynamic>> obtenerDiarios(int userId) async {
    final response = await http.get(Uri.parse("$baseUrl/usuario/$userId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar diarios");
    }
  }

  Future<void> crearDiario(
    int userId, // Recibe el ID del usuario logueado
    String contenido,
    String titulo,
    String emocion,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contenido": contenido,
        "titulo": titulo,
        "emocion": emocion,
        "usuarioId": userId,
      }),
    );
  }

  Future<void> eliminarDiario(int diarioId, int userId) async {
    // Es buena práctica pasar ambos para validar que el usuario borra lo suyo
    await http.delete(
      Uri.parse("$baseUrl/$diarioId/usuario/$userId"),
    );
  }

  Future<void> actualizarDiario(
    int diarioId,
    int userId,
    String contenido,
    String titulo,
    String emocion,
  ) async {
    await http.put(
      Uri.parse("$baseUrl/$diarioId"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contenido": contenido,
        "titulo": titulo,
        "emocion": emocion,
        "usuarioId": userId,
      }),
    );
  }
}