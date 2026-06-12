import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Stylized jester-cap mark for [BlindCard] jokers — vector-only, scales cleanly.
class JokerCardLogo extends StatelessWidget {
  const JokerCardLogo({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final s = size.clamp(16.0, 160.0);
    return SizedBox(
      width: s,
      height: s,
      child: const CustomPaint(painter: _JokerLogoPainter()),
    );
  }
}

class _JokerLogoPainter extends CustomPainter {
  const _JokerLogoPainter();

  static const _purple = Color(0xFF5E35B1);
  static const _purpleDeep = Color(0xFF311B92);
  static const _gold = Color(0xFFFFD54F);
  static const _goldDark = Color(0xFFFFA000);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w * 0.5;
    final scale = math.min(w, h);

    void bell(Offset c, double r) {
      final g = Paint()
        ..shader = const RadialGradient(
          colors: [_gold, _goldDark],
          stops: [0.35, 1.0],
        ).createShader(Rect.fromCircle(center: c, radius: r));
      canvas.drawCircle(c, r, g);
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = scale * 0.02
          ..color = _purpleDeep.withValues(alpha: 0.6),
      );
    }

    final hatPath = Path()
      ..moveTo(cx - scale * 0.42, scale * 0.72)
      ..quadraticBezierTo(
        cx - scale * 0.5,
        scale * 0.38,
        cx - scale * 0.22,
        scale * 0.18,
      )
      ..quadraticBezierTo(cx, scale * 0.02, cx + scale * 0.22, scale * 0.18)
      ..quadraticBezierTo(
        cx + scale * 0.5,
        scale * 0.38,
        cx + scale * 0.42,
        scale * 0.72,
      )
      ..close();

    final hatPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_purple, _purpleDeep],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawPath(hatPath, hatPaint);
    canvas.drawPath(
      hatPath,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 0.025
        ..color = _gold.withValues(alpha: 0.85),
    );

    bell(Offset(cx - scale * 0.34, scale * 0.22), scale * 0.08);
    bell(Offset(cx + scale * 0.34, scale * 0.22), scale * 0.08);

    final band = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cx, scale * 0.62),
        width: scale * 0.72,
        height: scale * 0.12,
      ),
      Radius.circular(scale * 0.03),
    );
    canvas.drawRRect(
      band,
      Paint()..color = _gold,
    );
    canvas.drawRRect(
      band,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 0.02
        ..color = _purpleDeep,
    );

    final diamond = Path()
      ..moveTo(cx, scale * 0.34)
      ..lineTo(cx + scale * 0.1, scale * 0.48)
      ..lineTo(cx, scale * 0.62)
      ..lineTo(cx - scale * 0.1, scale * 0.48)
      ..close();
    canvas.drawPath(diamond, Paint()..color = Colors.white.withValues(alpha: 0.95));
    canvas.drawPath(
      diamond,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = scale * 0.018
        ..color = _purpleDeep,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
