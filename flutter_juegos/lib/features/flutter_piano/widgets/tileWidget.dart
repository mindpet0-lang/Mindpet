import 'package:flutter/material.dart';
import '../models/tile.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;
  final double width;
  final double height;
  final Function(Tile) onTap;

  const TileWidget({
    required this.tile,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 🔥 ancho real de la ficha (más delgada)
    double tileRealWidth = width * 0.6;

    return Positioned(
      top: tile.y,

      // 🔥 CENTRADO PERFECTO EN LA COLUMNA
      left: (tile.col * width) + (width - tileRealWidth) / 2,

      child: GestureDetector(
        onTap: () => onTap(tile),
        child: Container(
          width: tileRealWidth,
          height: height,

          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(25), // 🔥 estilo píldora
          ),

          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              tile.image,
              fit: BoxFit.contain, // 🔥 NO se corta la imagen
            ),
          ),
        ),
      ),
    );
  }
}