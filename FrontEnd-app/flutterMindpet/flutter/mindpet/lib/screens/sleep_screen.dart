import 'package:flutter/material.dart';
import 'package:mindpet/widgets/bottom_menu.dart';
import '../models/pet.dart';
import '../widgets/top_status_bar.dart';

class SleepScreen extends StatefulWidget {
  final Pet pet;
  final PageController controller;
  final int userId;

  const SleepScreen({super.key, required this.pet, required this.controller,required this.userId});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  bool durmiendo = false;
  double oscuridad = 0.0;
  String despierta = "images/nutria-parada.gif";
  String dormida = "images/nutria-durmiendo.gif";
  String estadoSleep = "images/nutria-parada.gif";
  double size = 250;

  void dormir() async {
    if (durmiendo) return;

    durmiendo = true;
    estadoSleep = dormida;
    size = 450;
    

    for (double i = 0; i <= 0.7; i += 0.1) {
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      setState(() {
        oscuridad = i;
      });
    }

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted || widget.pet.energia >= 100) {
        durmiendo = false;
         estadoSleep = despierta;
         size = 250;
        return false;
      }

      setState(() {
        widget.pet.energia += 2;
      });

      widget.pet.save();

      return true;
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
            "assets/images/sleep.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopStatusBar(pet: widget.pet,userId: widget.userId,),
          ),

          Center(child: Image.asset( estadoSleep , width: size)),

          Positioned.fill(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              color:Colors.black.withValues(alpha: oscuridad),
            ),
          ),

          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton( 
                onPressed: dormir,
                child: const Text("Dormir"),
              ),
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: bottomMenu(widget.controller, 3),
          ),
        ],
      ),
    );
  }
}
