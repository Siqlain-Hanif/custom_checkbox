import 'package:flutter/material.dart';

class RadialReactionPainter extends CustomPainter {
  bool? _isHovered;
  bool get isHovered => _isHovered!;
  set isHovered(bool? value) {
    if (value == _isHovered) {
      return;
    }
    _isHovered = value;
  }

  Offset? _downPosition;
  Offset? get downPosition => _downPosition;
  set downPosition(Offset? value) {
    if (value == _downPosition) {
      return;
    }
    _downPosition = value;
  }

  double? _splashRadius;
  double get splashRadius => _splashRadius!;
  set splashRadius(double? value) {
    if (value == _splashRadius) {
      return;
    }
    _splashRadius = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center =
        Offset.lerp(downPosition, size.center(Offset.zero), 1.0)!;
    if (!isHovered) return;

    var radialReactionPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, splashRadius, radialReactionPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
