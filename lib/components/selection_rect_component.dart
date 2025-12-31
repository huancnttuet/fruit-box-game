import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../constants/game_constants.dart';

/// Flame component for the selection rectangle overlay
class SelectionRectComponent extends PositionComponent {
  final bool isValid;
  final int sum;

  SelectionRectComponent({
    required Vector2 position,
    required Vector2 size,
    required this.isValid,
    required this.sum,
  }) : super(position: position, size: size);

  @override
  void render(Canvas canvas) {
    _drawSelectionBorder(canvas);
    _drawSelectionFill(canvas);
    _drawSumLabel(canvas);
  }

  void _drawSelectionBorder(Canvas canvas) {
    final borderColor = isValid
        ? GameColors.selectionValid
        : GameColors.selectionInvalid;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRect(size.toRect(), borderPaint);
  }

  void _drawSelectionFill(Canvas canvas) {
    final fillColor = isValid
        ? GameColors.selectionValid
        : GameColors.selectionInvalid;
    final fillPaint = Paint()..color = fillColor.withValues(alpha: 0.1);
    canvas.drawRect(size.toRect(), fillPaint);
  }

  void _drawSumLabel(Canvas canvas) {
    final labelColor = isValid
        ? GameColors.sumLabelValid
        : GameColors.sumLabelInvalid;
    final labelPaint = Paint()..color = labelColor;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 70, 24), labelPaint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Sum: $sum',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(6, 4));
  }
}
