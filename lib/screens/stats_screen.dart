import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../widgets/neon_panel.dart';

class StatsScreen extends StatelessWidget {
  final ProgressService progress;
  const StatsScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) => Scaffold(
        backgroundColor: Color(progress.selectedTheme.background),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Stats'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 30),
          children: [
            NeonPanel(
              child: Column(
                children: [
                  _row('Classic best', '${progress.classicBest}'),
                  _row('Endless best', '${progress.endlessBest}'),
                  _row('Daily best', '${progress.dailyBest}'),
                  _row('Best combo', 'x${progress.bestCombo}'),
                  _row('Perfect matches', '${progress.totalPerfects}'),
                  _row('Runs played', '${progress.gamesPlayed}'),
                  _row('Bolts available', '${progress.coins}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Color(0xFF8D93A7)),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      );
}
