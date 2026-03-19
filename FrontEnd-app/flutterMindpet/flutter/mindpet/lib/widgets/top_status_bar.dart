import 'package:flutter/material.dart';
import '../models/pet.dart';

class TopStatusBar extends StatelessWidget {

  final Pet pet;

  const TopStatusBar({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      color: Colors.black54,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [

          status(Icons.sentiment_satisfied, pet.felicidad),
          status(Icons.flash_on, pet.energia),
          status(Icons.restaurant, 100 - pet.hambre),
          status(Icons.clean_hands, pet.higiene),

        ],
      ),
    );
  }

  Widget status(IconData icon, int value) {

    return Column(
      children: [

        Icon(icon, color: Colors.white),

        const SizedBox(height: 4),

        Container(
          width: 50,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value / 100,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        )

      ],
    );
  }
}