import 'package:flutter/material.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_hand_labels.dart';

/// Compact playing-card tile: rank + suit at top-left only.
class SniperCardWidget extends StatelessWidget {
  const SniperCardWidget({
    required this.extent,
    this.card,
    this.faceDown = false,
    super.key,
  });

  final double extent;
  final SniperCard? card;
  final bool faceDown;

  @override
  Widget build(BuildContext context) {
    final width = extent * 0.62;
    final height = extent * 0.88;
    final radius = extent * 0.07;
    final border = extent * 0.01;

    if (faceDown || card == null) {
      return _CardShell(
        width: width,
        height: height,
        radius: radius,
        border: border,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius * 0.85),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF4C1D95), Color(0xFF1E1B4B)],
            ),
          ),
          child: Center(
            child: Text(
              '?',
              style: TextStyle(
                fontSize: extent * 0.32,
                fontWeight: FontWeight.w800,
                color: AppTheme.neoGold.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
      );
    }

    final c = card!;
    final suitColor = SniperSuitStyle.ink(c.suit);
    final cornerSize = extent * 0.28;

    return _CardShell(
      width: width,
      height: height,
      radius: radius,
      border: border,
      child: Padding(
        padding: EdgeInsets.all(extent * 0.06),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            '${c.value}${SniperSuitStyle.glyph(c.suit)}',
            style: TextStyle(
              fontSize: cornerSize,
              fontWeight: FontWeight.w800,
              color: suitColor,
              height: 1.05,
            ),
          ),
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({
    required this.width,
    required this.height,
    required this.radius,
    required this.border,
    required this.child,
  });

  final double width;
  final double height;
  final double radius;
  final double border;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppTheme.neoTextMuted.withValues(alpha: 0.35),
          width: border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: height * 0.05,
            offset: Offset(0, height * 0.03),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius * 0.92),
        child: child,
      ),
    );
  }
}

/// Empty community slot before river cards are dealt.
class SniperEmptyCardSlot extends StatelessWidget {
  const SniperEmptyCardSlot({required this.extent, super.key});

  final double extent;

  @override
  Widget build(BuildContext context) {
    final width = extent * 0.62;
    final height = extent * 0.88;
    final radius = extent * 0.07;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: AppTheme.neoTextMuted.withValues(alpha: 0.25),
          width: extent * 0.01,
        ),
      ),
    );
  }
}
