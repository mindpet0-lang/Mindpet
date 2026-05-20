import 'package:flutter/material.dart';

class BallService {
  late AnimationController controller;
  late Animation<double> animation;

  void init({
    required TickerProvider vsync,
    required double startY,
    required double endY,
  }) {
    controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 4),
    );

    animation = Tween<double>(
      begin: startY,
      end: endY,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }

  Future<void> startLoop() async {
    while (controller.isAnimating || controller.status != AnimationStatus.dismissed) {
      await controller.forward();

      await Future.delayed(
        const Duration(seconds: 2),
      );

      await controller.reverse();

      await Future.delayed(
        const Duration(seconds: 2),
      );
    }
  }

  void dispose() {
    controller.dispose();
  }
}