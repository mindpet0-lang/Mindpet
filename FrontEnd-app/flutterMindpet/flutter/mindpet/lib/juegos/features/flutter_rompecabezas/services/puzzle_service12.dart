import '../models/puzzle_piece12.dart';

class PuzzleService12 {
  static List<PuzzlePiece12> generatePieces(int size, List<String> images) {
    List<PuzzlePiece12> pieces = [];

    int total = size * size;

    for (int i = 0; i < total; i++) {
      int x = i % size;
      int y = i ~/ size;

      // 🔥 usar una imagen diferente SOLO si existe
      String imagePath = images[i % images.length];

      pieces.add(
  PuzzlePiece12(
    imagePath: imagePath,
    correctIndex: i,
  ),
);
    }

    return pieces;
  }

  static bool isCompleted(List<PuzzlePiece12?> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null || board[i]!.correctIndex != i) {
        return false;
      }
    }
    return true;
  }
  
}