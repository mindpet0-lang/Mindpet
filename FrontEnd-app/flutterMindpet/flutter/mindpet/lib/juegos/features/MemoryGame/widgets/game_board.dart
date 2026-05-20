import 'package:flutter/material.dart';
import '../models/card_model.dart';
import 'memory_card.dart';

class GameBoard extends StatelessWidget {
  final List<MemoryCardModel> cards;
  final Function(int) onCardTap;

  const GameBoard({
    super.key,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center( // 🔥 CENTRADO TOTAL
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount;

          if (constraints.maxWidth < 500) {
            crossAxisCount = 3;
          } else if (constraints.maxWidth < 900) {
            crossAxisCount = 4;
          } else {
            crossAxisCount = 5;
          }

          return GridView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            itemCount: cards.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemBuilder: (_, index) {
              return MemoryCard(
                card: cards[index],
                onTap: () => onCardTap(index),
              );
            },
          );
        },
      ),
    );
  }
}