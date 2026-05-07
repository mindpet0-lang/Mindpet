import 'package:flutter/material.dart';

class WeeklyTracker extends StatelessWidget {
  const WeeklyTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ["L", "M", "M", "J", "V", "S", "D"];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          return Column(
            children: [
              Text(day),
              const SizedBox(height: 8),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}