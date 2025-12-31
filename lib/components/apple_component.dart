import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// Flame component representing an apple on the game grid
class AppleComponent extends PositionComponent {
  final int value;
  final int row;
  final int col;
  final Vector2 cellSize;

  bool isCollected = false;
  bool isSelected = false;
  bool isValidSelection = false;

  AppleComponent({
    required this.value,
    required this.row,
    required this.col,
    required this.cellSize,
  }) : super(size: cellSize);

  /// Mark this apple as collected
  void collect() {
    isCollected = true;
  }

  @override
  void render(Canvas canvas) {
    if (isCollected) return;

    _drawCellBackground(canvas);
    _drawCellBorder(canvas);
    _drawSelectionHighlight(canvas);
    _drawApple(canvas);
  }

  void _drawCellBackground(Canvas canvas) {
    final cellPaint = Paint()..color = GameColors.primaryLighter;
    canvas.drawRect(size.toRect(), cellPaint);
  }

  void _drawCellBorder(Canvas canvas) {
    final borderPaint = Paint()
      ..color = GameColors.primaryBorder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRect(size.toRect(), borderPaint);
  }

  void _drawSelectionHighlight(Canvas canvas) {
    if (!isSelected) return;

    final highlightColor = isValidSelection
        ? GameColors.selectionValid
        : GameColors.selectionHighlight;
    final highlightPaint = Paint()
      ..color = highlightColor.withValues(alpha: 0.3);
    canvas.drawRect(size.toRect(), highlightPaint);
  }

  void _drawApple(Canvas canvas) {
    final appleRadius = min(size.x, size.y) * 0.35;
    final center = Offset(size.x / 2, size.y / 2);

    _drawAppleShadow(canvas, center, appleRadius);
    _drawAppleBody(canvas, center, appleRadius);
    _drawAppleStem(canvas, center, appleRadius);
    _drawAppleLeaf(canvas, center, appleRadius);
    _drawAppleNumber(canvas, center, appleRadius);
  }

  void _drawAppleShadow(Canvas canvas, Offset center, double radius) {
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(center + const Offset(2, 2), radius, shadowPaint);
  }

  void _drawAppleBody(Canvas canvas, Offset center, double radius) {
    final applePaint = Paint()
      ..shader = RadialGradient(
        colors: [GameColors.appleLight, GameColors.appleDark],
        center: const Alignment(-0.3, -0.3),
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, applePaint);
  }

  void _drawAppleStem(Canvas canvas, Offset center, double radius) {
    final stemPaint = Paint()
      ..color = GameColors.appleStem
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx, center.dy - radius + 2),
      Offset(center.dx, center.dy - radius - 5),
      stemPaint,
    );
  }

  void _drawAppleLeaf(Canvas canvas, Offset center, double radius) {
    final leafPaint = Paint()..color = GameColors.appleLeaf;
    final leafPath = Path()
      ..moveTo(center.dx + 2, center.dy - radius - 2)
      ..quadraticBezierTo(
        center.dx + 10,
        center.dy - radius - 8,
        center.dx + 8,
        center.dy - radius + 2,
      )
      ..close();
    canvas.drawPath(leafPath, leafPaint);
  }

  void _drawAppleNumber(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
          shadows: const [
            Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }
}
