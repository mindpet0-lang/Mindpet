import 'package:flutter/material.dart';
import '../models/puzzle_piece8.dart';

class PuzzleTile8 extends StatelessWidget {
  final PuzzlePiece8 piece;

  const PuzzleTile8({
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

