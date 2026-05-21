import 'dart:async';
import 'package:flutter/material.dart';
import '../models/puzzle_piece11.dart';
import '../services/puzzle_service11.dart';
import '../widgets/puzzle_tile11.dart';
import '../../../coin_manager.dart';

class PuzzleScreen11 extends StatefulWidget {
  final int userId;
  const PuzzleScreen11({super.key, required this.userId});

  @override
  State<PuzzleScreen11> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen11> {
  final int size = 4;
  bool hasStarted = false;

  late List<PuzzlePiece11?> board;
  late List<PuzzlePiece11> shuffledPieces;

  // ⏱️ TIMER
  int seconds = 0;
  Timer? timer;

  final List<String> images = [
    'juegos/images/juego3/juego11/puzzle1.jpeg',
    'juegos/images/juego3/juego11/puzzle2.jpeg',
    'juegos/images/juego3/juego11/puzzle3.jpeg',
    'juegos/images/juego3/juego11/puzzle4.jpeg',
    'juegos/images/juego3/juego11/puzzle5.jpeg',
    'juegos/images/juego3/juego11/puzzle6.jpeg',
    'juegos/images/juego3/juego11/puzzle7.jpeg',
    'juegos/images/juego3/juego11/puzzle8.jpeg',
    'juegos/images/juego3/juego11/puzzle9.jpeg',
    'juegos/images/juego3/juego11/puzzle10.jpeg',
    'juegos/images/juego3/juego11/puzzle11.jpeg',
    'juegos/images/juego3/juego11/puzzle12.jpeg',
    'juegos/images/juego3/juego11/puzzle13.jpeg',
    'juegos/images/juego3/juego11/puzzle14.jpeg',
    'juegos/images/juego3/juego11/puzzle15.jpeg',
    'juegos/images/juego3/juego11/puzzle16.jpeg',
  ];

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    final pieces = PuzzleService11.generatePieces(size, images);

    board = List.filled(size * size, null);

    // SOLO mezclas las piezas, NO las imágenes
    shuffledPieces = List.from(pieces)..shuffle();

    seconds = 0;
    hasStarted = false;
    timer?.cancel();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  int calculateCoins() {
    if (seconds <= 60) return 100;
    if (seconds <= 120) return 70;
    if (seconds <= 180) return 50;
    return 20;
  }

  void checkWin() {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null || board[i]!.imagePath != images[i]) {
        return;
      }
    }

    timer?.cancel();
    int reward = calculateCoins();

    CoinManager.instance.addCoins(widget.userId, reward);

    print("MONEDAS ACTUALES: ${CoinManager.instance.coins}");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),

        child: SizedBox(
  width: 400,
  height: 420,

          child: Stack(
            children: [
              // IMAGEN
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'juegos/images/juego3/ganaste.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),

              // TIEMPO
              Positioned(
                top: 195,
                right: 115,
                child: Text(
                  formatTime(seconds),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // MONEDAS
              Positioned(
                top: 225,
                right: 125,
                child: Text(
                  '$reward',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 43, 32, 0),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // BOTON SALIR
              Positioned(
                bottom: 30,
                left: 45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 230,
                    height: 80,
                    color: Colors.transparent,
                  ),
                ),
              ),

              // BOTON REINICIAR
              Positioned(
                bottom: 30,
                right: 45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    setState(() {
                      startGame();
                    });
                  },
                  child: Container(
                    width: 260,
                    height: 80,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimerIfNeeded() {
    if (!hasStarted) {
      hasStarted = true;

      timer = Timer.periodic(const Duration(seconds: 1), (t) {
        setState(() {
          seconds++;
        });
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rompecabezas')),
      body: Stack(
        children: [
          // 🖼️ FONDO
          Positioned.fill(
            child: Image.asset(
              'juegos/images/juego3/fondo.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🌫️ OSCURECER UN POCO (opcional)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          Column(
            children: [
              const SizedBox(height: 10),

              // ⏱️ TIMER
              Text(
                "Tiempo: ${formatTime(seconds)}",
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              // 🧩 TABLERO
              Center(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double boardWidth;
                    double boardHeight;

                    if (constraints.maxWidth > 900) {
                      boardWidth = 400; // antes 350
                      boardHeight = 420; // antes 520
                    } else if (constraints.maxWidth > 600) {
                      boardWidth = 320; // antes 300
                      boardHeight = 350; // antes 470
                    } else {
                      boardWidth = 280; // antes 230
                      boardHeight = 270; // antes 360
                    }
                    return SizedBox(
                      width: boardWidth,
                      height: boardHeight,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: size * size,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: size,
                        ),
                        itemBuilder: (context, index) {
                          final currentPiece = board[index];

                          return DragTarget<PuzzlePiece11>(
                            onAccept: (incomingPiece) {
                              startTimerIfNeeded();

                              setState(() {
                                int? oldIndex;

                                for (int i = 0; i < board.length; i++) {
                                  if (board[i] == incomingPiece) {
                                    oldIndex = i;
                                    break;
                                  }
                                }

                                if (oldIndex != null) {
                                  final temp = board[index];
                                  board[index] = incomingPiece;
                                  board[oldIndex] = temp;
                                } else {
                                  final replacedPiece = board[index];

                                  board[index] = incomingPiece;
                                  shuffledPieces.remove(incomingPiece);

                                  if (replacedPiece != null) {
                                    shuffledPieces.add(replacedPiece);
                                  }
                                }
                              });

                              checkWin();
                            },
                            builder: (context, candidateData, rejectedData) {
                              return Container(
                                margin: const EdgeInsets.all(2),
                                color: Colors.grey[300],
                                child: currentPiece != null
                                    ? Draggable<PuzzlePiece11>(
                                        onDragStarted: startTimerIfNeeded,
                                        data: currentPiece,
                                        feedback: SizedBox(
                                          width: boardWidth / size,
                                          height: boardHeight / size,
                                          child: PuzzleTile11(
                                            piece: currentPiece,
                                          ),
                                        ),
                                        childWhenDragging: Container(
                                          color: Colors.transparent,
                                        ),
                                        child: PuzzleTile11(
                                          piece: currentPiece,
                                        ),
                                      )
                                    : const SizedBox(),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.width < 600 ? 25 : 5,
              ),

              // 🔀 PIEZAS ABAJO EN 2 FILAS
              SizedBox(
                height: 130,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: shuffledPieces.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    final piece = shuffledPieces[index];

                    return Draggable<PuzzlePiece11>(
                      data: piece,
                      feedback: SizedBox(
                        width: 60,
                        height: 60,
                        child: PuzzleTile11(piece: piece),
                      ),
                      childWhenDragging: Container(color: Colors.transparent),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: PuzzleTile11(piece: piece),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
