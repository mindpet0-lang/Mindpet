import 'package:flutter/material.dart';
import '../models/puzzle_piece5.dart';

class PuzzleTile5 extends StatelessWidget {
  final PuzzlePiece5 piece;

  const PuzzleTile5({
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