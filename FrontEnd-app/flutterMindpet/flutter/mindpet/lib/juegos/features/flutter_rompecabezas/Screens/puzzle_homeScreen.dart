import 'package:flutter/material.dart';
import 'puzzle10_screen.dart';
import 'puzzle11_screen.dart';
import 'puzzle12_screen.dart';
import 'puzzle13_screen.dart';
import 'puzzle14_screen.dart';
import 'puzzle2_screen.dart';
import 'puzzle3_screen.dart';
import 'puzzle5_screen.dart';
import 'puzzle6_screen.dart';
import 'puzzle7_screen.dart';
import 'puzzle8_screen.dart';
import 'puzzle9_screen.dart';
import 'puzzle_screen.dart';
import '../../../coin_manager.dart';
import '../../../menu-principal.dart';


// importa aquí tus otras pantallas

class HomeScreen extends StatefulWidget {
  final int userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  // ================= MENU =================
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
                  offset: const Offset(0, 10),
                )
              ],
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                // TITULO
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: const [
                    Icon(Icons.menu, color: Colors.white),

                    SizedBox(width: 8),

                    Text(
                      "Menú",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ▶ CONTINUAR
                _botonMenu(
                  texto: "Continuar",
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

                // 🚪 SALIR
                _botonMenu(
                  texto: "Salir",
                  icono: Icons.logout,

                  colores: [
                    Color(0xFF7F7FD5),
                    Color(0xFF91EAE4),
                  ],

                  onTap: () {
                    Navigator.pop(context);

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MenuPrincipal(userId: widget.userId),
                      ),
                      (route) => false,
                    );
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
          )
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
  Widget build(BuildContext context) {
    final apps = [
      {
        "name": "Puzzle1",
        "image": "assets/juegos/images/juego3/puzle1.png",
        "screen": PuzzleScreen(userId: widget.userId),
      },
      {
        "name": "Puzzle2",
        "image": "assets/juegos/images/juego3/puzle2.jpeg",
        "screen": PuzzleScreen2(userId: widget.userId),
      },
      {
        "name": "Puzle3",
        "image": "assets/juegos/images/juego3/puzle3.jpeg",
        "screen": PuzzleScreen3(userId: widget.userId),
      },
      {
        "name": "Puzle4",
        "image": "assets/juegos/images/juego3/puzle5.jpeg",
        "screen": PuzzleScreen5(userId: widget.userId),
      },
      {
        "name": "Puzzle5",
        "image": "assets/juegos/images/juego3/puzle7.jpeg",
        "screen": PuzzleScreen6(userId: widget.userId),
      },
      {
        "name": "Puzle6",
        "image": "assets/juegos/images/juego3/puzle8.jpeg",
        "screen": PuzzleScreen7(userId: widget.userId),
      },
      {
        "name": "Puzle7",
        "image": "assets/juegos/images/juego3/puzle9.jpeg",
        "screen": PuzzleScreen8(userId: widget.userId),
      },
      {
        "name": "Puzle8",
        "image": "assets/juegos/images/juego3/puzle10.jpeg",
        "screen": PuzzleScreen9(userId: widget.userId),
      },
      {
        "name": "Puzle9",
        "image": "assets/juegos/images/juego3/puzle11.jpeg",
        "screen": PuzzleScreen10(userId: widget.userId),
      },
      {
        "name": "Puzle10",
        "image": "assets/juegos/images/juego3/puzle12.jpeg",
        "screen": PuzzleScreen11(userId: widget.userId),
      },
      {
        "name": "Puzle11",
        "image": "assets/juegos/images/juego3/puzle13.jpeg",
        "screen": PuzzleScreen12(userId: widget.userId),
      },
      {
        "name": "Puzle12",
        "image": "assets/juegos/images/juego3/puzle14.jpeg",
        "screen": PuzzleScreen13(userId: widget.userId),
      },
      {
        "name": "Puzle13",
        "image": "assets/juegos/images/juego3/puzle15.jpeg",
        "screen": PuzzleScreen14(userId: widget.userId),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/juegos/images/juego3/fondo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                double iconSize;

                if (constraints.maxWidth > 900) {
                  crossAxisCount = 5;
                  iconSize = 120;
                } else if (constraints.maxWidth > 600) {
                  crossAxisCount = 3;
                  iconSize = 90;
                } else {
                  crossAxisCount = 2;
                  iconSize = 70;
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: apps.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 25,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final app = apps[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => app["screen"] as Widget,
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Image.asset(
                              app["image"] as String,
                              width: iconSize,
                              height: iconSize,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            app["name"] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ⚙️ AJUSTES
Positioned(
  top: 40,
  left: 20,

  child: GestureDetector(
    onTap: mostrarMenu,

    child: Container(
      padding: const EdgeInsets.all(12),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFA18CD1),
            Color(0xFFFBC2EB),
          ],
        ),

        shape: BoxShape.circle,

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
          ),
        ],
      ),

      child: const Icon(
        Icons.menu,
        color: Colors.white,
        size: 28,
      ),
    ),
  ),
),

          // MONEDAS
          Positioned(
            top: 40,
            right: 20,
            child: AnimatedBuilder(
              animation: CoinManager.instance,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '💛${CoinManager.instance.coins}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

    );
  }
}
