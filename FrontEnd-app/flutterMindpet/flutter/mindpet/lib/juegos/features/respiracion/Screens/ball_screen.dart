import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../Models/ball_model.dart';
import '../Services/ball_srevice.dart';
import '../Widgets/ball_widget.dart';
import '../../../coin_manager.dart';

class BallScreen extends StatefulWidget {
  final int userId;
  const BallScreen({super.key, required this.userId});

  @override
  State<BallScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<BallScreen>
    with SingleTickerProviderStateMixin {
  late BallService ballService;

  bool isRunning = false;
  bool showHoldText = false;
  bool showExhaleText = false;

  int coins = 0;

  final BallModel ball = BallModel(size: 100, startY: 500, endY: 100);

  final AudioPlayer bgMusic = AudioPlayer();

  // ================= MENU =================

  void mostrarMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.menu, color: Colors.white),
                      SizedBox(width: 8),

                      Text(
                        "Menú",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ▶ REANUDAR
                  _botonMenu(
                    texto: "Reanudar",
                    icono: Icons.play_arrow,
                    colores: [Color(0xFF8EC5FF), Color(0xFFB8A1FF)],
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  // 🔄 REINICIAR
                  _botonMenu(
                    texto: "Reiniciar",
                    icono: Icons.refresh,
                    colores: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
                    onTap: () {
                      Navigator.pop(context);

                      setState(() {
                        showHoldText = false;
                        showExhaleText = false;
                        isRunning = false;
                      });

                      ballService.controller.reset();
                    },
                  ),

                  const SizedBox(height: 12),

                  // 🚪 SALIR
                  _botonMenu(
                    texto: "Salir",
                    icono: Icons.logout,
                    colores: [Color(0xFF7F7FD5), Color(0xFF91EAE4)],
                    onTap: () async {
                      await bgMusic.stop();

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
              offset: Offset(0, 4),
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

  @override
  void initState() {
    super.initState();

    ballService = BallService();

    ballService.init(vsync: this, startY: ball.startY, endY: ball.endY);

    // 🎵 configuración inicial del audio (solo una vez)
    bgMusic.setReleaseMode(ReleaseMode.loop);
    bgMusic.setVolume(0.4);
  }

  Future<void> startAnimation() async {
    if (isRunning) return;

    setState(() {
      isRunning = true;
    });

    while (mounted) {
      // 🔼 INHALA
      setState(() {
        showHoldText = false;
        showExhaleText = false;
      });

      await ballService.controller.forward();

      if (!mounted) return;

      // ✋ MANTENLO
      setState(() {
        showHoldText = true;
        showExhaleText = false;

        coins += 1;
      });

      CoinManager.instance.addCoins(widget.userId, 1);

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // 🌬️ EXHALA
      setState(() {
        showHoldText = false;
        showExhaleText = true;
      });

      await ballService.controller.reverse();

      if (!mounted) return;

      await Future.delayed(const Duration(seconds: 2));

      break;
    }

    setState(() {
      showHoldText = false;
      showExhaleText = false;
      isRunning = false;
    });
  }

  @override
  void dispose() {
    ballService.dispose();
    bgMusic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SizedBox.expand(
        child: Stack(
          children: [
            // 🌄 FONDO
            Positioned.fill(
              child: Image.asset(
                'assets/juegos/images/ejercicio2/nutriaFeliz.png',
                fit: BoxFit.cover,
              ),
            ),

            // ⚽ PELOTA
            AnimatedBuilder(
              animation: ballService.animation,
              builder: (context, child) {
                return BallWidget(
                  top: ballService.animation.value,
                  size: ball.size,
                );
              },
            ),

            // 🫁 HOLD
            if (showHoldText)
              const Positioned(
                top: 65,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "MANTENLO",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

            // 🌬️ EXHALA
            if (showExhaleText)
              const Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    "EXHALA",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),

            // ⚙️ AJUSTES
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                onPressed: mostrarMenu,
                icon: const Icon(Icons.menu, color: Colors.white, size: 32),
              ),
            ),

            // 💰 MONEDAS
            Positioned(
              top: 40,
              right: 20,
              child: AnimatedBuilder(
                animation: CoinManager.instance,
                builder: (context, _) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [

                        Text(
                          "💛${CoinManager.instance.coins}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ▶️ BOTÓN
            if (!isRunning)
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),

                    onPressed: () async {
                      // 🎵 IMPORTANTE: NO reiniciar si ya está sonando
                      if (bgMusic.state != PlayerState.playing) {
                        await bgMusic.play(
                          AssetSource('sounds/sonidos_de_agua.mp3'),
                        );
                      }

                      startAnimation();
                    },

                    child: const Text("Inhala"),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
