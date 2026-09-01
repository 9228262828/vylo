import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game_models.dart';
import 'game_engine.dart';

class VyloGamePainter extends CustomPainter {
  final GameEngine engine;
  final VyloTheme theme;

  VyloGamePainter({
    required this.engine,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colors = theme.colors.map(Color.new).toList();
    final center = Offset(size.width / 2, size.height / 2);
    final minSide = min(size.width, size.height);
    final vaultRadius = minSide * 0.165;
    final spawnRadius = minSide * 0.47;

    final grid = Paint()
      ..color = Colors.white.withValues(alpha: .035)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withValues(alpha: .09);
    canvas.drawCircle(center, vaultRadius * 1.55, ringPaint);
    canvas.drawCircle(center, vaultRadius * 2.25, ringPaint);

    final sectorRect = Rect.fromCircle(center: center, radius: vaultRadius);
    for (int lane = 0; lane < 4; lane++) {
      final colorIndex = engine.sectorColorAtLane(lane);
      final paint = Paint()
        ..color = colors[colorIndex]
        ..style = PaintingStyle.fill;
      final startAngle = -pi / 4 + lane * pi / 2;
      canvas.drawArc(sectorRect, startAngle, pi / 2, true, paint);
    }

    final core = Paint()..color = Color(theme.panel);
    canvas.drawCircle(center, vaultRadius * .48, core);

    final coreRing = Paint()
      ..color = Colors.white.withValues(alpha: .18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, vaultRadius * .48, coreRing);

    final pointerPaint = Paint()
      ..color = Colors.white.withValues(alpha: .8)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      center + Offset(0, -vaultRadius * .18),
      center + Offset(0, -vaultRadius * .34),
      pointerPaint,
    );

    for (final orb in engine.orbs) {
      final angle = -pi / 2 + orb.lane * pi / 2;
      final start = center + Offset(cos(angle), sin(angle)) * spawnRadius;
      final end = center + Offset(cos(angle), sin(angle)) * vaultRadius;
      final p = Offset.lerp(start, end, Curves.easeIn.transform(orb.progress.clamp(0, 1)))!;
      final radius = orb.bonus ? 17.0 : 14.0;

      final glow = Paint()
        ..color = colors[orb.colorIndex].withValues(alpha: .28)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);
      canvas.drawCircle(p, radius + 8, glow);

      final orbPaint = Paint()..color = colors[orb.colorIndex];
      canvas.drawCircle(p, radius, orbPaint);

      if (orb.bonus) {
        final bonusPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawCircle(p, radius - 5, bonusPaint);
      }
    }

    if (engine.flashSuccess) {
      final flash = Paint()
        ..color = const Color(0xFFB8FF39).withValues(alpha: .11);
      canvas.drawCircle(center, vaultRadius * 1.4, flash);
    }

    if (engine.flashFailure) {
      final flash = Paint()
        ..color = const Color(0xFFFF4D6D).withValues(alpha: .09);
      canvas.drawRect(Offset.zero & size, flash);
    }
  }

  @override
  bool shouldRepaint(covariant VyloGamePainter oldDelegate) => true;
}
