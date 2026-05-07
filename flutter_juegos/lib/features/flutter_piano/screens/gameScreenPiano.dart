import 'package:flutter/material.dart';
import 'dart:async';
import '../models/tile.dart';
import '../widgets/tileWidget.dart';
import '../services/gameLogic.dart';
import 'package:audioplayers/audioplayers.dart';

class GameScreenPiano extends StatefulWidget {
  @override
  _GameScreenPianoState createState() => _GameScreenPianoState();
}

class _GameScreenPianoState extends State<GameScreenPiano> {
  late GameLogic game;
  Timer? timer;

  double screenWidth = 0;
  double screenHeight = 0;
  double tileWidth = 0;

  double tileHeight = 180;

  bool gameStarted = false;
  bool musicaIniciada = false;
  bool gameOver = false;

  final AudioPlayer bgPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    game = GameLogic();

    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  void updateGame() {
    if (!gameStarted || gameOver) return;

    setState(() {
      game.moverTiles(screenHeight);

      if (game.tiles.isEmpty || game.tiles.last.y > 150) {
        game.generarTile(tileWidth);
      }

      if (game.verificarDerrota(screenHeight)) {
        timer?.cancel();
        mostrarGameOver();
      }
    });
  }

  void onTileTap(Tile tile) {
    if (gameOver) return;

    bool correcto = game.verificarToque(tile);

    if (correcto) {
      setState(() {
        game.tiles.remove(tile);
      });
    } else {
      timer?.cancel();
      mostrarGameOver();
    }
  }

  void mostrarGameOver() {
    gameOver = true;
    bgPlayer.stop();
    musicaIniciada = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                "assets/images/juego1/gameover_ui.png",
                width: 300,
              ),

              Positioned(
                top: 40,
                child: Column(
                  children: [
                    const Text(
                      "Monedas",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${game.score}",
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 20,
                left: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    reiniciar();
                  },
                  child: Container(
                    width: 110,
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                right: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      gameStarted = false;
                      gameOver = false;
                    });
                  },
                  child: Container(
                    width: 110,
                    height: 50,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void reiniciar() {
    setState(() {
      game.reiniciar();
      gameStarted = true;
      gameOver = false;
    });

    iniciarMusica();

    timer?.cancel();
    timer = Timer.periodic(const Duration(milliseconds: 16), (timer) {
      updateGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    bool esPC = screenWidth > 600;
    double boardWidth = esPC ? 300 : screenWidth;

    tileWidth = boardWidth / game.columns;

    if (!gameStarted) {
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                esPC
                    ? "assets/images/juego1/fondoPc.png"
                    : "assets/images/juego1/fondo.png",
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    gameStarted = true;
                  });
                  iniciarMusica();
                },
                child: Container(
                  width: 250,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: AssetImage("assets/images/juego1/boton_inicio.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              esPC
                  ? "assets/images/juego1/fondoPc.png"
                  : "assets/images/juego1/fondo.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: boardWidth,
                  height: screenHeight,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ...game.tiles.map((tile) {
                        return TileWidget(
                          tile: tile,
                          width: tileWidth,
                          height: tileHeight,
                          onTap: onTileTap,
                        );
                      }).toList(),

                      ...List.generate(game.columns - 1, (index) {
                        return Positioned(
                          left: tileWidth * (index + 1),
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 2,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        );
                      }),

                      if (!esPC)
                        Positioned(
                          top: 40,
                          left: 5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Puntos",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Text(
                                "${game.score}",
                                style: const TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                if (esPC) ...[
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Puntos",
                        style:
                            TextStyle(fontSize: 24, color: Colors.white),
                      ),
                      Text(
                        "${game.score}",
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    bgPlayer.dispose();
    super.dispose();
  }

  void iniciarMusica() async {
    try {
      if (musicaIniciada) return;

      musicaIniciada = true;

      await bgPlayer.stop();
      await bgPlayer.setReleaseMode(ReleaseMode.loop);

      await bgPlayer.play(
        AssetSource('sounds/Can-Can.mp3'),
        volume: 1.0,
      );
    } catch (e) {
      print("ERROR AUDIO: $e");
    }
  }
}