import 'package:flutter/material.dart';
import '../models/game_models.dart';
import '../services/progress_service.dart';
import '../widgets/neon_panel.dart';
import 'game_screen.dart';
import 'themes_screen.dart';
import 'achievements_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final ProgressService progress;
  const HomeScreen({super.key, required this.progress});

  void _play(BuildContext context, GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(progress: progress, mode: mode),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) {
        final theme = progress.selectedTheme;
        return Scaffold(
          backgroundColor: Color(theme.background),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 30),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VYLO',
                            style: TextStyle(
                              fontSize: 30,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'MATCH. SPIN. SURVIVE.',
                            style: TextStyle(
                              color: Color(0xFF8D93A7),
                              fontSize: 9,
                              letterSpacing: 1.8,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _CoinBadge(coins: progress.coins),
                  ],
                ),
                const SizedBox(height: 26),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: LinearGradient(
                      colors: theme.colors
                          .take(3)
                          .map((value) => Color(value).withValues(alpha: .82))
                          .toList(),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(theme.colors.first).withValues(alpha: .25),
                        blurRadius: 34,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CLASSIC RUN',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Rotate the core.\nMatch every incoming color.',
                        style: TextStyle(
                          fontSize: 28,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          FilledButton.icon(
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () => _play(context, GameMode.classic),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('PLAY'),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'BEST ${progress.classicBest}',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _ModeCard(
                        title: 'ENDLESS',
                        subtitle: 'One miss ends the run.',
                        icon: Icons.all_inclusive_rounded,
                        best: progress.endlessBest,
                        onTap: () => _play(context, GameMode.endless),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ModeCard(
                        title: 'DAILY',
                        subtitle: 'Same pattern for everyone today.',
                        icon: Icons.today_rounded,
                        best: progress.dailyBest,
                        onTap: () => _play(context, GameMode.daily),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.55,
                  children: [
                    _NavCard(
                      icon: Icons.palette_outlined,
                      title: 'Themes',
                      subtitle: progress.selectedTheme.name,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ThemesScreen(progress: progress),
                        ),
                      ),
                    ),
                    _NavCard(
                      icon: Icons.emoji_events_outlined,
                      title: 'Achievements',
                      subtitle:
                          '${progress.unlockedAchievements.length} unlocked',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AchievementsScreen(progress: progress),
                        ),
                      ),
                    ),
                    _NavCard(
                      icon: Icons.query_stats_rounded,
                      title: 'Stats',
                      subtitle: '${progress.gamesPlayed} runs played',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => StatsScreen(progress: progress),
                        ),
                      ),
                    ),
                    _NavCard(
                      icon: Icons.tune_rounded,
                      title: 'Settings',
                      subtitle: 'Sound, haptics & data',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(progress: progress),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CoinBadge extends StatelessWidget {
  final int coins;
  const _CoinBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF101426),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        children: [
          const Icon(Icons.bolt_rounded, color: Color(0xFFB8FF39), size: 18),
          const SizedBox(width: 5),
          Text('$coins', style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final int best;
  final VoidCallback onTap;

  const _ModeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.best,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeonPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF00E7FF)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(color: Color(0xFF8D93A7), fontSize: 11),
            ),
            const SizedBox(height: 8),
            Text(
              'BEST $best',
              style: const TextStyle(
                color: Color(0xFFB8FF39),
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NeonPanel(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF9B5CFF)),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8D93A7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
