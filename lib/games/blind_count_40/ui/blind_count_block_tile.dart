import 'package:flutter/material.dart';
import 'package:genius_project/core/theme/app_theme.dart';

const Color _kHiddenBlock = Color(0xFF2A3548);
const Color _kFaceBlock = Color(0xFF1E3A5F);
const Color _kRevealBlock = Color(0xFF14532D);

enum BlindCountBlockAnim { none, spawn, reveal, vanish }

/// Animated block tile (flip reveal, vanish, refill spawn).
class BlindCountBlockTile extends StatefulWidget {
  const BlindCountBlockTile({
    super.key,
    required this.extent,
    required this.hidden,
    this.value,
    this.anim = BlindCountBlockAnim.none,
  });

  final double extent;
  final bool hidden;
  final int? value;
  final BlindCountBlockAnim anim;

  @override
  State<BlindCountBlockTile> createState() => _BlindCountBlockTileState();
}

class _BlindCountBlockTileState extends State<BlindCountBlockTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _flip;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _bindAnimations();
    _playAnim(widget.anim);
  }

  @override
  void didUpdateWidget(BlindCountBlockTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.anim != widget.anim) {
      _playAnim(widget.anim);
    }
  }

  void _bindAnimations() {
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _flip = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _playAnim(BlindCountBlockAnim anim) {
    switch (anim) {
      case BlindCountBlockAnim.none:
        _controller.value = 1;
      case BlindCountBlockAnim.spawn:
        _controller.duration = const Duration(milliseconds: 420);
        _controller.forward(from: 0);
      case BlindCountBlockAnim.reveal:
        _controller.duration = const Duration(milliseconds: 780);
        _controller.forward(from: 0);
      case BlindCountBlockAnim.vanish:
        _controller.duration = const Duration(milliseconds: 680);
        _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = widget.extent * 0.14;

    Widget face({required bool hidden}) {
      final bg = hidden
          ? _kHiddenBlock
          : (widget.anim == BlindCountBlockAnim.reveal
              ? _kRevealBlock
              : _kFaceBlock);
      return DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: hidden
                ? scheme.outlineVariant
                : AppTheme.neoGold.withValues(alpha: 0.55),
          ),
          boxShadow: hidden
              ? null
              : [
                  BoxShadow(
                    color: AppTheme.neoGold.withValues(alpha: 0.2),
                    blurRadius: widget.extent * 0.08,
                  ),
                ],
        ),
        child: Center(
          child: hidden
              ? Icon(
                  Icons.help_outline,
                  color: scheme.onSurfaceVariant,
                  size: widget.extent * 0.42,
                )
              : Text(
                  '${widget.value}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: widget.extent * 0.38,
                        fontWeight: FontWeight.w800,
                      ),
                ),
        ),
      );
    }

    if (widget.anim == BlindCountBlockAnim.reveal) {
      return AnimatedBuilder(
        animation: _flip,
        builder: (context, child) {
          final t = _flip.value;
          if (t < 0.05) {
            return SizedBox(
              width: widget.extent,
              height: widget.extent,
              child: face(hidden: true),
            );
          }
          return SizedBox(
            width: widget.extent,
            height: widget.extent,
            child: Opacity(
              opacity: t.clamp(0.0, 1.0),
              child: Transform.scale(
                scale: 0.92 + t * 0.08,
                child: face(hidden: false),
              ),
            ),
          );
        },
      );
    }

    if (widget.anim == BlindCountBlockAnim.vanish) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: 1 - _controller.value,
            child: Transform.scale(
              scale: 1 - _controller.value * 0.35,
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: widget.extent,
          height: widget.extent,
          child: face(hidden: false),
        ),
      );
    }

    if (widget.anim == BlindCountBlockAnim.spawn) {
      return AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Opacity(
              opacity: _scale.value.clamp(0.0, 1.0),
              child: child,
            ),
          );
        },
        child: SizedBox(
          width: widget.extent,
          height: widget.extent,
          child: face(hidden: widget.hidden),
        ),
      );
    }

    return SizedBox(
      width: widget.extent,
      height: widget.extent,
      child: face(hidden: widget.hidden),
    );
  }
}
