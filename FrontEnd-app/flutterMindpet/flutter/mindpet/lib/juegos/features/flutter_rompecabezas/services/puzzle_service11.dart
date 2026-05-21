import '../models/puzzle_piece11.dart';

class PuzzleService11 {
  static List<PuzzlePiece11> generatePieces(int size, List<String> images) {
    List<PuzzlePiece11> pieces = [];

    int total = size * size;

    for (int i = 0; i < total; i++) {
      int x = i % size;
      int y = i ~/ size;

      // 🔥 usar una imagen diferente SOLO si existe
      String imagePath = images[i % images.length];

      pieces.add(
  PuzzlePiece11(
    imagePath: imagePath,
    correctIndex: i,
  ),
);
    }

    return pieces;
  }

  static bool isCompleted(List<PuzzlePiece11?> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null || board[i]!.correctIndex != i) {
        return false;
      }
    }
    return true;
  }
  
}