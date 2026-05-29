import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/item.dart';
import '../models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://backendmindpet-production.up.railway.app"; 

  static Future<int> getMonedas(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios/get/$userId'));
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

      return true;
    } else {

      return false;
    }
  } catch (e) {

    return false;
  }
}

// Traer la comida que el usuario compró (usa el endpoint que ya tienes de inventario)
static Future<List<dynamic>> getInventarioComida(int userId) async {
  final response = await http.get(Uri.parse("$baseUrl/tienda/inventario/$userId/comida-completa"));
  return response.statusCode == 200 ? json.decode(response.body) : [];
}



// Traer los jabones que el usuario compró (usa el endpoint que ya tienes de inventario)
static Future<List<dynamic>> getInventarioAseo(int userId) async {
  final response = await http.get(Uri.parse("$baseUrl/tienda/inventario/$userId/aseo"));
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
    return false;
  }
}

// Añade esta función dentro de tu clase ApiService
static Future<Usuario?> obtenerUsuarioPorId(int userId) async {
  try {
    // Apunta a /get/{id} tal como lo definiste en tu @GetMapping de Spring Boot
    final response = await http.get(Uri.parse('$baseUrl/usuarios/get/$userId'));

    if (response.statusCode == 200) {
      // Decodificamos el JSON y lo convertimos en nuestro modelo Usuario
      final Map<String, dynamic> data = jsonDecode(response.body);
      return Usuario.fromJson(data);
    } else {
      print("Error al obtener usuario: Código ${response.statusCode}");
      return null;
    }
  } catch (e) {
    print("Error en obtenerUsuarioPorId: $e");
    return null;
  }
}

static Future<void> cerrarSesion() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Opción A: Borrar solo las llaves de la sesión (Recomendado si guardas otras configs como el tema oscuro)
  await prefs.remove('userId');
  await prefs.remove('token');

  // Opción B: Borrar absolutamente todo lo guardado
 await prefs.clear();
}

}