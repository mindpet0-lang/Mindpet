import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/MemoryGame/screens/memory_game_screen.dart';
import 'features/borbujas/screens/bubble_screen.dart';
import 'features/flutter_piano/screens/gameScreenPiano.dart';
import 'features/flutter_puzles/screens/gameScreen.dart';
import 'features/flutter_rompecabezas/Screens/puzzle_homeScreen.dart';
import 'features/flutter_rompecabezas/services/coins_service.dart';
import 'features/respiracion/Screens/ball_screen.dart';
import 'coin_manager.dart';

bool showExercises = false;

class MenuPrincipal extends StatefulWidget {
  final int userId;
  const MenuPrincipal({super.key, required this.userId});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();

  
}


class _MenuPrincipalState extends State<MenuPrincipal> {

@override
void initState() {
  super.initState();
  
  // Esto se ejecuta "de golpe" apenas el usuario entra a la pantalla
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Le pasamos el ID del usuario actual para que traiga sus monedas inmediatamente
    CoinManager.instance.fetchMonedas(widget.userId);
  });
}

  Widget build(BuildContext context) {
    final apps = [
      {
        "name": "Piano",
        "image": "juegos/images/JuegoPianoPortada.png",
        "screen": GameScreenPiano(userId: widget.userId),
      },
      {
        "name": "Mahjong",
        "image": "juegos/images/JuegoPuzzlePortada.png",
        "screen": GameScreen(userId: widget.userId),
      },
      {
        "name": "Rompecabezas",
        "image": "juegos/images/JuegoRompecabezasPortada.png",
        "screen": HomeScreen(userId: widget.userId),
      },
      {
        "name": "Memoria",
        "image": "juegos/images/JuegoMemoriaPortada.png",
        "screen": MemoryGameScreen(userId: widget.userId),
      },
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("juegos/images/FondoMenu.png"),
                fit: BoxFit.cover,
              ),
            ),

            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile = constraints.maxWidth < 800;

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
                  iconSize = 135;
                }

                // 📱 MOBILE
                // 📱 MOBILE
                if (isMobile) {
                  return Stack(
                    children: [
                      // JUEGOS
                      SizedBox.expand(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            width: constraints.maxWidth,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 80,
                                left: 20,
                                right: 20,
                                bottom: 20,
                              ),
                              itemCount: apps.length,

                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 4,
                                    childAspectRatio: 0.72,
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
                                    );
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
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // PANEL DESLIZABLE
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),

                        right: showExercises ? 0 : -220,
                        top: 0,
                        bottom: 0,

                        child: Container(
                          width: 220,

                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            color: const Color(0xFFB39DDB).withOpacity(0.95),

                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              bottomLeft: Radius.circular(25),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 10,
                              ),
                            ],
                          ),

                          child: Column(
                            children: [
                              const SizedBox(height: 80),

                              const Text(
                                "Ejercicios",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 20),

                              _exerciseCard(
                                context,
                                "Borbujas",
                                "juegos/images/ejercicio1.png",
                                BubbleScreen(userId: widget.userId),
                              ),

                              _exerciseCard(
                                context,
                                "Respiracion",
                                "juegos/images/ejercicio2.png",
                                BallScreen(userId: widget.userId),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // BOTÓN FLECHA
                      Positioned(
                        right: 15,
                        bottom: 25,

                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showExercises = !showExercises;
                            });
                          },

                          child: Container(
                            padding: const EdgeInsets.all(14),

                            decoration: BoxDecoration(
                              color: const Color(0xFF9575CD),
                              shape: BoxShape.circle,

                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 8,
                                ),
                              ],
                            ),

                            child: Icon(
                              showExercises
                                  ? Icons.arrow_forward_ios
                                  : Icons.arrow_back_ios,

                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                // 💻 PC / TABLET
                return Row(
                  children: [
                    // 🎮 JUEGOS
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: SizedBox(
                          width: 900, // controla ancho total
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),

                            itemCount: apps.length,

                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing:
                                      20, // menos separación horizontal
                                  mainAxisSpacing:
                                      10, // menos separación vertical
                                  childAspectRatio:
                                      1.25, // hace que queden más juntitos
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
                                  );
                                },

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        app["image"] as String,
                                        width: 210,
                                        height: 210,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Text(
                                      app["name"] as String,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // EJERCICIOS DERECHA
                    Container(
                      width: 320,

                      margin: const EdgeInsets.only(
                        right: 25,
                        top: 25,
                        bottom: 25,
                      ),

                      padding: const EdgeInsets.all(20),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Column(
                        children: [
                          const Text(
                            "Ejercicios",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),

                          const SizedBox(height: 25),

                          Expanded(
                            child: ListView(
                              children: [
                                _exerciseCard(
                                  context,
                                  "Borbujas",
                                  "juegos/images/ejercicio1.png",
                                  BubbleScreen(userId: widget.userId),
                                ),

                                _exerciseCard(
                                  context,
                                  "Respiracion",
                                  "juegos/images/ejercicio2.png",
                                  BallScreen(userId: widget.userId),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // ⬅️ BOTÓN VOLVER (SUPERIOR DERECHA)
          Positioned(
            top: 40,
            left: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBC2EB), Color(0xFFA18CD1)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
          // MONEDAS
          Positioned(
            top: 35,
            left: 90,
            child: AnimatedBuilder(
              animation: CoinManager.instance,
              builder: (context, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFA18CD1), Color(0xFFFBC2EB)],
                    ),

                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],

                    border: Border.all(color: Colors.white, width: 2),
                  ),

                  child: Row(
                    children: [
                      // ICONO MONEDA
                      Container(
                        padding: const EdgeInsets.all(6),

                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),

                        child: const Icon(
                          Icons.monetization_on,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // TEXTO
                      // Busca este bloque en tu diseño y cámbialo por esto:
                      Consumer<CoinManager>(
                        builder: (context, coinManager, child) {
                          return Text(
                            "${coinManager.coins}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                            ),
                          );
                        },
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

Widget _exerciseCard(
  BuildContext context,
  String title,
  String image,
  Widget screen,
) {
  return GestureDetector(
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    },

    child: Container(
      margin: const EdgeInsets.only(bottom: 20),

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: Image.asset(
              image,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ],
      ),
    ),
  );
}
