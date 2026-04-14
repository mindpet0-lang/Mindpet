import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class SleepScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const SleepScreen({
    super.key, 
    required this.pet, 
    required this.controller, 
    required this.userId
  });

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  // Variables locales para la animación de la UI
  double _oscuridad = 0.0;
  final String _imgDespierta = "images/nutria-parada.gif";
  final String _imgDormida = "images/nutria-durmiendo.gif";
  double _sizeNutria = 250;

  @override
  void initState() {
    super.initState();
    
    // Si al entrar ya estaba durmiendo (por carga de DB), ajustamos la UI
    if (widget.pet.isSleeping) {
      _oscuridad = 0.7;
      _sizeNutria = 450;
      _iniciarBucleEnergia();
    }

    // Bucle para que las barras de estado bajen/suban en tiempo real mientras ves la pantalla
    _actualizarUIContinuamente();
  }

  void _actualizarUIContinuamente() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      
      setState(() {
        widget.pet.updateWithTime();
      });
      return true;
    });
  }

  void _dormir() async {
    if (widget.pet.isSleeping) return;

    // 1. Cambiamos el estado en el modelo
    setState(() {
      widget.pet.isSleeping = true;
      _sizeNutria = 450;
    });
    
    widget.pet.notificar(); // Avisa a otras pantallas que se durmió

    // 2. Sincronizamos con el servidor (Aviso de inicio de sueño)
    await widget.pet.saveToServer(widget.pet.id);

    // 3. Animación de oscurecer
    for (double i = 0; i <= 0.7; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _oscuridad = i);
    }

    _iniciarBucleEnergia();
  }

  void _iniciarBucleEnergia() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      // Si se despierta, llega al 100% o salimos de la pantalla
      if (!mounted || widget.pet.energia >= 100 || !widget.pet.isSleeping) {
        if (mounted && widget.pet.isSleeping) _despertar();
        _oscuridad = 0.0;
        _sizeNutria = 250;
        return false;
      }

      setState(() {
        widget.pet.energia += 2;
        if (widget.pet.energia > 100) widget.pet.energia = 100;
      });

      // Guardado local frecuente para no perder progreso
      widget.pet.saveLocal(); 

      return true;
    });
  }

  void _despertar() async {
    setState(() {
      widget.pet.isSleeping = false;
      _sizeNutria = 250;
      _oscuridad = 0.0;
    });

    widget.pet.notificar(); // Avisa a otras pantallas que despertó

    // Guardado final en Spring Boot
    widget.pet.lastUpdate = DateTime.now().millisecondsSinceEpoch;
    await widget.pet.saveToServer(widget.pet.id);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Image.asset(
            "assets/images/sleep.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          // Status Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet, userId: widget.userId),
          ),

          // Nutria animada
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: _sizeNutria,
              child: Image.asset(widget.pet.isSleeping ? _imgDormida : _imgDespierta),
            ),
          ),

          // Capa de oscuridad
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                color: Colors.black.withOpacity(_oscuridad),
              ),
            ),
          ),

          // Botón de Dormir / Despertar
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: widget.pet.isSleeping ? _despertar : _dormir,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E2E2E),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: Text(
                  widget.pet.isSleeping ? "Despertar" : "Dormir",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),

          // Menú
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 3),
          ),
        ],
      ),
    );
  }
}