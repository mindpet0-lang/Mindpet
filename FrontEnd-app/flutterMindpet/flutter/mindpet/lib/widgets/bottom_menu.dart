import 'package:flutter/material.dart';

Widget bottomMenu(PageController controller, int currentPage) {

  Widget buildIcon(IconData icon, int page) {

    bool activo = currentPage == page;

    return GestureDetector(
      onTap: () {
        controller.animateToPage(
          page,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: activo
              ? const Color.fromARGB(255, 81, 196, 255)
              : Colors.transparent,
        ),

        child: AnimatedScale(
          scale: activo ? 1.3 : 1.0,
          duration: const Duration(milliseconds: 300),

          child: Icon(
            icon,
            size: 35,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [

      buildIcon(Icons.home, 0),
      buildIcon(Icons.shower, 1),
      buildIcon(Icons.fastfood, 2),
      buildIcon(Icons.nightlight_round, 3),
      buildIcon(Icons.sports_esports, 4),

    ],
  );
}