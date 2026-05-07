import 'package:flutter/material.dart';
import '../models/tile_position.dart';

class TileWidget extends StatelessWidget {
  final TilePosition tilePos;
  final VoidCallback onTap;

  const TileWidget({
    required this.tilePos,
    required this.onTap,
  });

  // 🖼️ MAPA DE IMÁGENES
  String getImage(String tipo) {
    switch (tipo) {
      case "A": return "assets/images/juego2/A.png";
      case "B": return "assets/images/juego2/B.png";
      case "C": return "assets/images/juego2/C.png";
      case "D": return "assets/images/juego2/D.png";
      case "E": return "assets/images/juego2/E.png";
      case "F": return "assets/images/juego2/F.png";
      case "G": return "assets/images/juego2/G.png";
      case "H": return "assets/images/juego2/H.png";
      case "I": return "assets/images/juego2/I.png";
      case "J": return "assets/images/juego2/J.png";
      case "K": return "assets/images/juego2/K.png";
      case "L": return "assets/images/juego2/L.png";
      case "M": return "assets/images/juego2/M.png";
      case "N": return "assets/images/juego2/N.png";
      case "Ñ": return "assets/images/juego2/Ñ.png";
      case "O": return "assets/images/juego2/O.png";
      case "P": return "assets/images/juego2/P.png";
      case "Q": return "assets/images/juego2/Q.png";
      case "R": return "assets/images/juego2/R.png";
      case "S": return "assets/images/juego2/S.png";
      case "T": return "assets/images/juego2/T.png";
      case "U": return "assets/images/juego2/U.png";
      case "V": return "assets/images/juego2/V.png";
      case "W": return "assets/images/juego2/W.png";
      case "X": return "assets/images/juego2/X.png";
      case "Y": return "assets/images/juego2/Y.png";
      case "Z": return "assets/images/juego2/Z.png";
      case "AA": return "assets/images/juego2/AA.png";
      case "BB": return "assets/images/juego2/BB.png";
      case "CC": return "assets/images/juego2/CC.png";
      default: return "assets/images/juego2/default.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    final tile = tilePos.tile;

    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: tile.isRemoved ? 0.0 : 1.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        transform: tile.isSelected
            ? (Matrix4.identity()..scale(1.08))
            : Matrix4.identity(),
        curve: Curves.easeInOut,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),

              // 🎨 GRADIENTE BONITO
              gradient: LinearGradient(
                colors: tile.isSelected
                    ? [Color(0xFFB8E0D2), Color(0xFF8FD3C1)]
                    : [Colors.white, Color(0xFFE3F2FD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),

              // 🌟 SOMBRA
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],

              // 🔵 BORDE
              border: Border.all(
                color: tile.isSelected
                    ? Colors.teal
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),

            // 👇 CONTENIDO
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _buildContent(tile),
            ),
          ),
        ),
      ),
    );
  }

  // 🔄 CAMBIA ENTRE TEXTO E IMAGEN
  Widget _buildContent(tile) {
    // 👉 SI QUIERES USAR IMÁGENES
    return Image.asset(
      getImage(tile.tipo),
      fit: BoxFit.cover,
    );

    // 👉 SI QUIERES TEXTO (por ahora)
    /*
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: tile.isSelected ? 22 : 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        child: Text(tile.tipo),
      ),
    );
    */
  }
}