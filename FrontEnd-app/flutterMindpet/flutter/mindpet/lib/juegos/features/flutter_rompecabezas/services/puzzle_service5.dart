import '../models/puzzle_piece5.dart';

class PuzzleService5 {
  // 🔥 Generar piezas para cualquier tamaño (ej: 4x7)
  static List<PuzzlePiece5> generatePieces(
    int rows,
    int cols,
    List<String> images,
  ) {
    List<PuzzlePiece5> pieces = [];

    int total = rows * cols;

    for (int i = 0; i < total; i++) {
      int x = i % cols;   // columna
      int y = i ~/ cols;  // fila

      // 🔥 usa imágenes disponibles (si faltan, repite)
      String imagePath = images[i % images.length];

      pieces.add(
        PuzzlePiece5(
          imagePath: imagePath,
          correctIndex: i,
          x: x,
          y: y,
        ),
      );
    }

    return pieces;
  }

  // 🏆 Verificar si el puzzle está completo
  static bool isCompleted(List<PuzzlePiece5?> board) {
    for (int i = 0; i < board.length; i++) {
      final piece = board[i];

      if (piece == null || piece.correctIndex != i) {
        return false;
      }
    }
    return true;
  }
}