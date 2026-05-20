import 'package:flutter/material.dart';
import '../models/puzzle_piece13.dart';

class PuzzleTile13 extends StatelessWidget {
  final PuzzlePiece13 piece;

  const PuzzleTile13({
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

