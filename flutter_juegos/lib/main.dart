import 'package:flutter/material.dart';
import 'package:flutter_memorygame/features/MemoryGame/screens/memory_game_screen.dart';
import 'package:flutter_memorygame/features/flutter_piano/screens/gameScreenPiano.dart';
import 'package:flutter_memorygame/features/flutter_puzles/screens/gameScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MenuPrincipal(),
    );
  }
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {

    final apps = [
      {
        "name": "Piano",
        "image": "assets/images/JuegoPianoPortada.png",
        "screen":  GameScreenPiano(),
      },
      {
        "name": "Mahjong",
        "image": "assets/images/JuegoPuzzlePortada.png",
        "screen":  GameScreen(),
      },
      {
        "name": "Memoria",
        "image": "assets/images/JuegoMemoriaPortada.png",
        "screen": const MemoryGameScreen(),
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/FondoMenu.png"),
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
                          color: Color.fromARGB(255, 0, 0, 0),
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
    );
  }
}