import 'dart:math';
import '../models/bubble_model.dart';

class BubbleService {
  final Random _random = Random();

  int coins = 0;
  int _id = 0;

  List<BubbleModel> generateBubble({
    required double maxWidth,
    required double maxHeight,
  }) {
    bool isSpecial = _random.nextInt(5) == 0; // 20%

    final bubble = BubbleModel(
      id: _id++,
      x: _random.nextDouble() * (maxWidth - 60),
      y: _random.nextDouble() * (maxHeight - 200),
      givesCoins: isSpecial,

      // 🖼️ imagen según tipo
      image: isSpecial
          ? "assets/juegos/images/ejercicio1/bubble_coin.png"
          : "assets/juegos/images/ejercicio1/bubble_normal.png",
    );

    return [bubble];
  }

  bool popBubble(BubbleModel bubble) {
    if (bubble.givesCoins) {
      coins += 5;
      return true;
    }
    return false;
  }

  int getCoins() => coins;
}