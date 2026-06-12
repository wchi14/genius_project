import 'package:flutter/material.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';

/// Single die for Blind Cup: Liar's dice — ivory casino die, blind die, or cup-backed hide.
class CupDieWidget extends StatelessWidget {
  const CupDieWidget({
    super.key,
    required this.die,
    required this.extent,
    this.revealBlind = false,
    this.forceHidden = false,
  });

  final DiceModel die;
  final double extent;

  /// When `true`, a blind die shows [DiceModel.faceValue] instead of "?".
  final bool revealBlind;

  /// Hides the face entirely (opponent cup before showdown).
  final bool forceHidden;

  bool get _showMystery =>
      forceHidden || (die.isBlind && !revealBlind);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = AdaptiveLayout.bluffCupDieRadius(context);

    if (_showMystery) {
      return _DieShell(
        extent: extent,
        radius: radius,
        faceColor: Colors.grey.shade900,
        borderColor: scheme.secondary.withValues(alpha: 0.55),
        borderWidth: extent * 0.03,
        shadowColor: Colors.black,
        child: Icon(
          forceHidden ? Icons.casino_outlined : Icons.visibility_off_outlined,
          color: scheme.secondary.withValues(alpha: 0.9),
          size: extent * 0.4,
        ),
      );
    }

    final ivory = Color.lerp(Colors.grey.shade100, Colors.amber.shade50, 0.35)!;
    return _DieShell(
      extent: extent,
      radius: radius,
      faceColor: ivory,
      borderColor: die.isBlind
          ? scheme.secondary
          : Colors.grey.shade700.withValues(alpha: 0.65),
      borderWidth: die.isBlind ? extent * 0.04 : extent * 0.022,
      shadowColor: Colors.black87,
      child: _DiePips(
        value: die.faceValue,
        extent: extent,
        pipColor: Colors.grey.shade900,
      ),
    );
  }
}

class _DieShell extends StatelessWidget {
  const _DieShell({
    required this.extent,
    required this.radius,
    required this.faceColor,
    required this.borderColor,
    required this.borderWidth,
    required this.shadowColor,
    required this.child,
  });

  final double extent;
  final double radius;
  final Color faceColor;
  final Color borderColor;
  final double borderWidth;
  final Color shadowColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: extent,
      height: extent,
      decoration: BoxDecoration(
        color: faceColor,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.5),
            blurRadius: extent * 0.1,
            offset: Offset(0, extent * 0.05),
          ),
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.12),
            blurRadius: extent * 0.04,
            offset: Offset(-extent * 0.02, -extent * 0.02),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

/// Standard pip layout for faces 1–6.
class _DiePips extends StatelessWidget {
  const _DiePips({
    required this.value,
    required this.extent,
    required this.pipColor,
  });

  final int value;
  final double extent;
  final Color pipColor;

  @override
  Widget build(BuildContext context) {
    final pip = extent * 0.13;
    final positions = _pipPositions(value);
    return SizedBox(
      width: extent * 0.72,
      height: extent * 0.72,
      child: Stack(
        children: [
          for (final alignment in positions)
            Align(
              alignment: alignment,
              child: Container(
                width: pip,
                height: pip,
                decoration: BoxDecoration(
                  color: pipColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: pip * 0.15,
                      offset: Offset(0, pip * 0.08),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static List<Alignment> _pipPositions(int value) {
    const tl = Alignment(-0.88, -0.88);
    const tr = Alignment(0.88, -0.88);
    const ml = Alignment(-0.88, 0);
    const mr = Alignment(0.88, 0);
    const bl = Alignment(-0.88, 0.88);
    const br = Alignment(0.88, 0.88);
    const c = Alignment.center;

    return switch (value) {
      1 => [c],
      2 => [tl, br],
      3 => [tl, c, br],
      4 => [tl, tr, bl, br],
      5 => [tl, tr, c, bl, br],
      6 => [tl, tr, ml, mr, bl, br],
      _ => [c],
    };
  }
}
