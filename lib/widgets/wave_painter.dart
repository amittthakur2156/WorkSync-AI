import 'package:flutter/material.dart';
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // ---------- BLUE WAVE  ----------
    final bluePath = Path()
      ..moveTo(0, height * 0.60)
      ..quadraticBezierTo(width * 0.5, height * 0.20, width, height * 0.62)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final bluePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD6DFFB), Color(0xFF8FA8F0)],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(bluePath, bluePaint);

    // ---------- GREEN WAVE  ----------
    final greenPath = Path()
      ..moveTo(0, height * 0.62)
      ..quadraticBezierTo(width * 0.45, height * 1.05, width, height * 0.550)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    final greenPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color(0xFFCFF3E3), Color(0xFF7FE0C0)],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    canvas.drawPath(greenPath, greenPaint);
  }

  @override
  bool shouldRepaint(covariant WavePainter oldDelegate) => false;
}