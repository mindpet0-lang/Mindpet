import 'package:flutter/material.dart';
import '../models/puzzle_piece7.dart';

class PuzzleTile7 extends StatelessWidget {
  final PuzzlePiece7 piece;

  const PuzzleTile7({
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

