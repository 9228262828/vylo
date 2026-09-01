import 'dart:math';
import '../models/game_models.dart';

class GameEngine {
  final GameMode mode;
  final Random _random;

  RunState state = RunState.ready;
  int rotation = 0;
  int score = 0;
  int combo = 0;
  int bestCombo = 0;
  int lives = 3;
  int perfects = 0;
  int coinsEarned = 0;

  double elapsed = 0;
  double _spawnClock = 0;
  int _nextId = 0;
  final List<GameOrb> orbs = [];

  bool flashSuccess = false;
  bool flashFailure = false;
  int lastMatchLane = -1;

  GameEngine(this.mode)
      : _random = mode == GameMode.daily
            ? Random(_seedForToday())
            : Random() {
    lives = mode == GameMode.endless ? 1 : 3;
  }

  static int _seedForToday() {
    final now = DateTime.now();
    return now.year * 10000 + now.month * 100 + now.day;
  }

  double get speed {
    final base = mode == GameMode.endless ? 0.25 : 0.22;
    return min(0.58, base + score * 0.0032);
  }

  double get spawnInterval {
    final base = mode == GameMode.endless ? 1.15 : 1.32;
    return max(0.62, base - score * 0.008);
  }

  void start() {
    state = RunState.playing;
    score = 0;
    combo = 0;
    bestCombo = 0;
    perfects = 0;
    coinsEarned = 0;
    elapsed = 0;
    rotation = 0;
    lives = mode == GameMode.endless ? 1 : 3;
    orbs.clear();
    _spawnClock = 0.45;
    _nextId = 0;
  }

  void togglePause() {
    if (state == RunState.playing) {
      state = RunState.paused;
    } else if (state == RunState.paused) {
      state = RunState.playing;
    }
  }

  void rotateLeft() {
    if (state != RunState.playing) return;
    rotation = (rotation + 3) % 4;
  }

  void rotateRight() {
    if (state != RunState.playing) return;
    rotation = (rotation + 1) % 4;
  }

  int sectorColorAtLane(int lane) {
    return (lane - rotation) % 4;
  }

  void update(double dt) {
    if (state != RunState.playing) return;
    final safeDt = dt.clamp(0.0, 0.05);
    elapsed += safeDt;
    flashSuccess = false;
    flashFailure = false;

    _spawnClock += safeDt;
    if (_spawnClock >= spawnInterval) {
      _spawnClock = 0;
      _spawn();
    }

    final resolved = <GameOrb>[];
    for (final orb in orbs) {
      orb.progress += speed * safeDt;
      if (orb.progress >= 1.0) {
        resolved.add(orb);
      }
    }

    for (final orb in resolved) {
      _resolve(orb);
      orbs.remove(orb);
      if (state == RunState.gameOver) break;
    }
  }

  void _spawn() {
    final lane = _random.nextInt(4);
    final color = _random.nextInt(4);
    final bonusChance = score > 15 && _random.nextDouble() < 0.08;
    orbs.add(GameOrb(
      id: _nextId++,
      lane: lane,
      colorIndex: color,
      progress: 0,
      bonus: bonusChance,
    ));
  }

  void _resolve(GameOrb orb) {
    final match = sectorColorAtLane(orb.lane) == orb.colorIndex;
    if (match) {
      combo += 1;
      if (combo > bestCombo) bestCombo = combo;
      score += orb.bonus ? 3 : 1;
      perfects += 1;
      lastMatchLane = orb.lane;
      flashSuccess = true;

      if (score % 5 == 0) coinsEarned += 1;
      if (combo > 0 && combo % 10 == 0) coinsEarned += 2;
    } else {
      combo = 0;
      lives -= 1;
      flashFailure = true;
      if (lives <= 0) {
        state = RunState.gameOver;
      }
    }
  }

  RunSummary summary() => RunSummary(
    mode: mode,
    score: score,
    bestCombo: bestCombo,
    coinsEarned: coinsEarned,
    durationSeconds: elapsed,
    perfects: perfects,
  );
}
