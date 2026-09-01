enum GameMode { classic, endless, daily }

enum RunState { ready, playing, paused, gameOver }

class VyloTheme {
  final String id;
  final String name;
  final int cost;
  final List<int> colors;
  final int background;
  final int panel;

  const VyloTheme({
    required this.id,
    required this.name,
    required this.cost,
    required this.colors,
    required this.background,
    required this.panel,
  });
}

class GameOrb {
  final int id;
  final int lane;
  final int colorIndex;
  double progress;
  final bool bonus;

  GameOrb({
    required this.id,
    required this.lane,
    required this.colorIndex,
    required this.progress,
    this.bonus = false,
  });
}

class RunSummary {
  final GameMode mode;
  final int score;
  final int bestCombo;
  final int coinsEarned;
  final double durationSeconds;
  final int perfects;

  const RunSummary({
    required this.mode,
    required this.score,
    required this.bestCombo,
    required this.coinsEarned,
    required this.durationSeconds,
    required this.perfects,
  });
}
