import 'package:flutter/material.dart';
import '../models/puzzle_piece2.dart';

class PuzzleTile2 extends StatelessWidget {
  final PuzzlePiece2 piece;

  const PuzzleTile2({
    super.key,
    required this.piece,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        piece.imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}