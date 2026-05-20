import 'package:flutter/material.dart';
import '../models/puzzle_piece6.dart';

class PuzzleTile6 extends StatelessWidget {
  final PuzzlePiece6 piece;

  const PuzzleTile6({
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