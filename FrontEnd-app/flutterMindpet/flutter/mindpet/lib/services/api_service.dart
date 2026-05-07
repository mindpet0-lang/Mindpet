import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';

class ApiService {
  static const String baseUrl = "http://localhost:8080"; 

  static Future<int> getMonedas(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios/$userId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['monedas'];
      }
    } catch (e) {
      print("Error en getMonedas: $e");
    }
    return 0;
  }

  static Future<bool> realizarCompra(int userId, List<Item> items, int total, String categoria) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tienda/comprar'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "total": total,
          "categoria": categoria,
          "items": items.map((i) => i.toJson()).toList(),
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error en realizarCompra: $e");
      return false;
    }
  }

  // En lib/services/api_service.dart

static Future<bool> sumarMonedasPrueba(int userId) async {
  try {
    // Esta ruta debe coincidir con el @PostMapping que pongas en Java
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/$userId/sumar-monedas'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print("Monedas sumadas en el servidor correctamente");
      return true;
    } else {
      print("Error del servidor: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    print("Error de conexión al sumar monedas: $e");
    return false;
  }
}

// Traer la comida que el usuario compró (usa el endpoint que ya tienes de inventario)
static Future<List<dynamic>> getInventarioComida(int userId) async {
  final response = await http.get(Uri.parse("$baseUrl/tienda/inventario/$userId/comida"));
  return response.statusCode == 200 ? json.decode(response.body) : [];
}

static Future<bool> consumirItem(int userId, String nombre) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/tienda/consumir"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "nombre": nombre,
      }),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Error al consumir: $e");
    return false;
  }
}

}