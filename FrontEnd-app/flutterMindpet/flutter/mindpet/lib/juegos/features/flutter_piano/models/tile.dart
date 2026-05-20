class Tile {
  int row;          // fila en la pantalla
  int col;          // columna (carril)
  bool isActive;    // si es la ficha correcta
  bool isTapped;    // si ya fue tocada
  double y;         // posición vertical (para animación)
  String image;     // imagen de la ficha

  Tile({
    required this.row,
    required this.col,
    required this.isActive,
    required this.y,
    required this.image,
    this.isTapped = false,
  });

  void move(double speed) {
    y += speed;
  }

  bool isOutOfScreen(double screenHeight) {
    return y > screenHeight;
  }
}