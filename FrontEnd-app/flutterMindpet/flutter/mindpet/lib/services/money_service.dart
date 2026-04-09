import 'package:shared_preferences/shared_preferences.dart';

class MoneyService {
  static const key = "coins";

  static Future<int> getMoney() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 100;
  }

  static Future<void> saveMoney(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }
}