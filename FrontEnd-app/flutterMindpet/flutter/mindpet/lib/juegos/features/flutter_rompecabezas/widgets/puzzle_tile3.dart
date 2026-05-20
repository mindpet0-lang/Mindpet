import 'package:flutter/material.dart';
import '../models/puzzle_piece3.dart';

class PuzzleTile3 extends StatelessWidget {
  final PuzzlePiece3 piece;

  const PuzzleTile3({
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

