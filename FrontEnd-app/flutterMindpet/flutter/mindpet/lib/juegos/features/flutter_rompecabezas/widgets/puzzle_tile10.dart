import 'package:flutter/material.dart';
import '../models/puzzle_piece10.dart';

class PuzzleTile10 extends StatelessWidget {
  final PuzzlePiece10 piece;

  const PuzzleTile10({
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

