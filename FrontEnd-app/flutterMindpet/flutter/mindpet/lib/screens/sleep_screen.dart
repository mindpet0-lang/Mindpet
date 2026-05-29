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
    required this.userId,
  });

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  double _oscuridad = 0.0;
  final String _imgDormida = "assets/images/nutria-durmiendo.gif";
  double _sizeNutria = 250;

  @override
  void initState() {
    super.initState();
    if (widget.pet.isSleeping) {
      _oscuridad = 0.7;
      _sizeNutria = 450;
      _iniciarBucleEnergia();
    }
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

    setState(() {
      widget.pet.isSleeping = true;
      _sizeNutria = 450;
    });

    widget.pet.notificar(); 

    await widget.pet.saveToServer(widget.pet.id);

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

      // SOLUCIÓN AQUÍ: El bucle SOLO se detiene si sales de la pantalla o si el usuario la despierta manualmente.
      // Eliminamos por completo cualquier llamada automática a _despertar() o cambios de tamaño de nutria aquí dentro.
      if (!mounted || !widget.pet.isSleeping) {
        return false;
      }

      // Si ya está al 100%, la energía no pasa de ahí, pero el bucle sigue esperando pacientemente
      // a que el usuario presione la lámpara para despertarla de verdad.
      if (widget.pet.energia < 100) {
        setState(() {
          widget.pet.energia += 2;
          if (widget.pet.energia > 100) widget.pet.energia = 100;
        });
        widget.pet.saveLocal();
      }

      return true;
    });
  }

  void _despertar() async {
    if (!mounted) return;
    
    setState(() {
      widget.pet.isSleeping = false;
      _sizeNutria = 250;
      _oscuridad = 0.0;
    });

    widget.pet.notificar(); 

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
            "assets/images/fondo/sleep.png",
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
            child: ListenableBuilder(
              listenable: widget.pet,
              builder: (context, child) {
                String imagenAMostrar = widget.pet.isSleeping
                    ? _imgDormida
                    : widget.pet.imagenActual;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: _sizeNutria,
                  child: Image.asset(
                    imagenAMostrar,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.pets,
                      size: 100,
                      color: Colors.white24,
                    ),
                  ),
                );
              },
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

          // Mensajes dinámicos en la pantalla (Aparecen segundo a segundo gracias al ListenableBuilder)
          Positioned(
            top: 120, 
            left: 20,
            right: 20,
            child: ListenableBuilder(
              listenable: widget.pet,
              builder: (context, child) {
                String mensaje = "";

                if (widget.pet.isSleeping) {
                  if (widget.pet.energia >= 100) {
                    mensaje = "prende la luz para que tu mascota despierte";
                  }
                } else {
                  if (widget.pet.energia < 30) {
                    mensaje = "apaga la luz para que tu mascota duerma";
                  }
                }

                if (mensaje.isEmpty) return const SizedBox.shrink();

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black54, 
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Text(
                    mensaje,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),

          // Botón de Dormir / Despertar solo con imagen
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: widget.pet.isSleeping ? _despertar : _dormir,
                child: Image.asset(
                  widget.pet.isSleeping
                      ? "assets/images/lamparaoff.png"
                      : "assets/images/lamparaon.png",
                  width: 100,
                  height: 100,
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