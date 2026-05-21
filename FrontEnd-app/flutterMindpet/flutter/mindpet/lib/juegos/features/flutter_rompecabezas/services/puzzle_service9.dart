import '../models/puzzle_piece9.dart';

class PuzzleService9 {
  static List<PuzzlePiece9> generatePieces(int size, List<String> images) {
    List<PuzzlePiece9> pieces = [];

    int total = size * size;

    for (int i = 0; i < total; i++) {
      int x = i % size;
      int y = i ~/ size;

      // 🔥 usar una imagen diferente SOLO si existe
      String imagePath = images[i % images.length];

      pieces.add(
  PuzzlePiece9(
    imagePath: imagePath,
    correctIndex: i,
  ),
);
    }

    return pieces;
  }

  static bool isCompleted(List<PuzzlePiece9?> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null || board[i]!.correctIndex != i) {
        return false;
      }
    }
    return true;
  }
  
}