import 'dart:convert';
import 'package:http/http.dart' as http;

class DiarioService {

  final String baseUrl = "http://localhost:8080/diarios";

  int usuarioId = 1; // es para el usuario de prueba, luego se reemplazará por el id del usuario logueado

  Future<List<dynamic>> obtenerDiarios() async {
    final response = await http.get(Uri.parse("$baseUrl/usuario/$usuarioId"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al cargar diarios");
    }
  }

  Future<void> crearDiario(
    String contenido,
    String fecha,
    String emocion,
  ) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contenido": contenido,
        "fecha": fecha,
        "emocion": emocion,
        "usuarioId": usuarioId,
      }),
    );

    print("POST STATUS: ${response.statusCode}");
    print("POST BODY: ${response.body}");
  }

  Future<void> eliminarDiario(int id) async {
  await http.delete(
    Uri.parse("$baseUrl/$id/usuario/$usuarioId"),
  );
}

  Future<void> actualizarDiario(
    int id,
    String contenido,
    String fecha,
    String emocion,
  ) async {
    await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contenido": contenido,
        "fecha": fecha,
        "emocion": emocion,
        "usuarioId": usuarioId,
      }),
    );
  }
}
