import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Pet extends ChangeNotifier{
  final int id;
  int energia;
  int felicidad;
  int higiene;
  int hambre;
  int lastUpdate;
  bool isSleeping;

  Pet({
    required this.id,
    this.energia = 80,
    this.felicidad = 80,
    this.higiene = 80,
    this.hambre = 20,
    this.isSleeping = false,
    int? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now().millisecondsSinceEpoch;

  factory Pet.fromJson(Map<String, dynamic> json) {
    Pet pet = Pet(
      id: json['id'],
      energia: json['energia'] ?? 80,
      felicidad: json['felicidad'] ?? 80,
      higiene: json['higiene'] ?? 80,
      hambre: json['hambre'] ?? 20,
      isSleeping: json['isSleeping'] ?? false,
      lastUpdate: json['lastUpdate'],
    );
    pet.updateWithTime(); 
    return pet;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'energia': energia,
    'felicidad': felicidad,
    'higiene': higiene,
    'hambre': hambre,
    'isSleeping': isSleeping,
    'lastUpdate': lastUpdate,
  };

  void updateWithTime() {
    int now = DateTime.now().millisecondsSinceEpoch;
    int diff = now - lastUpdate;
    int seconds = diff ~/ 1000;

    if (seconds > 0) {
      if (isSleeping) {
        energia += seconds ~/ 30; // Recupera 1 punto cada 30 seg durmiendo
      } else {
        energia -= seconds ~/ 60; // Pierde 1 punto por minuto despierta
      }
      
      felicidad -= seconds ~/ 300;
      higiene -= seconds ~/ 600;
      hambre -= seconds ~/ 120;

      _clamp();
      lastUpdate = now;

      // Si durmiendo llegó al 100%, despertar automáticamente
      if (isSleeping && energia >= 100) {
        isSleeping = false;
      }
    }
  }

  void _clamp() {
    energia = energia.clamp(0, 100);
    felicidad = felicidad.clamp(0, 100);
    higiene = higiene.clamp(0, 100); // Corrección: higiene
    hambre = hambre.clamp(0, 100);
  }

  Future<void> saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_data', jsonEncode(toJson()));
  }

  Future<bool> saveToServer(int mascotaId) async {
    try {
      final url = Uri.parse('http://localhost:8080/mascotas/update/$mascotaId');
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(toJson()),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

bool comer() {
    // Si ya está en 100 o más, está totalmente llena
    if (hambre >= 100) {
      return false; 
    }

    hambre += 20; // SUMAMOS comida
    if (hambre > 100) hambre = 100;
    
    felicidad += 5;
    if (felicidad > 100) felicidad = 100;

    lastUpdate = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    return true;
  }

  bool jugar() {
    // No puede jugar si está muy cansada o tiene mucha hambre
    if (energia < 20 || hambre < 20) {
      return false;
    }

    felicidad += 20;
    energia -= 15; // Jugar cansa
    hambre -= 10;   // Jugar da hambre (baja la saciedad)

    _clamp();
    lastUpdate = DateTime.now().millisecondsSinceEpoch;
    notifyListeners();
    return true;
  }


  void notificar() {
    notifyListeners();
  }


  
}

