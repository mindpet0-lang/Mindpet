import 'package:flutter/material.dart';
import '../models/Tile.dart';
import '../models/tile_position.dart';
import '../widgets/tileWidget.dart';
import '../animations/victoria_animada.dart';
import '../animations/derrota_animada.dart';
import '../../../coin_manager.dart';
import '../../../menu-principal.dart';

class GameScreen extends StatefulWidget {
  final int userId;
  const GameScreen({super.key, required this.userId});
  
  @override
  _GameScreenState createState() => _GameScreenState();
  
}

class _GameScreenState extends State<GameScreen> {
  List<TilePosition> tiles = [];
  List<TilePosition> barra = [];
  List<List<TilePosition>> historial = [];

  bool juegoTerminado = false;

  int puntosPartida = 0;
  int puntosTotales = 0;

  @override
  void initState() {
    super.initState();
    generarTiles();
  }

  // ================= MENU =================
  void mostrarMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 350, // 👈 CLAVE: tamaño tipo móvil en PC
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 20,
                    offset: Offset(0, 10),
                  ),
                ],
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🧠 TÍTULO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Menú",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // ▶ REANUDAR
                  _botonMenu(
                    texto: "Reanudar",
                    icono: Icons.play_arrow,
                    colores: [Color(0xFF8EC5FF), Color(0xFFB8A1FF)],
                    onTap: () => Navigator.pop(context),
                  ),

                  SizedBox(height: 12),

                  // 🔄 REINICIAR
                  _botonMenu(
                    texto: "Reiniciar juego",
                    icono: Icons.refresh,
                    colores: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
                    onTap: () {
                      Navigator.pop(context);
                      reiniciarJuego();
                    },
                  ),

                  SizedBox(height: 12),

                  // 🚪 SALIR
                  _botonMenu(
                    texto: "Salir",
                    icono: Icons.logout,
                    colores: [Color(0xFF7F7FD5), Color(0xFF91EAE4)],

                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) =>  MenuPrincipal(userId: widget.userId),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _botonMenu({
    required String texto,
    required IconData icono,
    required List<Color> colores,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colores),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.white),
            SizedBox(width: 8),
            Text(
              texto,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGICA =================
  void guardarEstado() {
    historial.add(
      tiles
          .map(
            (t) => TilePosition(
              x: t.x,
              y: t.y,
              z: t.z,
              tile: Tile(
                id: t.tile.id,
                tipo: t.tile.tipo,
                isRemoved: t.tile.isRemoved,
              ),
            ),
          )
          .toList(),
    );
  }

  void onTileTap(TilePosition tile) {
    if (juegoTerminado) return;
    if (tile.tile.isRemoved) return;

    // 🚫 NUEVO: bloquear si tiene algo encima
    if (estaBloqueada(tile)) return;

    guardarEstado();

    setState(() {
      barra.add(
        TilePosition(
          x: tile.x,
          y: tile.y,
          z: tile.z,
          tile: Tile(id: tile.tile.id, tipo: tile.tile.tipo),
        ),
      );

      tile.tile.isRemoved = true;
      ordenarBarra();
    });

    verificarBarra();
  }

  void ordenarBarra() {
    barra.sort((a, b) => a.tile.tipo.compareTo(b.tile.tipo));
  }

  void verificarBarra() {
    Map<String, List<TilePosition>> grupos = {};

    for (var t in barra) {
      grupos.putIfAbsent(t.tile.tipo, () => []).add(t);
    }

    for (var entry in grupos.entries) {
      if (entry.value.length >= 3) {
        Future.delayed(Duration(milliseconds: 400), () {
          if (!mounted) return;

          setState(() {
            barra.removeWhere((t) => t.tile.tipo == entry.key);
            puntosPartida += 10;
          });

          verificarVictoria();
        });
        return;
      }
    }

    if (barra.length >= 7) {
      juegoTerminado = true;
      mostrarDerrota();
    }
  }

  void verificarVictoria() {
    if (tiles.every((t) => t.tile.isRemoved)) {
      juegoTerminado = true;
      puntosPartida += 50;

      CoinManager.instance.addCoins(widget.userId, puntosPartida);

      mostrarVictoria();
    }
  }

  void mostrarVictoria() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => VictoriaAnimada(
        onRestart: () {
          Navigator.pop(context);
          reiniciarJuego();
        },
      ),
    );
  }

  void mostrarDerrota() {
    puntosTotales += puntosPartida;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DerrotaAnimada(
        onRestart: () {
          Navigator.pop(context);
          reiniciarJuego();
        },
      ),
    );
  }
 //---PODERES----------------------
