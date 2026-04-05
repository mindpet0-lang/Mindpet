import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  // 10.0.2.2 es el localhost para el emulador de Android
final String baseUrl = "http://localhost:8080/api/chat";

  Future<Map<String, dynamic>> enviarMensaje(String texto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send'),
      headers: {"Content-Type": "text/plain"},
      body: texto,
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error al conectar con el servidor");
    }
  }

  Future<List<dynamic>> obtenerHistorial() async {
    final response = await http.get(Uri.parse('$baseUrl/history'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}