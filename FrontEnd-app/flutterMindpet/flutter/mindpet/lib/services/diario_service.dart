import 'dart:convert';
import 'package:http/http.dart' as http;

class DiarioService {

  final String baseUrl = "http://localhost:8080/diarios";

  int usuarioId = 1; // 🔐 Simulación de usuario logueado

  Future<List<dynamic>> obtenerDiarios() async {
    final response = await http.get(
      Uri.parse("$baseUrl/usuario/$usuarioId"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar diarios");
    }
  }

  Future<void> crearDiario(String contenido, String fecha) async {
    await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contenido": contenido,
        "fecha": fecha,
        "usuarioId": usuarioId // 🔐 IMPORTANTE
      }),
    );
  }
}