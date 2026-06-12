import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/match_and_void/models/match_card.dart';

/// High-contrast card tile with custom-painted shape, color, and fill.
class MatchCardWidget extends StatelessWidget {
  const MatchCardWidget({
    super.key,
    required this.card,
    this.isSelected = false,
    this.onTap,
    this.compact = false,
  });

  final MatchCard card;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final borderWidth = AdaptiveLayout.matchVoidSelectionBorder(context);
    final selectedScale = AdaptiveLayout.matchVoidSelectedScale(context);
    final radius = AdaptiveLayout.matchVoidCardRadius(context);

    Widget painted = LayoutBuilder(
      builder: (context, constraints) {
        final side = math.min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: side,
          height: side,
          child: CustomPaint(
            painter: _MatchCardPainter(
              shape: card.shape,
              color: card.color,
              fill: card.fill,
              strokeWidth: side * 0.07,
              stripeSpacing: side * 0.11,
              triangleInset: AdaptiveLayout.matchVoidTriangleViewportInset(
                context,
              ),
            ),
          ),
        );
      },
    );

    if (!compact) {
      painted = AspectRatio(aspectRatio: 1, child: painted);
    }

    final surface = Theme.of(context).colorScheme.surfaceContainerHigh;
    final child = AnimatedScale(
      scale: isSelected ? selectedScale : 1,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E5FF) : const Color(0xFF3D4A63),
            width: isSelected ? borderWidth * 1.35 : borderWidth * 0.65,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                    blurRadius: borderWidth * 4,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(compact ? borderWidth : borderWidth * 1.4),
          child: painted,
        ),
      ),
    );

    if (onTap == null) {
      return child;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius),
        child: child,
      ),
    );
  }
}

class _MatchCardPainter extends CustomPainter {
  _MatchCardPainter({
    required this.shape,
    required this.color,
    required this.fill,
    required this.strokeWidth,
    required this.stripeSpacing,
    required this.triangleInset,
  });

  final CardShape shape;
  final CardColor color;
  final CardFill fill;
  final double strokeWidth;
  final double stripeSpacing;
  final EdgeInsets triangleInset;

  static Color _cardColor(CardColor c) {
    switch (c) {
      case CardColor.red:
        return const Color(0xFFE53935);
      case CardColor.blue:
        return const Color(0xFF1E88E5);
      case CardColor.yellow:
        return const Color(0xFFFDD835);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paintColor = _cardColor(color);
    final inset = strokeWidth * 0.85;
    final rect = Rect.fromLTWH(
      inset,
      inset,
      size.width - inset * 2,
      size.height - inset * 2,
    );
    final path = _shapePath(shape, rect);

    switch (fill) {
      case CardFill.solid:
        canvas.drawPath(
          path,
          Paint()
            ..color = paintColor
            ..style = PaintingStyle.fill,
        );
      case CardFill.empty:
        canvas.drawPath(
          path,
          Paint()
            ..color = paintColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth
            ..strokeJoin = StrokeJoin.round,
        );
      case CardFill.striped:
        canvas.save();
        canvas.clipPath(path);
        canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0xFF121826)
            ..style = PaintingStyle.fill,
        );
        final stripePaint = Paint()
          ..color = paintColor
          ..strokeWidth = strokeWidth * 0.55
          ..style = PaintingStyle.stroke;
        final span = rect.width + rect.height;
        for (var t = -span; t < span * 2; t += stripeSpacing) {
          canvas.drawLine(
            Offset(rect.left + t, rect.top),
            Offset(rect.left + t + rect.height, rect.bottom),
            stripePaint,
          );
        }
        canvas.restore();
        canvas.drawPath(
          path,
          Paint()
            ..color = paintColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth * 0.65
            ..strokeJoin = StrokeJoin.round,
        );
    }
  }

  static Rect _insetRect(Rect rect, EdgeInsets inset) {
    final left = rect.left + inset.left;
    final top = rect.top + inset.top;
    final right = rect.right - inset.right;
    final bottom = rect.bottom - inset.bottom;
    if (right <= left || bottom <= top) {
      return rect;
    }
    return Rect.fromLTRB(left, top, right, bottom);
  }

  Path _shapePath(CardShape shape, Rect rect) {
    switch (shape) {
      case CardShape.circle:
        return Path()..addOval(rect);
      case CardShape.square:
        return Path()..addRect(rect);
      case CardShape.triangle:
        final inner = _insetRect(rect, triangleInset);
        final path = Path();
        path.moveTo(inner.center.dx, inner.top);
        path.lineTo(inner.right, inner.bottom);
        path.lineTo(inner.left, inner.bottom);
        path.close();
        return path;
    }
  }

  @override
  bool shouldRepaint(covariant _MatchCardPainter oldDelegate) {
    return shape != oldDelegate.shape ||
        color != oldDelegate.color ||
        fill != oldDelegate.fill ||
        strokeWidth != oldDelegate.strokeWidth ||
        stripeSpacing != oldDelegate.stripeSpacing ||
        triangleInset != oldDelegate.triangleInset;
  }
}
