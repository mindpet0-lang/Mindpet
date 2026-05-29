import 'package:flutter/material.dart';
import 'package:mindpet/juegos/coin_manager.dart';
import 'package:provider/provider.dart'; 
import 'screens/login_screen.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'widgets/pet_loader.dart';
import 'models/pet.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
usePathUrlStrategy();
  final prefs = await SharedPreferences.getInstance();
  
  final int? userId = prefs.getInt('userId'); 

  runApp(
    // 2. Usamos MultiProvider para inyectar múltiples estados globales
    MultiProvider(
      providers: [
        // Estado global de la mascota virtual
        ChangeNotifierProvider(
          create: (context) => Pet(id: userId ?? 0),
        ),
        // Estado global de las monedas (Usando tu Singleton CoinManager.instance)
        ChangeNotifierProvider.value(
          value: CoinManager.instance,
        ),
      ],
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