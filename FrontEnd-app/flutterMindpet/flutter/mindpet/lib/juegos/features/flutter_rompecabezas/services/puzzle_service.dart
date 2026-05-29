import '../models/puzzle_piece.dart';

class PuzzleService {
  static List<PuzzlePiece> generatePieces(int size, List<String> images) {
    List<PuzzlePiece> pieces = [];

    int total = size * size;

    for (int i = 0; i < total; i++) {
      

      // 🔥 usar una imagen diferente SOLO si existe
      String imagePath = images[i % images.length];

      pieces.add(
  PuzzlePiece(
    imagePath: imagePath,
    correctIndex: i,
  ),
);
    }

    return pieces;
  }

  static bool isCompleted(List<PuzzlePiece?> board) {
    for (int i = 0; i < board.length; i++) {
      if (board[i] == null || board[i]!.correctIndex != i) {
        return false;
      }
    }
    return true;
  }
  
}