import 'dart:convert';
import 'package:http/http.dart' as http;

class DiarioService {
  final String baseUrl = "https://backendmindpet-production.up.railway.app/diarios";

  Future<List<dynamic>> obtenerDiarios(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/$userId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        "Error al cargar diarios: ${response.body}",
      );
    }
  }

  Future<void> crearDiario(
    int userId,
    String contenido,
    String titulo,
    String emocion,
  ) async {

    final response = await http.post(
      Uri.parse(baseUrl),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "contenido": contenido,
        "titulo": titulo,
        "emocion": emocion,
        "usuarioId": userId,
      }),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201) {

      throw Exception(
        "Error creando diario: ${response.body}",
      );
    }
  }

  Future<void> eliminarDiario(
    int diarioId,
    int userId,
  ) async {

    final response = await http.delete(
      Uri.parse(
        "$baseUrl/$diarioId/usuario/$userId",
      ),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 204) {

      throw Exception(
        "Error eliminando diario",
      );
    }
  }

  Future<void> actualizarDiario(
    int diarioId,
    int userId,
    String contenido,
    String titulo,
    String emocion,
  ) async {

    final response = await http.put(
      Uri.parse("$baseUrl/$diarioId"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "contenido": contenido,
        "titulo": titulo,
        "emocion": emocion,
        "usuarioId": userId,
      }),
    );

    if (response.statusCode != 200) {

      throw Exception(
        "Error actualizando diario: ${response.body}",
      );
    }
  }
}