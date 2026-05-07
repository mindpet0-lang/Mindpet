import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final VoidCallback onToggleTheme;
  final bool showBack;

  const Header({
    super.key,
    required this.title,
    required this.onToggleTheme,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // 🔙 o ☰
            if (showBack && Navigator.canPop(context))
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              )
            else
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () =>
                    Scaffold.of(context).openDrawer(),
              ),

            const SizedBox(width: 8),

            // 🧠 LOGO + NOMBRE
            Row(
              children: [
                Image.asset(
                  isDark
                      ? 'assets/images/logowhite.png'
                      : 'assets/images/logo.png',
                  height: 30,
                ),
                const SizedBox(width: 8),
                const Text(
                  "MindPet",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // 📄 TÍTULO DE LA PANTALLA
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
            ),

            // 🌙 SWITCH
            Switch(
              value: isDark,
              onChanged: (_) => onToggleTheme(),
            ),

            const SizedBox(width: 8),

            const Icon(Icons.notifications_none),
            const SizedBox(width: 8),

            const CircleAvatar(
              radius: 14,
              child: Icon(Icons.person, size: 16),
            ),
          ],
        ),
      ),
    );
  }
}