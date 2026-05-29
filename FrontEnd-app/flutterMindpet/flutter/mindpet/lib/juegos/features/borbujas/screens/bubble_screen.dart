import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/bubble_model.dart';
import '../services/bubble_service.dart';
import '../widgets/bubble_widget.dart';
import '../../../coin_manager.dart';


class BubbleScreen extends StatefulWidget {
  final int userId;
  const BubbleScreen({super.key, required this.userId});

  @override
  State<BubbleScreen> createState() => _BubbleScreenState();
}

class _BubbleScreenState extends State<BubbleScreen> {
  final BubbleService _service = BubbleService();
  final List<BubbleModel> _bubbles = [];
  final AudioPlayer _audioPlayer = AudioPlayer();

  late Timer _timer;

  // 📏 tamaño de pantalla seguro
  Size get screenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _spawnBubble(),
    );
  }

  void mostrarMenu() {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 350,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(25),

              border: Border.all(
                color: Colors.white.withOpacity(0.3),
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // TITULO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.settings, color: Colors.white),
                    SizedBox(width: 8),

                    Text(
                      "Ajustes",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // REANUDAR
                _botonMenu(
                  texto: "Reanudar",
                  icono: Icons.play_arrow,
                  colores: [
                    Color(0xFF8EC5FF),
                    Color(0xFFB8A1FF),
                  ],
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(height: 12),

                // SALIR
                _botonMenu(
                  texto: "Salir",
                  icono: Icons.logout,
                  colores: [
                    Color(0xFF7F7FD5),
                    Color(0xFF91EAE4),
                  ],
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
Widget _botonMenu({
  required String texto,
  required IconData icono,
  required List<Color> colores,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,

    child: Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 14),

      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colores),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(icono, color: Colors.white),

          const SizedBox(width: 8),

          Text(
            texto,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    ),
  );
}

  void _spawnBubble() {
    final size = screenSize;

    final newBubble = _service.generateBubble(
      maxWidth: size.width,
      maxHeight: size.height - 120, // 👈 espacio UI seguro
    );

    setState(() {
      _bubbles.addAll(newBubble);
    });

    // ⏳ auto eliminar burbujas
    for (var bubble in newBubble) {
      Future.delayed(const Duration(seconds: 4), () {
        if (!mounted) return;

        setState(() {
          _bubbles.removeWhere((b) => b.id == bubble.id);
        });
      });
    }
  }

  void _popBubble(BubbleModel bubble) async {
  final givesCoins = _service.popBubble(bubble);

  setState(() {
    _bubbles.removeWhere((b) => b.id == bubble.id);
  });

  // 💥 sonido pop
  await _audioPlayer.play(AssetSource('sounds/POP.mp3'));

  if (givesCoins) {

  // 🪙 sumar monedas globales
  CoinManager.instance.addCoins(widget.userId, 5);

  await _audioPlayer.play(
    AssetSource('sounds/coin.mp3'),
  );

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("🪙 +5 monedas"),
      duration: Duration(milliseconds: 500),
    ),
  );
}
}

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/juegos/images/ejercicio1/fondoLago.png"),
            fit: BoxFit.cover, // 👈 responsive real
          ),
        ),

        child: Container(
          color: Colors.black.withOpacity(0.12), // 👈 mejora contraste
          child: Stack(
            children: [
              // 🪙 contador
              Positioned(
  top: 50,
  left: 20,
  child: AnimatedBuilder(
    animation: CoinManager.instance,
    builder: (context, _) {
      return Text(
        "🪙 Monedas: ${CoinManager.instance.coins}",
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    },
  ),
),

// ⚙️ BOTON AJUSTES
Positioned(
  top: 40,
  right: 20,

  child: IconButton(
    icon: const Icon(
      Icons.settings,
      color: Colors.white,
      size: 32,
    ),

    onPressed: mostrarMenu,
  ),
),

              // 🫧 burbujas
              ..._bubbles.map((bubble) {
                return Positioned(
                  left: bubble.x,
                  top: bubble.y,
                  child: BubbleWidget(
                    bubble: bubble,
                    onTap: () => _popBubble(bubble),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}