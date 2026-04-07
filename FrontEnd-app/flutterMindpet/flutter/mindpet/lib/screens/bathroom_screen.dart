import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class BathroomScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const BathroomScreen({
    super.key,
    required this.pet,
    required this.controller,
    required this.userId
    
  });

  @override
  State<BathroomScreen> createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen> {
  bool banando = false;
  int objetoActual = 0;
  List<String> objetos = ["jabon", "ducha"];
  bool jabonUsado = false;

  //...___...

  @override
  void initState() {
    super.initState();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return false;

      setState(() {
        widget.pet.updateWithTime();
      });

      return true;
    });
  }

  void usarJabon() {
    setState(() {
      banando = true;
      widget.pet.banarse();
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        banando = false;
      });
    });
  }

  void siguiente() {
    setState(() {
      objetoActual = (objetoActual + 1) % objetos.length;
    });
  }

  void anterior() {
    setState(() {
      objetoActual = (objetoActual - 1 + objetos.length) % objetos.length;
    });
  }

  void usarObjeto() {
    String objeto = objetos[objetoActual];

    if (objeto == "jabon") {
      setState(() {
        jabonUsado = true;
      });
    } else if (objeto == "ducha") {
      if (!jabonUsado) return;

      setState(() {
        widget.pet.higiene = 100;
        jabonUsado = false;
      });

      widget.pet.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 1️⃣ FONDO
          Image.asset(
            "assets/images/bano.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          /// 2️⃣ BARRA SUPERIOR
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet, userId:widget.userId ,),
          ),

          /// 3️⃣ MASCOTA (CENTRO)
          Center(child: Image.asset("images/nutria-parada.gif", width: 250)),

          /// 4️⃣ OBJETOS (🔥 AQUÍ VA TU SISTEMA NUEVO)
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// ⬅️ IZQUIERDA
                    IconButton(
                      onPressed: anterior,
                      icon: const Icon(Icons.arrow_left, size: 40),
                    ),

                    /// OBJETO
                    Column(
                      children: [
                        Image.asset(
                          objetos[objetoActual] == "jabon"
                              ? "images/jabon.png"
                              : "images/ducha.png",
                          width: 80,
                        ),

                        const SizedBox(height: 8),

                        ElevatedButton(
                          onPressed: usarObjeto,
                          child: const Text("Usar"),
                        ),
                      ],
                    ),

                    /// ➡️ DERECHA
                    IconButton(
                      onPressed: siguiente,
                      icon: const Icon(Icons.arrow_right, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// 5️⃣ MENÚ INFERIOR (NO TOCAR)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 1),
          ),
        ],
      ),
    );
  }
}
