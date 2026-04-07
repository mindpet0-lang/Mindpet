import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String baseUrl = "http://localhost:8080/api/chat";

  // Envía el mensaje y el ID del usuario actual
  Future<Map<String, dynamic>> enviarMensaje(String texto, int userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "text": texto,
        "userId": userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Error ${response.statusCode}: ${response.body}");
    }
  }

  // Trae los mensajes guardados en la DB para este usuario
  Future<List<dynamic>> obtenerHistorial(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/history/$userId'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}