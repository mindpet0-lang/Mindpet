import 'dart:math';
import '../models/card_model.dart';

class GameLogic {
  final List<String> images = [
    "assets/juegos/images/juego4/angry_otter.jpeg",
    "assets/juegos/images/juego4/anxiety_otter.png",
    "assets/juegos/images/juego4/bored_otter.png",
    "assets/juegos/images/juego4/dislike_otter.png",
    "assets/juegos/images/juego4/happy_otter.png",
    "assets/juegos/images/juego4/jealousy_otter.png",
    "assets/juegos/images/juego4/nostalgia_otter.png",
    "assets/juegos/images/juego4/sad_otter.png",
    "assets/juegos/images/juego4/scary_otter.png",
    "assets/juegos/images/juego4/shame_otter.png",
  ];

  List<MemoryCardModel> initializeGame(int level) {
    int pairs = 4 + level;

    final shuffled = List<String>.from(images)..shuffle();
    final selected = shuffled.take(pairs).toList();

    final allCards = [...selected, ...selected];
    allCards.shuffle();

    return allCards.map((img) => MemoryCardModel(image: img)).toList();
  }
}