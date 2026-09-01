import 'package:flutter/material.dart';
import '../models/achievement.dart';
import '../services/progress_service.dart';
import '../widgets/neon_panel.dart';

class AchievementsScreen extends StatelessWidget {
  final ProgressService progress;
  const AchievementsScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) => Scaffold(
        backgroundColor: Color(progress.selectedTheme.background),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Achievements'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: achievements.map((achievement) {
            final current = progress.progressFor(achievement);
            final unlocked =
                progress.unlockedAchievements.contains(achievement.id);
            final shown = current > achievement.target
                ? achievement.target
                : current;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NeonPanel(
                borderColor:
                    unlocked ? const Color(0xFFB8FF39) : null,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: unlocked
                          ? const Color(0xFFB8FF39)
                              .withValues(alpha: .13)
                          : Colors.white.withValues(alpha: .05),
                      child: Icon(
                        unlocked
                            ? Icons.emoji_events_rounded
                            : Icons.lock_outline_rounded,
                        color: unlocked
                            ? const Color(0xFFB8FF39)
                            : const Color(0xFF697087),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            achievement.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            achievement.description,
                            style: const TextStyle(
                              color: Color(0xFF8D93A7),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: achievement.target == 0
                                ? 0
                                : shown / achievement.target,
                            minHeight: 4,
                            borderRadius: BorderRadius.circular(99),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '$shown/${achievement.target}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
