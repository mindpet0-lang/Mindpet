import 'package:flutter/material.dart';
import '../models/card_model.dart';

class MemoryCard extends StatelessWidget {
  final MemoryCardModel card;
  final VoidCallback onTap;

  const MemoryCard({super.key, required this.card, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.isMatched ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: card.isFlipped || card.isMatched
              ? Image.asset(
                  card.image,
                  fit: BoxFit.cover, // llena toda la card
                )
              : Image.asset(
                  "assets/images/juego4/background_card.png",
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}