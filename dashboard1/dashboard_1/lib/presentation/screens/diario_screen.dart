import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme_provider.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';

class DiarioScreen extends StatelessWidget {
  const DiarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: const Sidebar(),
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: "Diario",
              onToggleTheme: theme.toggleTheme,
              showBack: true,
            ),
            const Expanded(
              child: Center(child: Text("Pantalla Diario")),
            ),
          ],
        ),
      ),
    );
  }
}