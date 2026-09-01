import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import '../game/game_engine.dart';
import '../game/game_painter.dart';
import '../models/achievement.dart';
import '../models/game_models.dart';
import '../services/progress_service.dart';
import 'result_screen.dart';

class GameScreen extends StatefulWidget {
  final ProgressService progress;
  final GameMode mode;

  const GameScreen({
    super.key,
    required this.progress,
    required this.mode,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late final GameEngine engine;
  late final Ticker ticker;
  Duration? lastTick;
  bool submitting = false;

  @override
  void initState() {
    super.initState();
    engine = GameEngine(widget.mode)..start();
    ticker = createTicker(_tick)..start();
  }

  void _tick(Duration elapsed) {
    if (!mounted) return;
    final previous = lastTick;
    lastTick = elapsed;
    if (previous == null) return;

    final dt = (elapsed - previous).inMicroseconds / 1000000.0;
    final beforeScore = engine.score;
    final beforeLives = engine.lives;

    engine.update(dt);

    if (engine.score != beforeScore) {
      _feedback(success: true);
    } else if (engine.lives != beforeLives) {
      _feedback(success: false);
    }

    if (engine.state == RunState.gameOver && !submitting) {
      submitting = true;
      ticker.stop();
      _finish();
      return;
    }

    setState(() {});
  }

  Future<void> _feedback({required bool success}) async {
    if (widget.progress.hapticsEnabled) {
      if (success) {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.mediumImpact();
      }
    }
    if (widget.progress.soundEnabled) {
      await SystemSound.play(SystemSoundType.click);
    }
  }

  Future<void> _finish() async {
    final summary = engine.summary();
    final List<Achievement> unlocked =
        await widget.progress.recordRun(summary);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          progress: widget.progress,
          summary: summary,
          newlyUnlocked: unlocked,
        ),
      ),
    );
  }

  void _rotateLeft() {
    engine.rotateLeft();
    if (widget.progress.hapticsEnabled) HapticFeedback.selectionClick();
    setState(() {});
  }

  void _rotateRight() {
    engine.rotateRight();
    if (widget.progress.hapticsEnabled) HapticFeedback.selectionClick();
    setState(() {});
  }

  @override
  void dispose() {
    ticker.dispose();
    super.dispose();
  }

  String get modeTitle {
    switch (widget.mode) {
      case GameMode.classic:
        return 'CLASSIC';
      case GameMode.endless:
        return 'ENDLESS';
      case GameMode.daily:
        return 'DAILY';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.progress.selectedTheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        engine.togglePause();
        setState(() {});
        final leave = await showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Leave this run?'),
                content: const Text('Your current run will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Stay'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Leave'),
                  ),
                ],
              ),
            ) ??
            false;
        if (!mounted) return;
        if (leave) {
          ticker.stop();
          Navigator.pop(context);
        } else {
          engine.togglePause();
          lastTick = null;
          setState(() {});
        }
      },
      child: Scaffold(
        backgroundColor: Color(theme.background),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        engine.togglePause();
                        setState(() {});
                        final leave = await showDialog<bool>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Leave this run?'),
                                content: const Text('Your current run will be lost.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Stay'),
                                  ),
                                  FilledButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Leave'),
                                  ),
                                ],
                              ),
                            ) ??
                            false;
                        if (!mounted) return;
                        if (leave) {
                          ticker.stop();
                          Navigator.pop(context);
                        } else {
                          engine.togglePause();
                          lastTick = null;
                          setState(() {});
                        }
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const Spacer(),
                    Text(
                      modeTitle,
                      style: const TextStyle(
                        letterSpacing: 2,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF8D93A7),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        engine.togglePause();
                        lastTick = null;
                        setState(() {});
                      },
                      icon: Icon(
                        engine.state == RunState.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _Hud(label: 'SCORE', value: '${engine.score}'),
                    _Hud(label: 'COMBO', value: 'x${engine.combo}'),
                    _Hud(
                      label: 'LIVES',
                      value: widget.mode == GameMode.endless
                          ? '1 HIT'
                          : '${engine.lives}',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: VyloGamePainter(
                          engine: engine,
                          theme: theme,
                        ),
                      ),
                    ),
                    if (engine.combo >= 5)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 20,
                        child: Center(
                          child: Text(
                            engine.combo >= 20
                                ? 'UNREAL x${engine.combo}'
                                : engine.combo >= 10
                                    ? 'ON FIRE x${engine.combo}'
                                    : 'COMBO x${engine.combo}',
                            style: TextStyle(
                              color: Color(theme.colors[3]),
                              fontSize: 15,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    if (engine.state == RunState.paused)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withValues(alpha: .72),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'PAUSED',
                                  style: TextStyle(
                                    fontSize: 32,
                                    letterSpacing: 4,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                FilledButton.icon(
                                  onPressed: () {
                                    engine.togglePause();
                                    lastTick = null;
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.play_arrow_rounded),
                                  label: const Text('RESUME'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: _ControlButton(
                        icon: Icons.rotate_left_rounded,
                        label: 'LEFT',
                        onTap: _rotateLeft,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ControlButton(
                        icon: Icons.rotate_right_rounded,
                        label: 'RIGHT',
                        onTap: _rotateRight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  final String label;
  final String value;

  const _Hud({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666D84),
              fontSize: 9,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF151A31),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(19),
            side: BorderSide(color: Colors.white.withValues(alpha: .08)),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 26),
        label: Text(
          label,
          style: const TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
