import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/card_model.dart';
import '../services/game_logic.dart';
import '../widgets/game_board.dart';
import '../../../coin_manager.dart';

class MemoryGameScreen extends StatefulWidget {
  final int userId;
  const MemoryGameScreen({super.key, required this.userId});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCardModel> cards = [];

  int level = 1;
  int coins = 0;
  int timeLeft = 60;
  bool soundOn = true;

  Timer? timer;
  int? firstIndex;
  int? secondIndex;
  bool isBusy = false;

  bool timeFrozen = false; // 🔥 FIX REAL

  final musicPlayer = AudioPlayer();
  final sfxPlayer = AudioPlayer();
  late ConfettiController confettiController;

  // ================= MENU =================

  void mostrarMenu() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Container(
              padding: const EdgeInsets.all(20),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 8),

                      Text(
                        "Ajustes",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ▶ REANUDAR
                  _botonMenu(
                    texto: "Reanudar",
                    icono: Icons.play_arrow,
                    colores: [Color(0xFF8EC5FF), Color(0xFFB8A1FF)],
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  // 🔄 REINICIAR
                  _botonMenu(
                    texto: "Reiniciar juego",
                    icono: Icons.refresh,
                    colores: [Color(0xFFFFC371), Color(0xFFFF5F6D)],
                    onTap: () {
                      Navigator.pop(context);
                      startGame();
                    },
                  ),

                  const SizedBox(height: 12),

                  // 🚪 SALIR
                  _botonMenu(
                    texto: "Salir",
                    icono: Icons.logout,
                    colores: [Color(0xFF7F7FD5), Color(0xFF91EAE4)],
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
        padding: const EdgeInsets.symmetric(vertical: 14),
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

            const SizedBox(width: 8),

            Text(
              texto,
              style: const TextStyle(
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

  @override
  void initState() {
    super.initState();
    startGame();

    Future.delayed(const Duration(milliseconds: 500), () async {
      await musicPlayer.setReleaseMode(ReleaseMode.loop);
      await musicPlayer.setVolume(1.0);
      //lo dejo comentariado pq se escucha en todas las pantallas ----------------------------------------------

     // await musicPlayer.play(AssetSource('sounds/Relaxation.mp3'));
    });

    confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    musicPlayer.dispose();
    sfxPlayer.dispose();
    confettiController.dispose();
    super.dispose();
  }

  void startGame() {
    cards = GameLogic().initializeGame(level);
    timeLeft = 60;
    startTimer();
    setState(() {});
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!timeFrozen) {
        if (timeLeft > 0) {
          setState(() => timeLeft--);
        } else {
          t.cancel();
          showLoseDialog();
        }
      }
    });
  }

  // ================= WIN =================
  void showWinDialog() {
    coins += 30;
    CoinManager.instance.addCoins(widget.userId,30);

    if (soundOn) {
      sfxPlayer.play(AssetSource('sounds/Victory.mp3'));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🖼️ TU IMAGEN DE GANASTE
            Image.asset(
              "juegos/images/juego4/winImage.png", // cámbiala por la tuya
              width: 380,
              fit: BoxFit.cover,
            ),

            // ▶ BOTÓN REINTENTAR

            // ▶ BOTÓN SIGUIENTE
            Positioned(
              bottom: 60,
              right: 35,
              child: SizedBox(
                width: 170,
                height: 55,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pop(context);
                      level++;
                      startGame();
                    },
                  ),
                ),
              ),
            ),

            // 🚪 BOTÓN SALIR
            Positioned(
              bottom: 60,
              left: 35,
              child: SizedBox(
                width: 170,
                height: 55,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOSE =================
  void showLoseDialog() {
    if (soundOn) {
      sfxPlayer.play(AssetSource('sounds/GameOver.mp3'));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 🖼️ IMAGEN LOSE
            Image.asset(
              "juegos/images/juego4/loseImage.png",
              width: 380,
              fit: BoxFit.cover,
            ),

            // ▶ BOTÓN REINTENTAR
            Positioned(
              bottom: 60,
              right: 35,
              child: SizedBox(
                width: 170,
                height: 55,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.pop(context);
                      startGame();
                    },
                  ),
                ),
              ),
            ),

            // 🚪 BOTÓN SALIR
            Positioned(
              bottom: 60,
              left: 35,
              child: SizedBox(
                width: 170,
                height: 55,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= LOGICA =================



  void onCardTap(int index) {
    if (isBusy || cards[index].isFlipped || cards[index].isMatched) return;

    setState(() => cards[index].isFlipped = true);

    if (firstIndex == null) {
      firstIndex = index;
    } else {
      secondIndex = index;
      isBusy = true;
      checkMatch();
    }
  }

  void checkMatch() {
    if (cards[firstIndex!].image == cards[secondIndex!].image) {
      cards[firstIndex!].isMatched = true;
      cards[secondIndex!].isMatched = true;
      resetTurn();
    } else {
      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          cards[firstIndex!].isFlipped = false;
          cards[secondIndex!].isFlipped = false;
        });
        resetTurn();
      });
    }
  }

