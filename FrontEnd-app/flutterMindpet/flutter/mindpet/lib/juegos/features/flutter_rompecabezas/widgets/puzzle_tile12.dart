import 'package:flutter/material.dart';
import '../models/puzzle_piece12.dart';

class PuzzleTile12 extends StatelessWidget {
  final PuzzlePiece12 piece;

  const PuzzleTile12({
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

