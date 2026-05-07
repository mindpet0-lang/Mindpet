class Tile {
  String id;
  String tipo;
  bool isSelected;
  bool isRemoved;

  Tile({
    required this.id,
    required this.tipo,
    this.isSelected = false,
    this.isRemoved = false,
  });
}