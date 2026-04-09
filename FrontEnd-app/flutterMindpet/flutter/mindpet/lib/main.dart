import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/pet_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  // 1. Aseguramos que los servicios de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();
  
  // 2. Buscamos el ID del usuario en la memoria del teléfono
  final prefs = await SharedPreferences.getInstance();
  final int? userId = prefs.getInt('userId'); // Obtenemos el ID guardado

  // 3. Si el ID existe, es porque ya inició sesión (isLoggedIn)
  runApp(MyApp(userId: userId));
}

class MyApp extends StatelessWidget {
  final int? userId; // Guardamos el ID aquí

  const MyApp({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindPet',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // 4. LÓGICA DE ENTRADA:
      // Si userId es null, vamos al Login.
      // Si tiene un número, vamos directo al PetLoader con ese ID.
      home: userId != null 
          ? PetLoader(userId: userId!) 
          : const LoginScreen(),
    );
  }
}