  void resetTurn() {
    firstIndex = null;
    secondIndex = null;
    isBusy = false;

    if (cards.every((c) => c.isMatched)) {
      timer?.cancel();
      confettiController.play();
      Future.delayed(const Duration(milliseconds: 300), showWinDialog);
    }

    setState(() {});
  }

  // ================= PODERES PRO =================

  // Función auxiliar para mostrar el diálogo de confirmación
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

  void revealPair() async {
    if (isBusy) return;

    int costo = 50; 

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Revelar Pareja");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido con await)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución del poder
    for (int i = 0; i < cards.length; i++) {
      for (int j = i + 1; j < cards.length; j++) {
        if (!cards[i].isMatched &&
            !cards[j].isMatched &&
            cards[i].image == cards[j].image) {
          isBusy = true;

          setState(() {
            cards[i].isFlipped = true;
            cards[j].isFlipped = true;
          });

          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              cards[i].isMatched = true;
              cards[j].isMatched = true;
            });

            isBusy = false;
            resetTurn();
          });

          return;
        }
      }
    }
  }

  void revealAll() async {
    if (isBusy) return;

    int costo = 70; 

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Revelar Todo");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido: agregado await y widget.userId)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución del poder
    isBusy = true;

    setState(() {
      for (var c in cards) {
        c.isFlipped = true;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        for (var c in cards) {
          if (!c.isMatched) c.isFlipped = false;
        }
      });

      isBusy = false;
    });
  }

  void addTime() async {
    if (timeFrozen) return;

    int costo = 40; 

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Congelar Tiempo");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido: agregado await y widget.userId)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución del poder
    setState(() {
      timeLeft += 20;
      timeFrozen = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      timeFrozen = false;
    });
  }

  void bombPower() async {
    if (isBusy) return;

    int costo = 100; 

    // 1. Confirmación del usuario
    bool confirmar = await _confirmarGasto(costo, "Bomba");
    if (!confirmar) return;

    // 2. Intento de cobro de monedas (Corregido: agregado await y widget.userId)
    bool gastoExitoso = await CoinManager.instance.spendCoins(widget.userId, costo);
    if (!gastoExitoso) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Necesitas $costo monedas o error de conexión")),
      );
      return;
    }

    // 3. Ejecución del poder
    for (int i = 0; i < cards.length; i++) {
      for (int j = i + 1; j < cards.length; j++) {
        if (!cards[i].isMatched &&
            !cards[j].isMatched &&
            cards[i].image == cards[j].image) {
          setState(() {
            cards[i].isMatched = true;
            cards[j].isMatched = true;
          });

          resetTurn();
          return;
        }
      }
    }
  }

  // ================= UI =================
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "⏱ $timeLeft",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          AnimatedBuilder(
            animation: CoinManager.instance,
            builder: (context, _) {
              return Row(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber),

                  const SizedBox(width: 5),

                  Text(
                    "${CoinManager.instance.coins}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),

          IconButton(
            icon: Icon(
              soundOn ? Icons.volume_up : Icons.volume_off,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                soundOn = !soundOn;
                musicPlayer.setVolume(soundOn ? 1 : 0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: const Icon(Icons.search), onPressed: revealPair),
        IconButton(icon: const Icon(Icons.visibility), onPressed: revealAll),
        IconButton(icon: const Icon(Icons.timer), onPressed: addTime),
        IconButton(icon: const Icon(Icons.bolt), onPressed: bombPower),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "juegos/images/juego4/background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(child: _topBar()),

                      IconButton(
                        onPressed: mostrarMenu,
                        icon: const Icon(Icons.settings, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GameBoard(cards: cards, onCardTap: onCardTap),
                ),
                _bottomBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
