import 'package:flutter/material.dart';
import '../services/progress_service.dart';
import '../services/theme_catalog.dart';
import '../widgets/neon_panel.dart';

class ThemesScreen extends StatelessWidget {
  final ProgressService progress;
  const ThemesScreen({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (_, __) => Scaffold(
        backgroundColor: Color(progress.selectedTheme.background),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Themes'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  '⚡ ${progress.coins}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
          children: [
            const Text(
              'Unlock visual cores with Bolts earned from clean runs and combos.',
              style: TextStyle(color: Color(0xFF8D93A7)),
            ),
            const SizedBox(height: 18),
            ...vyloThemes.map((theme) {
              final unlocked = progress.unlockedThemeIds.contains(theme.id);
              final selected = progress.selectedThemeId == theme.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeonPanel(
                  borderColor:
                      selected ? Color(theme.colors.first) : null,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 78,
                        height: 78,
                        child: GridView.count(
                          crossAxisCount: 2,
                          physics: const NeverScrollableScrollPhysics(),
                          children: theme.colors
                              .map((c) => Container(color: Color(c)))
                              .toList(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              selected
                                  ? 'ACTIVE'
                                  : unlocked
                                      ? 'UNLOCKED'
                                      : '${theme.cost} BOLTS',
                              style: TextStyle(
                                color: selected
                                    ? Color(theme.colors[3])
                                    : const Color(0xFF8D93A7),
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: selected
                            ? null
                            : () async {
                                if (unlocked) {
                                  await progress.selectTheme(theme.id);
                                } else {
                                  final ok = await progress.unlockTheme(theme);
                                  if (!ok && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Not enough Bolts yet.'),
                                      ),
                                    );
                                  }
                                }
                              },
                        child: Text(
                          selected
                              ? 'ACTIVE'
                              : unlocked
                                  ? 'USE'
                                  : 'UNLOCK',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
