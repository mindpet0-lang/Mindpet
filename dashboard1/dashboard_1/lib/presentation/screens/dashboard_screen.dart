import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/theme_provider.dart';
import '../widgets/header.dart';
import '../widgets/sidebar.dart';
import '../widgets/emotion_line_chart.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/map_widget.dart';
import '../widgets/progress_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/weekly_tracker.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      drawer: const Sidebar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Header(
                title: "Dashboard",
                onToggleTheme: theme.toggleTheme,
              ),

              const SizedBox(height: 20),
              const EmotionLineChart(),
              const SizedBox(height: 20),
              const BarChartWidget(),
              const SizedBox(height: 20),
              const MapWidget(),
              const SizedBox(height: 20),
              const ProgressCard(),
              const SizedBox(height: 20),
              const WeeklyTracker(),
              const SizedBox(height: 20),
              const StatCard(title: "Entradas", value: "345"),
            ],
          ),
        ),
      ),
    );
  }
}