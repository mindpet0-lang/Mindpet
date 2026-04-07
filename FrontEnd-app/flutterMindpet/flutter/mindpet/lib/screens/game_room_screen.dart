import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class GameRoomScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;



  const GameRoomScreen({
    super.key,
    required this.pet,
    required this.controller,
    required this.userId
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
void initState() {
  super.initState();

  Future.doWhile(() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return false;

    setState(() {
      widget.pet.updateWithTime();
    });

    return true;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/game.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet, userId: widget.userId,),
          ),

          Center(child: Image.asset("images/nutria-parada.gif", width: 250)),

          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.pet.jugar();
                  });
                  widget.pet.save();
                },
                child: const Text("Jugar"),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 4),
          ),
        ],
      ),
    );
  }
}
