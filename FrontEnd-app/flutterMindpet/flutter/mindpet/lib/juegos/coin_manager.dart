import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinManager extends ChangeNotifier {
  static final CoinManager instance = CoinManager._internal();
  CoinManager._internal();

  // Asegúrate de usar la IP correcta (localhost, 10.0.2.2 o tu IP local)
  final String baseUrl = "http://localhost:8080"; 
  int _coins = 0;
  int get coins => _coins;

  // ESTA FUNCIÓN ES LA QUE SOLUCIONA EL PROBLEMA AL ENTRAR
  Future<int> fetchMonedas(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/usuarios/get/$userId'));
      if (response.statusCode == 200) {
        _coins = jsonDecode(response.body)['monedas'];
        notifyListeners(); // Esto le avisa a la pantalla apenas entras
        return _coins;
      }
    } catch (e) {
      print("Error al cargar monedas iniciales: $e");
    }
    return _coins;
  }

  // Tu método para sumar monedas cuando ganas en el juego
  Future<bool> addCoins(int userId, int amount) async {
    try {
      final url = Uri.parse('$baseUrl/usuarios/$userId/sumar-monedas?monedas=$amount');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        _coins = int.parse(response.body);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Error en addCoins: $e");
    }
    return false;
  }

  // Tu método para gastar
  Future<bool> spendCoins(int userId, int amount) async {
    try {
      final url = Uri.parse('$baseUrl/usuarios/$userId/gastar-monedas?monedas=$amount');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        _coins = int.parse(response.body);
        notifyListeners();
        return true;
      }
    } catch (e) {
      print("Error en spendCoins: $e");
    }
    return false;
  }
}