import 'dart:math';
import '../models/tile.dart';

class GameLogic {
  List<Tile> tiles = [];
  int score = 0;
  double speed = 1; // velocidad
  int columns = 4;
  int? lastColumn;

  Random random = Random();

  void generarTile(double width) {
  int col;

  do {
    col = random.nextInt(columns);
  } while (col == lastColumn); // ❌ evita repetir columna

  lastColumn = col;

  tiles.add(
    Tile(
      row: 0,
      col: col,
      isActive: true,
      y: -120,
      image: "juegos/images/juego1/nutria.png",
    ),
  );
}

  void moverTiles(double screenHeight) {
    for (var tile in tiles) {
      tile.move(speed);
    }

    tiles.removeWhere((tile) => tile.isOutOfScreen(screenHeight));
  }

  bool verificarToque(Tile tile) {
  if (tile.isActive && !tile.isTapped && esLaMasBaja(tile)) {
    tile.isTapped = true;
    score++;
    speed += 0.2; // 🔥 se acelera con el tiempo
    return true;
  }
  return false;
}

  bool verificarDerrota(double screenHeight) {
    for (var tile in tiles) {
      if (tile.y > screenHeight - 150 && !tile.isTapped) {
        return true;
      }
    }
    return false;
  }

  void reiniciar() {
    tiles.clear();
    score = 0;
    speed = 2;
  }

  bool esLaMasBaja(Tile tile) {
  // buscar la ficha más abajo en la misma columna
  Tile? masBaja;

  for (var t in tiles) {
    if (t.col == tile.col) {
      if (masBaja == null || t.y > masBaja.y) {
        masBaja = t;
      }
    }
  }

  return tile == masBaja;
}
}