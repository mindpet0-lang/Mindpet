import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';
import '../juegos/menu-principal.dart';

class GameRoomScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const GameRoomScreen({
    super.key,
    required this.pet,
    required this.controller,
    required this.userId,
  });

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {
  late String imgNutria;
  bool jugando = false;

  @override
  void initState() {
    super.initState();
    imgNutria = widget.pet.imagenActual;
    _iniciarReloj();
  }

  void _iniciarReloj() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        widget.pet.updateWithTime();
      });
      return true;
    });
  }

  void jugar() async {
    if (jugando || widget.pet.isSleeping) return;

    // Validación de estados bajos
    if (widget.pet.energia < 20) {
      _mostrarMensaje("¡Tu nutria está muy cansada para jugar! 😴");
      return;
    }
    //if (widget.pet.hambre < 20) {
    //  _mostrarMensaje("¡Tiene demasiada hambre para jugar! 🍔");
    //  return;
    //}

    setState(() {
      jugando = true;
    });

    await widget.pet.saveLocal();
    await widget.pet.saveToServer(widget.pet.id);

    // Tiempo de juego
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      setState(() {
        jugando = false;
        imgNutria;
      });
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de cuarto de juegos
          Image.asset(
            "images/fondo/game.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet, userId: widget.userId),
          ),

          // Renderizado de la Nutria
          Center(
            child: widget.pet.isSleeping
                ? _buildSleepingPlaceholder()
                : Image.asset(imgNutria, width: 250),
          ),

          // Botón de Jugar
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MenuPrincipal(userId: widget.userId)),
                  );
                },
                child: Image.asset("images/control2.png", height: 75),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSleepingPlaceholder() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.bedtime,
            color: Color.fromARGB(255, 255, 255, 255),
            size: 50,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.black54,
            child: const Text(
              "Tu mascota está durmiendo...",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
