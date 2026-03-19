import 'package:flutter/material.dart';
import '../models/pet.dart';
import 'home_screen.dart';
import '../widgets/top_status_bar.dart';

class KitchenScreen extends StatefulWidget {

  final Pet pet;
  final PageController controller;

  const KitchenScreen({
    super.key,
    required this.pet,
    required this.controller
  });

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {

  void comer() {

    setState(() {
      widget.pet.comer();
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          Image.asset(
            "assets/kitchen.png",
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
                onPressed: comer,
                child: const Text("Dar comida"),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: menu(widget.controller,2),
          ),

        ],
      ),
    );
  }
}