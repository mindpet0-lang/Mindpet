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
  int hambre; 
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
    String path = "assets/images/nutria/parada";
    
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

  String get imagenComiendo{
    String path = "assets/images/nutria/kitchen/comiendo";

    bool s = energia < 35;
    bool u = higiene < 35;
    
     if (u && s) return "$path/sucia-sueno.gif";
         if (u) return "$path/sucia.gif";
    if (s) return "$path/sueno.gif";

    return "$path/normal.gif";

  }

    String get imagenTomando{
    String path = "assets/images/nutria/kitchen/tomando";

    bool s = energia < 35;
    bool u = higiene < 35;
    
     if (u && s) return "$path/sucia-sueno.png";
         if (u) return "$path/sucia.png";
    if (s) return "$path/sueno.png";

    return "$path/normal.png";

  }

 void updateWithTime() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int milliseconds = now - lastUpdate;
    
    // Convertimos a segundos reales con decimales para no perder fracciones de tiempo
    double seconds = milliseconds / 1000;

    if (seconds >= 1) {
      if (isSleeping) {
        // Recupera 1 punto de energía cada 30 segundos (proporcionalmente en decimal)
        energia = (energia + (seconds / 30)).round().clamp(0, 100);
      } else {
        // Pierde 1 punto de energía cada 120 segundos
        energia = (energia - (seconds / 120)).round().clamp(0, 100);
      }
      
      // Resto de estados decayendo proporcionalmente
      higiene = (higiene - (seconds / 600)).round().clamp(0, 100);
      hambre = (hambre - (seconds / 120)).round().clamp(0, 100);
      felicidad = (felicidad - (seconds / 60)).round().clamp(0, 100);
      
      // Solo actualizamos lastUpdate si efectivamente procesamos el tiempo
      lastUpdate = now;
      notifyListeners(); 
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
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) async {
      updateWithTime();
      
      // 🔥 LA SOLUCIÓN: Si está durmiendo y estás en otra pantalla,
      // obligamos a la mascota a guardar su nueva energía en el servidor/base de datos.
      if (isSleeping) {
        await saveToServer(id);
        await saveLocal(); // Opcional, por si manejas persistencia local también
      }
      
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
      final url = Uri.parse('https://backendmindpet-production.up.railway.app/mascotas/update/$mascotaId');
      final resp = await http.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(toJson()));
      return resp.statusCode == 200;
    } catch (e) { return false; }
  }

  bool comer() {
    if (hambre >= 100) return false;

    hambre += 20;
    if (hambre > 100) hambre = 100;
    
    felicidad += 10;
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