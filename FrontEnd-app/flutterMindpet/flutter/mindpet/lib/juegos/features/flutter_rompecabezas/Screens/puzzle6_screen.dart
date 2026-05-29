import 'dart:async';
import 'package:flutter/material.dart';
import '../models/puzzle_piece6.dart';
import '../services/puzzle_service6.dart';
import '../widgets/puzzle_tile6.dart';
import '../../../coin_manager.dart';

class PuzzleScreen6 extends StatefulWidget {

  final int userId;
  const PuzzleScreen6({super.key, required this.userId});

  @override
  State<PuzzleScreen6> createState() => _PuzzleScreenState();
}

class _PuzzleScreenState extends State<PuzzleScreen6> {
  final int rows = 6;
final int cols = 4;
  bool hasStarted = false;

  late List<PuzzlePiece6?> board;
  late List<PuzzlePiece6> shuffledPieces;

  // ⏱️ TIMER
  int seconds = 0;
  Timer? timer;

  final List<String> images = [
    'assets/juegos/images/juego3/juego6/puzzle1.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle2.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle3.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle4.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle5.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle6.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle7.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle8.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle9.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle10.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle11.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle12.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle13.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle14.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle15.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle16.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle17.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle18.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle19.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle20.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle21.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle22.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle23.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle24.jpeg',
    'assets/juegos/images/juego3/juego6/puzzle25.jpeg',
  ];

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
  final pieces = PuzzleService6.generatePieces(rows, cols, images);

  board = List.filled(rows * cols, null);

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
              'assets/images/juego3/ganaste.png',
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
              'assets/images/juego3/fondo.png', 
              fit: BoxFit.cover,
            ),
          ),

          // 🌫️ OSCURECER UN POCO (opcional)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
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
              // 🧩 TABLERO
Center(
  child: LayoutBuilder(
    builder: (context, constraints) {

      double boardWidth;
      double boardHeight;

  if (constraints.maxWidth > 900) {
  boardWidth = 320;   // antes 350
  boardHeight = 480;  // antes 520
} else if (constraints.maxWidth > 600) {
  boardWidth = 270;   // antes 300
  boardHeight = 420;  // antes 470
} else {
  boardWidth = 210;   // antes 230
  boardHeight = 330;  // antes 360
}

      return SizedBox(
        width: boardWidth,
        height: boardHeight,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rows * cols,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
          ),
          itemBuilder: (context, index) {
            final currentPiece = board[index];

            return DragTarget<PuzzlePiece6>(
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
                      ? Draggable<PuzzlePiece6>(
                          onDragStarted: startTimerIfNeeded,
                          data: currentPiece,
                          feedback: SizedBox(
                            width: boardWidth / cols,
                            height: boardHeight / rows,
                            child: PuzzleTile6(piece: currentPiece),
                          ),
                          childWhenDragging: Container(
                            color: Colors.transparent,
                          ),
                          child: PuzzleTile6(piece: currentPiece),
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

      return Draggable<PuzzlePiece6>(
        data: piece,
        feedback: SizedBox(
          width: 60,
          height: 60,
          child: PuzzleTile6(piece: piece),
        ),
        childWhenDragging: Container(
          color: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: PuzzleTile6(piece: piece),
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