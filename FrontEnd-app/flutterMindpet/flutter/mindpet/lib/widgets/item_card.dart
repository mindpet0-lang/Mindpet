import 'package:flutter/material.dart';
import '../models/item.dart';
import '../theme/colors.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final Function onBuy;

  const ItemCard({super.key, required this.item, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onBuy(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(item.imagen, height: 60),
            const SizedBox(height: 8),
            Text(
              item.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.favorite, size: 14),
                  Text(" ${item.precio}")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}