import 'package:flutter/material.dart';
import '../models/puzzle_piece.dart';

class PuzzleTile extends StatelessWidget {
  final PuzzlePiece piece;

  const PuzzleTile({
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

