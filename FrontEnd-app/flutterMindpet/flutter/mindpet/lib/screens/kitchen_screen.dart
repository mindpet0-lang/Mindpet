import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class KitchenScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;

  const KitchenScreen({super.key, required this.pet, required this.controller});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  String estadoEat = "mages/nutria-parada.gif";
  String comiendo = "mages/nutria-comiendo.gif";
  String normal = "mages/nutria-parada.gif";


  void comer() {
    setState(() {
      widget.pet.comer();
      estadoEat = comiendo;
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
            "assets/images/kitchen.png",
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

          Center(child: Image.asset("images/nutria-parada.gif", width: 250)),

          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.pet.comer();
                  });
                  widget.pet.save();
                },
                child: const Text("Dar comida"),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 2),
          ),
        ],
      ),
    );
  }
}
