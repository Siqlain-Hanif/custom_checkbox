import 'package:flutter/material.dart';

class RadialReactionPainter extends CustomPainter {
  bool get isHovered => _isHovered!;
  bool? _isHovered;
  set isHovered(bool? value) {
    if (value == _isHovered) {
      return;
    }
    _isHovered = value;
  }

  Offset? get downPosition => _downPosition;
  Offset? _downPosition;
  set downPosition(Offset? value) {
    if (value == _downPosition) {
      return;
    }
    _downPosition = value;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center =
        Offset.lerp(downPosition, size.center(Offset.zero), 1.0)!;
    if (!isHovered) return;

    var radialReactionPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, kRadialReactionRadius + 15, radialReactionPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
