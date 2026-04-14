import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class KitchenScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const KitchenScreen({
    super.key,
    required this.pet,
    required this.controller,
    required this.userId,
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  // 1. Variables para controlar la animación local
  String imgNutria = "images/nutria-parada.gif";
  bool comiendo = false;

  void comer() async {
    if (comiendo || widget.pet.isSleeping) return;

    // Si el hambre es 100, ya no cabe más comida
    if (widget.pet.hambre >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Tu nutria ya no tiene más espacio en la pancita!"),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }

    setState(() {
      comiendo = true;
      imgNutria = "images/nutria-comiendo.gif";
    });

    widget.pet.comer();
    await widget.pet.saveLocal();
    await widget.pet.saveToServer(widget.pet.id);

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        comiendo = false;
        imgNutria = "images/nutria-parada.gif";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Bucle para actualizar barras en tiempo real
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo de cocina
          Image.asset(
            "assets/images/kitchen.png",
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

          // 2. LA NUTRIA (Con lógica de si está durmiendo o no)
          Center(
            child: widget.pet.isSleeping
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bedtime, color: Colors.white, size: 50),
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
                  )
                : Image.asset(imgNutria, width: 250),
          ),

          // 3. BOTÓN (Deshabilitado si duerme)
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: (widget.pet.isSleeping || comiendo) ? null : comer,
                style: ElevatedButton.styleFrom(
                  // Si llegó a 100, el botón cambia de color a "lleno"
                  backgroundColor: widget.pet.hambre >= 100
                      ? Colors.blueGrey
                      : const Color(0xFF4CAF50),
                ),
                child: Text(
                  widget.pet.hambre >= 100
                      ? "¡Satisfecha!"
                      : (comiendo ? "Comiendo..." : "Dar comida"),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 2),
          ),
        ],
      ),
    );
  }
}
