import 'package:flutter/material.dart';

import '../screens/dashboard_screen.dart';
import '../screens/diario_screen.dart';
import '../screens/juegos_screen.dart';
import '../screens/respiracion_screen.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void go(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(height: 40),

          ListTile(
            title: const Text("Inicio"),
            onTap: () => go(context, const DashboardScreen()),
          ),
          ListTile(
            title: const Text("Diario"),
            onTap: () => go(context, const DiarioScreen()),
          ),
          ListTile(
            title: const Text("Chat"),
            onTap: () => go(context, const JuegosScreen()),
          ),
          ListTile(
            title: const Text("Respiración"),
            onTap: () => go(context, const RespiracionScreen()),
          ),
        ],
      ),
    );
  }
}