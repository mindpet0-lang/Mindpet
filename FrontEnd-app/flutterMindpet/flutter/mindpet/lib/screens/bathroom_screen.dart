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
    required this.userId,
  });

  @override
  State<BathroomScreen> createState() => _BathroomScreenState();
}

class _BathroomScreenState extends State<BathroomScreen> {
  bool animandoAccion = false;
  int objetoActual = 0;
  List<String> objetos = ["jabon", "ducha"];
  bool jabonUsado = false;
  late String imgNutria; // Usa 'late'

  @override
  void initState() {
    super.initState();
    imgNutria = widget.pet.imagenActual; // Inicializa aquí
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

  void siguiente() =>
      setState(() => objetoActual = (objetoActual + 1) % objetos.length);
  void anterior() => setState(
    () => objetoActual = (objetoActual - 1 + objetos.length) % objetos.length,
  );

  void usarObjeto() async {
  if (widget.pet.isSleeping || animandoAccion) return;

  String objeto = objetos[objetoActual];

  if (objeto == "jabon") {
    setState(() {
      jabonUsado = true;
      animandoAccion = true;
      // AJUSTA ESTAS RUTAS A TUS CARPETAS REALES
      imgNutria = "assets/images/nutria/bano/nutria_jabon.gif"; 
    });
    widget.pet.higiene = (widget.pet.higiene + 30).clamp(0, 100);
    
  } else if (objeto == "ducha") {
    if (!jabonUsado) {
      _mensaje("¡Primero necesitas enjabonarla! 🧼");
      return;
    }
    setState(() {
      animandoAccion = true;
      imgNutria = "assets/images/nutria/bano/nutria_ducha.gif"; 
    });
    widget.pet.higiene = 100;
    jabonUsado = false;
  }

  // Notificar a los listeners para que la barra de arriba se actualice
  widget.pet.notifyListeners(); 

  await widget.pet.saveLocal();
  await Future.delayed(const Duration(seconds: 3));

  if (mounted) {
    setState(() {
      animandoAccion = false;
      // Al terminar la animación, vuelve al estado actual (que ahora debería ser limpia)
      imgNutria = widget.pet.imagenActual; 
    });
  }
}

  void _mensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
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
            child: TopStatusBar(pet: widget.pet, userId: widget.userId),
          ),

          /// 3️⃣ MASCOTA
          Center(
            child: ListenableBuilder(
              listenable: widget.pet,
              builder: (context, child) {
                // Si no estamos en medio de una animación de jabón o ducha,
                // dejamos que el modelo decida qué GIF mostrar
                if (!animandoAccion) {
                  imgNutria = widget.pet.imagenActual;
                }

                return widget.pet.isSleeping
                    ? _buildSleepingPlaceholder()
                    : Image.asset(
                        imgNutria,
                        width: 250,
                        // Evita el error 404 si la ruta falla por algún motivo
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.pets,
                              size: 100,
                              color: Colors.white54,
                            ),
                      );
              },
            ),
          ),

          /// 4️⃣ SELECTOR DE OBJETOS (Solo visible si no duerme)
          if (!widget.pet.isSleeping)
            Positioned(
              bottom: 110,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: animandoAccion ? null : anterior,
                    icon: const Icon(
                      Icons.arrow_left,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Column(
                    children: [
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: animandoAccion ? 0.5 : 1.0,
                        child: Image.asset(
                          objetos[objetoActual] == "jabon"
                              ? "images/jabon.png"
                              : "images/ducha.png",
                          width: 80,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: animandoAccion ? null : usarObjeto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: Text(
                          animandoAccion
                              ? "..."
                              : "Usar ${objetos[objetoActual]}",
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: animandoAccion ? null : siguiente,
                    icon: const Icon(
                      Icons.arrow_right,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

          /// 5️⃣ MENÚ INFERIOR
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
