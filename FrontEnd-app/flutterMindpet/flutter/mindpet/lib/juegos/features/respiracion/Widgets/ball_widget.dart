import 'package:flutter/material.dart';

class BallWidget extends StatelessWidget {
  final double top;
  final double size;

  const BallWidget({
    super.key,
    required this.top,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/juegos/images/ejercicio2/pelota.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}