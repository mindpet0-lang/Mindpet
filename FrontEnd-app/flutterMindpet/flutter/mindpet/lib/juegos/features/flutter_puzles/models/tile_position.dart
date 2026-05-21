

import 'Tile.dart';

class TilePosition {
  final int x;
  final int y;
  final int z; 

  final Tile tile;

  TilePosition({
    required this.x,
    required this.y,
    required this.z,
    required this.tile,
  });
}