Future<bool> _confirmarGasto(int costo, String poder) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Obliga al usuario a interactuar con los botones
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Usar $poder"),
          content: Text("¿Quieres gastar 🪙 $costo monedas para activar este poder?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    ) ?? false;
  }

 void deshacerMovimiento() async { 
    if (historial.isEmpty) return;

    int costo = 50;

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Deshacer Movimiento");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido con await)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución de la acción
    setState(() {
      tiles = historial.removeLast();
      if (barra.isNotEmpty) barra.removeLast();
    });
  }

  void usarVarita() async { 
    if (juegoTerminado) return;

    int costo = 50;

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Usar Varita");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido: agregado await y widget.userId)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución de la acción
    Map<String, List<TilePosition>> mapa = {};

    for (var t in tiles.where((t) => !t.tile.isRemoved)) {
      mapa.putIfAbsent(t.tile.tipo, () => []).add(t);
    }

    for (var lista in mapa.values) {
      if (lista.length >= 3) {
        guardarEstado();

        setState(() {
          for (int i = 0; i < 3; i++) {
            barra.add(
              TilePosition(
                x: lista[i].x,
                y: lista[i].y,
                z: lista[i].z,
                tile: Tile(id: lista[i].tile.id, tipo: lista[i].tile.tipo),
              ),
            );
            lista[i].tile.isRemoved = true;
          }
          ordenarBarra();
        });

        verificarBarra();
        break;
      }
    }
  }

  void mezclarTiles() async { 
    if (juegoTerminado) return;

    int costo = 80;

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Mezclar Fichas");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido: agregado await y widget.userId)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución de la acción
    guardarEstado();

    List<TilePosition> disponibles = tiles
        .where((t) => !t.tile.isRemoved)
        .toList();

    List<String> tipos = disponibles.map((t) => t.tile.tipo).toList();
    tipos.shuffle();

    for (int i = 0; i < disponibles.length; i++) {
      disponibles[i].tile.tipo = tipos[i];
    }

    setState(() {});
  }

  void reiniciarJuego() {
    setState(() {
      generarTiles();
      barra.clear();
      historial.clear();
      juegoTerminado = false;
      puntosPartida = 0;
    });
  }

  void generarTiles() {
    tiles.clear();

    // 🔷 30 TIPOS
    List<String> base = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
      "AA",
      "BB",
      "CC",
    ];

    base.shuffle();

    // 🔷 30 tipos × 3 = 90 cartas
    List<String> tipos = [];
    for (var t in base.take(30)) {
      tipos.addAll([t, t, t]);
    }

    tipos.shuffle();

    int index = 0;

    // 🔥 LAYOUT GRANDE TIPO PIRÁMIDE
    List<List<List<int>>> layout = [
      // 🔻 BASE GRANDE (45)
      List.generate(5, (_) => List.filled(9, 1)),

      // 🔺 CAPA 2 (28)
      [
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
        [0, 1, 1, 1, 1, 1, 1, 1, 0],
      ],

      // 🔺 CAPA 3 (15)
      [
        [0, 0, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 0, 0],
        [0, 0, 1, 1, 1, 1, 1, 0, 0],
      ],

      // 🔺 CAPA 4 (6)
      [
        [0, 0, 0, 1, 1, 1, 0, 0, 0],
        [0, 0, 0, 1, 1, 1, 0, 0, 0],
      ],

      // 🔝 TOP (3)
      [
        [0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 1, 0, 0, 0, 0],
      ],
    ];

    for (int z = 0; z < layout.length; z++) {
      for (int y = 0; y < layout[z].length; y++) {
        for (int x = 0; x < layout[z][y].length; x++) {
          if (layout[z][y][x] == 1 && index < tipos.length) {
            tiles.add(
              TilePosition(
                x: x,
                y: y,
                z: z,
                tile: Tile(id: "$index", tipo: tipos[index]),
              ),
            );
            index++;
          }
        }
      }
    }
    asegurarTriosIniciales();
  }

  bool estaBloqueada(TilePosition tile) {
    return tiles.any(
      (t) =>
          !t.tile.isRemoved && t.z > tile.z && t.x == tile.x && t.y == tile.y,
    );
  }

  List<TilePosition> obtenerLibres() {
    return tiles.where((t) => !t.tile.isRemoved && !estaBloqueada(t)).toList();
  }

  int contarTriosDisponibles() {
    final libres = obtenerLibres();

    Map<String, int> conteo = {};

    for (var t in libres) {
      conteo[t.tile.tipo] = (conteo[t.tile.tipo] ?? 0) + 1;
    }

    return conteo.values.where((v) => v >= 3).length;
  }

  void asegurarTriosIniciales() {
    int intentos = 0;

    while (contarTriosDisponibles() < 3 && intentos < 50) {
      intentos++;

      // 🔹 agrupar por tipo (todas las fichas del tablero)
      Map<String, List<TilePosition>> mapa = {};

      for (var t in tiles) {
        if (!t.tile.isRemoved) {
          mapa.putIfAbsent(t.tile.tipo, () => []).add(t);
        }
      }

      // 🔹 filtrar solo los que tienen mínimo 3
      List<List<TilePosition>> grupos = mapa.values
          .where((g) => g.length >= 3)
          .toList();

      if (grupos.length < 3) return;

      grupos.shuffle();

      final libres = obtenerLibres();
      if (libres.length < 9) return;

      libres.shuffle();

      // 🔥 mover 3 grupos reales a posiciones libres
      for (int i = 0; i < 3; i++) {
        var grupo = grupos[i].take(3).toList();

        for (int j = 0; j < 3; j++) {
          // intercambiamos tipos (NO duplicamos)
          String temp = libres[i * 3 + j].tile.tipo;

          libres[i * 3 + j].tile.tipo = grupo[j].tile.tipo;
          grupo[j].tile.tipo = temp;
        }
      }
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    final boardWidth = isDesktop ? 700.0 : screenWidth * 0.95;
    final tileWidth = boardWidth / 9;
    final tileHeight = tileWidth * 1.2;

    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: AnimatedBuilder(
          animation: CoinManager.instance,
          builder: (context, _) {
            return Text("Majhong | 💛 ${CoinManager.instance.coins}");
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.menu), onPressed: mostrarMenu),
        ],
      ),

      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              isDesktop
                  ? "assets/juegos/images/juego2/fondo_desktop.png"
                  : "assets/juegos/images/juego2/fondo_mobile.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: isDesktop
                      ? LayoutBuilder(
                          builder: (context, constraints) {
                            final boardHeight = tileHeight * 7.5;
                            final offsetY =
                                (constraints.maxHeight - boardHeight) / 2 + 130;

                            return Center(
                              child: SizedBox(
                                width: boardWidth,
                                height: constraints.maxHeight,
                                child: Stack(
                                  children: tiles.map((tilePos) {
                                    if (tilePos.tile.isRemoved)
                                      return SizedBox();

                                    return Positioned(
                                      left: tilePos.x * tileWidth,
                                      top:
                                          (tilePos.y * tileHeight) -
                                          (tilePos.z * 20) +
                                          (isDesktop
                                              ? offsetY // 👈 PC usa su centrado
                                              : MediaQuery.of(
                                                      context,
                                                    ).size.height *
                                                    0.18), // 👈 SOLO móvil

                                      child: SizedBox(
                                        width: tileWidth,
                                        height: tileHeight,
                                        child: Opacity(
                                          opacity: estaBloqueada(tilePos)
                                              ? 0.4
                                              : 1,
                                          child: TileWidget(
                                            tilePos: tilePos,
                                            onTap: () => onTileTap(tilePos),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          },
                        )
                      : SingleChildScrollView(
                          child: Center(
                            child: Container(
                              width: boardWidth,
                              height: tileHeight * 10,
                              child: Stack(
                                children: tiles.map((tilePos) {
                                  if (tilePos.tile.isRemoved) return SizedBox();

                                  return Positioned(
                                    left: tilePos.x * tileWidth,
                                    top:
                                        (tilePos.y * tileHeight) -
                                        (tilePos.z * 20) +
                                        MediaQuery.of(context).size.height *
                                            0.25,

                                    child: SizedBox(
                                      width: tileWidth,
                                      height: tileHeight,
                                      child: Opacity(
                                        opacity: estaBloqueada(tilePos)
                                            ? 0.4
                                            : 1,
                                        child: TileWidget(
                                          tilePos: tilePos,
                                          onTap: () => onTileTap(tilePos),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                ),

                Container(
                  height: 110,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(7, (i) {
                        final slotWidth = isDesktop ? 55.0 : 42.0;
                        final slotHeight = isDesktop ? 78.0 : 60.0;

                        if (i < barra.length) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            width: slotWidth,
                            height: slotHeight,
                            child: TileWidget(tilePos: barra[i], onTap: () {}),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            width: slotWidth,
                            height: slotHeight,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        }
                      }),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: usarVarita,
                          icon: const Icon(Icons.auto_fix_high, size: 18),
                          label: const Text("Varita"),
                        ),
                      ),

                      SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: mezclarTiles,
                          icon: const Icon(Icons.shuffle, size: 18),
                          label: const Text("Revolver"),
                        ),
                      ),
                      const SizedBox(width: 6),

                      SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: deshacerMovimiento,
                          icon: const Icon(Icons.undo, size: 18),
                          label: const Text("Deshacer"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
