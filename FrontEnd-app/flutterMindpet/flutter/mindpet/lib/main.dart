import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'screens/login_screen.dart';
import 'widgets/pet_loader.dart';
import 'models/pet.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final int? userId = prefs.getInt('userId'); 


  runApp(
    ChangeNotifierProvider(
      // Creamos la instancia de Pet aquí para que sea global
      create: (context) => Pet(id: userId ?? 0), 
      child: MyApp(userId: userId),
    ),
  );
}

class MyApp extends StatelessWidget {
  final int? userId;

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
      home: userId != null 
          ? PetLoader(userId: userId!) 
          : const LoginScreen(),
    );
  }
}