import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import '../widgets/top_status_bar.dart';

class GameRoomScreen extends StatefulWidget {

  final Pet pet;
  final PageController controller;

  const GameRoomScreen({
    super.key,
    required this.pet,
    required this.controller
  });

  @override
  State<GameRoomScreen> createState() => _GameRoomScreenState();
}

class _GameRoomScreenState extends State<GameRoomScreen> {

  void jugar() {

    setState(() {
      widget.pet.jugar();
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Image.asset(
            "assets/game.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

                    Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet),
          ),

          Center(
            child: Image.asset(
              "assets/pet.png",
              width: 200,
            ),
          ),

          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: jugar,
                child: const Text("Jugar"),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: menu(widget.controller,4),
          ),

        ],
      ),
    );
  }
}