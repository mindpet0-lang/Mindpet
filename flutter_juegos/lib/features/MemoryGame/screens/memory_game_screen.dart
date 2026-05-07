import 'dart:async';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/card_model.dart';
import '../services/game_logic.dart';
import '../widgets/game_board.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    startGame();

    Future.delayed(const Duration(milliseconds: 500), () async {
      await musicPlayer.setReleaseMode(ReleaseMode.loop);
      await musicPlayer.setVolume(1.0);
      await musicPlayer.play(AssetSource('sounds/Relaxation.mp3'));
    });

    confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
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

    if (soundOn) {
      sfxPlayer.play(AssetSource('sounds/Victory.mp3'));
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          height: 260,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/juego4/winImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("GANASTE 30 MindPet Monedas", style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    level++;
                    startGame();
                  },
                  child: const Text("Siguiente"),
                )
              ],
            ),
          ),
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
        child: Container(
          height: 260,
          width: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
              image: AssetImage("assets/images/juego4/loseImage.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tiempo agotado",
                    style: TextStyle(color: Colors.white)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    startGame();
                  },
                  child: const Text("Reintentar"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGICA =================
  void onCardTap(int index) {
    if (isBusy ||
        cards[index].isFlipped ||
        cards[index].isMatched) return;

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

  void revealPair() {
    if (isBusy) return;

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

  void revealAll() {
    if (isBusy) return;

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

  void addTime() {
    if (timeFrozen) return;

    setState(() {
      timeLeft += 20;
      timeFrozen = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      timeFrozen = false;
    });
  }

  void bombPower() {
    if (isBusy) return;

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("⏱ $timeLeft"),
        IconButton(
          icon: Icon(soundOn ? Icons.volume_up : Icons.volume_off),
          onPressed: () {
            setState(() {
              soundOn = !soundOn;
              musicPlayer.setVolume(soundOn ? 1 : 0);
            });
          },
        ),
      ],
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
              "assets/images/juego4/background.png",
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _topBar(),
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