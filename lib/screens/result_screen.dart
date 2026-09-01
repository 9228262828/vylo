import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../models/game_models.dart';
import '../services/progress_service.dart';
import '../widgets/neon_panel.dart';
import 'game_screen.dart';

class ResultScreen extends StatelessWidget {
  final ProgressService progress;
  final RunSummary summary;
  final List<Achievement> newlyUnlocked;

  const ResultScreen({
    super.key,
    required this.progress,
    required this.summary,
    required this.newlyUnlocked,
  });

  String get modeName {
    switch (summary.mode) {
      case GameMode.classic:
        return 'Classic';
      case GameMode.endless:
        return 'Endless';
      case GameMode.daily:
        return 'Daily';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBest = summary.score >= progress.bestFor(summary.mode) &&
        summary.score > 0;
    return Scaffold(
      backgroundColor: Color(progress.selectedTheme.background),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          children: [
            Text(
              isBest ? 'NEW BEST' : 'RUN COMPLETE',
              style: TextStyle(
                color: isBest
                    ? Color(progress.selectedTheme.colors[3])
                    : const Color(0xFF8D93A7),
                letterSpacing: 2.3,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${summary.score}',
              style: const TextStyle(
                fontSize: 82,
                height: .95,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '$modeName score',
              style: const TextStyle(
                color: Color(0xFF8D93A7),
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 24),
            NeonPanel(
              child: Row(
                children: [
                  _Stat(label: 'BEST COMBO', value: 'x${summary.bestCombo}'),
                  _Stat(label: 'PERFECTS', value: '${summary.perfects}'),
                  _Stat(label: 'BOLTS', value: '+${summary.coinsEarned}'),
                ],
              ),
            ),
            if (newlyUnlocked.isNotEmpty) ...[
              const SizedBox(height: 18),
              NeonPanel(
                borderColor: const Color(0xFFB8FF39),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ACHIEVEMENT UNLOCKED',
                      style: TextStyle(
                        color: Color(0xFFB8FF39),
                        fontSize: 10,
                        letterSpacing: 1.7,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...newlyUnlocked.map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '${a.title} — ${a.description}',
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      GameScreen(progress: progress, mode: summary.mode),
                ),
              ),
              icon: const Icon(Icons.replay_rounded),
              label: const Text('PLAY AGAIN'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BACK TO HOME'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF747B90),
              fontSize: 8,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
