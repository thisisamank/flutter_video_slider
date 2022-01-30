import 'package:flutter/material.dart';
import 'package:video_slider/trim_slider_style.dart';

class TrimSliderPainter extends CustomPainter {
  TrimSliderPainter(
    this.rect,
    this.position, {
    required this.style,
  });

  final Rect rect;
  final double position;
  final TrimSliderStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final width = style.lineWidth;
    final halfWidth = width / 2;
    final linePaint = Paint()..strokeWidth = 4.0;
    final progressPaint = Paint()..strokeWidth = 2.0;
    final background = Paint()..color = Colors.grey.withOpacity(0.6);

    canvas.drawRect(
      Rect.fromPoints(
        Offset(position - halfWidth, 0.0),
        Offset(position + halfWidth, size.height),
      ),
      progressPaint,
    );

    //BACKGROUND LEFT
    canvas.drawRect(
      Rect.fromPoints(
        Offset.zero,
        rect.bottomLeft,
      ),
      background,
    );

    //BACKGROUND RIGHT
    canvas.drawRect(
      Rect.fromPoints(
        rect.topRight,
        Offset(size.width, size.height),
      ),
      background,
    );

    //TOP RECT
    canvas.drawRect(
      Rect.fromPoints(
        rect.topLeft,
        rect.topRight + Offset(0.0, width),
      ),
      linePaint,
    );

    //RIGHT RECT
    canvas.drawRect(
      Rect.fromPoints(
        rect.topRight - Offset(width, -width),
        rect.bottomRight,
      ),
      linePaint,
    );

    //BOTTOM RECT
    canvas.drawRect(
      Rect.fromPoints(
        rect.bottomRight - Offset(width, width),
        rect.bottomLeft,
      ),
      linePaint,
    );

    //LEFT RECT
    canvas.drawRect(
      Rect.fromPoints(
        rect.bottomLeft - Offset(-width, width),
        rect.topLeft,
      ),
      linePaint,
    );

    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.left,
        rect.top,
        rect.left + 20,
        rect.bottom,
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(8),
      ),
      Paint()..color = Colors.yellow,
    );

    //RIGHT CIRCLE
    canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rect.right,
        rect.top,
        rect.right + 20,
        rect.bottom,
        topRight: const Radius.circular(8),
        bottomRight: const Radius.circular(8),
      ),
      Paint()..color = Colors.yellow,
    );
  }

  @override
  bool shouldRepaint(TrimSliderPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TrimSliderPainter oldDelegate) => false;
}
