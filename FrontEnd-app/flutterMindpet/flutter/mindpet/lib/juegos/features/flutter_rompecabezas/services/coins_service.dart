import 'package:shared_preferences/shared_preferences.dart';

class CoinsService {
  static int coins = 0;

  // 🔥 cargar monedas guardadas
  static Future<void> loadCoins() async {
    final prefs = await SharedPreferences.getInstance();
    coins = prefs.getInt('coins') ?? 0;
  }

  // ➕ sumar monedas
  static Future<void> addCoins(int amount) async {
    coins += amount;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', coins);
  }

  // ❌ gastar monedas
  static Future<void> removeCoins(int amount) async {
    coins -= amount;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coins', coins);
  }
}