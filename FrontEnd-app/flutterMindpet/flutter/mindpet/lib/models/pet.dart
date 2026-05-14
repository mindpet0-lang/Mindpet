import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Pet extends ChangeNotifier {
  final int id;
  int energia;
  int felicidad;
  int higiene;
  int hambre; // Funciona como nivel de saciedad
  int lastUpdate;
  bool isSleeping;
  
  Timer? _timer;

  Pet({
    required this.id,
    this.energia = 80,
    this.felicidad = 80,
    this.higiene = 80,
    this.hambre = 80, 
    this.isSleeping = false,
    int? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now().millisecondsSinceEpoch {
    _startRealtimeUpdate();
  }

  // Getter dinámico para los GIFs basado en tus carpetas
  String get imagenActual {
    String path = "images/nutria/parada";
    
    // Estados críticos (menos de 35%)
    bool h = hambre < 35;
    bool s = energia < 35;
    bool u = higiene < 35;

    if (h && u && s) return "$path/hambrienta-sucia-sueno.gif";
    if (h && u) return "$path/hambrienta-sucia.gif";
    if (u && s) return "$path/sucia-sueno.gif";
    if (h && s) return "$path/hambrienta-sueno.gif";
    if (h) return "$path/hambrienta.gif";
    if (u) return "$path/sucia.gif";
    if (s) return "$path/sueno.gif";
    
    return "$path/parada.gif";
  }

  void updateWithTime() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int seconds = (now - lastUpdate) ~/ 1000;

    if (seconds > 0) {
      if (isSleeping) {
        energia = (energia + seconds ~/ 30).clamp(0, 100);
      } else {
        energia = (energia - seconds ~/ 60).clamp(0, 100);
      }
      higiene = (higiene - seconds ~/ 600).clamp(0, 100);
      hambre = (hambre - seconds ~/ 120).clamp(0, 100);
      
      lastUpdate = now;
      if (isSleeping && energia >= 100) isSleeping = false;
      
      notifyListeners(); // IMPORTANTE: Esto quita el error de la pantalla roja al actualizar
    }
  }
  // Mantenemos tu lógica de carga de datos
  factory Pet.fromJson(Map<String, dynamic> json) {
    Pet pet = Pet(
      id: json['id'],
      energia: json['energia'] ?? 80,
      felicidad: json['felicidad'] ?? 80,
      higiene: json['higiene'] ?? 80,
      hambre: json['hambre'] ?? 80,
      isSleeping: json['isSleeping'] ?? false,
      lastUpdate: json['lastUpdate'],
    );
    pet.updateWithTime();
    return pet;
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'energia': energia, 'felicidad': felicidad,
    'higiene': higiene, 'hambre': hambre, 'isSleeping': isSleeping,
    'lastUpdate': lastUpdate,
  };

  // --- LÓGICA DE TIEMPO REAL ---
  void _startRealtimeUpdate() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      updateWithTime();
      notifyListeners(); 
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  void _clamp() {
    energia = energia.clamp(0, 100);
    felicidad = felicidad.clamp(0, 100);
    higiene = higiene.clamp(0, 100);
    hambre = hambre.clamp(0, 100);
  }

  // --- PERSISTENCIA Y ACCIONES ---
  Future<void> saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_data', jsonEncode(toJson()));
  }

  Future<bool> saveToServer(int mascotaId) async {
    try {
      final url = Uri.parse('http://localhost:8080/mascotas/update/$mascotaId');
      final resp = await http.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(toJson()));
      return resp.statusCode == 200;
    } catch (e) { return false; }
  }

  bool comer() {
    if (hambre >= 100) return false;

    hambre += 20;
    if (hambre > 100) hambre = 100;
    
    felicidad += 5;
    if (felicidad > 100) felicidad = 100;

    lastUpdate = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    return true;
  }

  bool jugar() {
    if (energia < 20 || hambre < 20) return false;

    felicidad += 20;
    energia -= 15;
    hambre -= 10; 

    _clamp();
    lastUpdate = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    return true;
  }

  void notificar() {
  notifyListeners();
}
}