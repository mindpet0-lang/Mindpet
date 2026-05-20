import 'package:flutter/material.dart';
import '../models/puzzle_piece9.dart';

class PuzzleTile9 extends StatelessWidget {
  final PuzzlePiece9 piece;

  const PuzzleTile9({
    super.key,
    required this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        piece.imagePath, // ✅ cada pieza tiene su imagen
        fit: BoxFit.cover,
      ),
    );
  }
}

