import 'package:flutter/material.dart';

class EmotionLineChart extends StatelessWidget {
  const EmotionLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text("Estado emocional"),
          Spacer(),
          Center(child: Text("Gráfica emocional")),
        ],
      ),
    );
  }
}