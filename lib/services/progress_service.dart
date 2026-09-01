import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_models.dart';
import '../models/achievement.dart';
import 'theme_catalog.dart';

class ProgressService extends ChangeNotifier {
  static const _key = 'vylo_progress_v1';

  bool ready = false;

  int coins = 0;
  int gamesPlayed = 0;
  int totalPerfects = 0;
  int bestCombo = 0;
  int classicBest = 0;
  int endlessBest = 0;
  int dailyBest = 0;

  bool soundEnabled = true;
  bool hapticsEnabled = true;

  String selectedThemeId = 'neon_core';
  final Set<String> unlockedThemeIds = {'neon_core'};
  final Set<String> unlockedAchievements = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw != null) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        coins = data['coins'] as int? ?? 0;
        gamesPlayed = data['gamesPlayed'] as int? ?? 0;
        totalPerfects = data['totalPerfects'] as int? ?? 0;
        bestCombo = data['bestCombo'] as int? ?? 0;
        classicBest = data['classicBest'] as int? ?? 0;
        endlessBest = data['endlessBest'] as int? ?? 0;
        dailyBest = data['dailyBest'] as int? ?? 0;
        soundEnabled = data['soundEnabled'] as bool? ?? true;
        hapticsEnabled = data['hapticsEnabled'] as bool? ?? true;
        selectedThemeId = data['selectedThemeId'] as String? ?? 'neon_core';
        unlockedThemeIds
          ..clear()
          ..addAll((data['unlockedThemeIds'] as List? ?? const ['neon_core']).cast<String>());
        unlockedThemeIds.add('neon_core');
        unlockedAchievements
          ..clear()
          ..addAll((data['unlockedAchievements'] as List? ?? const []).cast<String>());
      } catch (_) {
        // Keep safe defaults if old/corrupt local data cannot be decoded.
      }
    }
    ready = true;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode({
      'coins': coins,
      'gamesPlayed': gamesPlayed,
      'totalPerfects': totalPerfects,
      'bestCombo': bestCombo,
      'classicBest': classicBest,
      'endlessBest': endlessBest,
      'dailyBest': dailyBest,
      'soundEnabled': soundEnabled,
      'hapticsEnabled': hapticsEnabled,
      'selectedThemeId': selectedThemeId,
      'unlockedThemeIds': unlockedThemeIds.toList(),
      'unlockedAchievements': unlockedAchievements.toList(),
    }));
  }

  VyloTheme get selectedTheme => vyloThemes.firstWhere(
    (theme) => theme.id == selectedThemeId,
    orElse: () => vyloThemes.first,
  );

  int bestFor(GameMode mode) {
    switch (mode) {
      case GameMode.classic:
        return classicBest;
      case GameMode.endless:
        return endlessBest;
      case GameMode.daily:
        return dailyBest;
    }
  }

  int progressFor(Achievement achievement) {
    switch (achievement.metric) {
      case 'best_score':
        return [classicBest, endlessBest, dailyBest].reduce((a, b) => a > b ? a : b);
      case 'best_combo':
        return bestCombo;
      case 'games':
        return gamesPlayed;
      case 'perfects':
        return totalPerfects;
      default:
        return 0;
    }
  }

  Future<List<Achievement>> recordRun(RunSummary run) async {
    gamesPlayed += 1;
    totalPerfects += run.perfects;
    coins += run.coinsEarned;

    if (run.bestCombo > bestCombo) bestCombo = run.bestCombo;

    switch (run.mode) {
      case GameMode.classic:
        if (run.score > classicBest) classicBest = run.score;
        break;
      case GameMode.endless:
        if (run.score > endlessBest) endlessBest = run.score;
        break;
      case GameMode.daily:
        if (run.score > dailyBest) dailyBest = run.score;
        break;
    }

    final newlyUnlocked = <Achievement>[];
    for (final achievement in achievements) {
      if (!unlockedAchievements.contains(achievement.id) &&
          progressFor(achievement) >= achievement.target) {
        unlockedAchievements.add(achievement.id);
        newlyUnlocked.add(achievement);
      }
    }

    notifyListeners();
    await _save();
    return newlyUnlocked;
  }

  Future<bool> unlockTheme(VyloTheme theme) async {
    if (unlockedThemeIds.contains(theme.id)) return true;
    if (coins < theme.cost) return false;
    coins -= theme.cost;
    unlockedThemeIds.add(theme.id);
    selectedThemeId = theme.id;
    notifyListeners();
    await _save();
    return true;
  }

  Future<void> selectTheme(String id) async {
    if (!unlockedThemeIds.contains(id)) return;
    selectedThemeId = id;
    notifyListeners();
    await _save();
  }

  Future<void> setSound(bool value) async {
    soundEnabled = value;
    notifyListeners();
    await _save();
  }

  Future<void> setHaptics(bool value) async {
    hapticsEnabled = value;
    notifyListeners();
    await _save();
  }

  Future<void> resetProgress() async {
    coins = 0;
    gamesPlayed = 0;
    totalPerfects = 0;
    bestCombo = 0;
    classicBest = 0;
    endlessBest = 0;
    dailyBest = 0;
    selectedThemeId = 'neon_core';
    unlockedThemeIds
      ..clear()
      ..add('neon_core');
    unlockedAchievements.clear();
    notifyListeners();
    await _save();
  }
}
