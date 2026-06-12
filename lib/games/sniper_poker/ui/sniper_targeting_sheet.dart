import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_card_widget.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_hand_labels.dart';

/// Compact picker for SNIPER (rank + value) or SHOTGUN (rank only).
class SniperTargetingSheet extends StatefulWidget {
  static Future<(HandRank rank, int? value)?> show(
    BuildContext context, {
    required SniperModeSelection mode,
    required List<SniperCard> communityCards,
    List<SniperCard> holeCards = const [],
    bool wideLensActive = false,
  }) {
    final maxH = AdaptiveLayout.longestSide(context) * 0.42;

    return showModalBottomSheet<(HandRank rank, int? value)?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.neoBackground,
      constraints: BoxConstraints(maxHeight: maxH),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AdaptiveLayout.sniperPanelRadius(context)),
        ),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: mode == SniperModeSelection.sniper
            ? SniperTargetingSheet.sniper(
                communityCards: communityCards,
                holeCards: holeCards,
                wideLensActive: wideLensActive,
              )
            : SniperTargetingSheet.shotgun(
                communityCards: communityCards,
                holeCards: holeCards,
              ),
      ),
    );
  }

  const SniperTargetingSheet.sniper({
    required this.communityCards,
    this.holeCards = const [],
    this.wideLensActive = false,
    super.key,
  }) : mode = SniperModeSelection.sniper;

  const SniperTargetingSheet.shotgun({
    required this.communityCards,
    this.holeCards = const [],
    super.key,
  })  : mode = SniperModeSelection.shotgun,
        wideLensActive = false;

  final SniperModeSelection mode;
  final List<SniperCard> communityCards;
  final List<SniperCard> holeCards;
  final bool wideLensActive;

  @override
  State<SniperTargetingSheet> createState() => _SniperTargetingSheetState();
}

class _SniperTargetingSheetState extends State<SniperTargetingSheet> {
  HandRank _rank = HandRank.pair;
  int _value = 5;

  @override
  Widget build(BuildContext context) {
    final hPad = AdaptiveLayout.shortestSide(context) * 0.03;
    final vPad = AdaptiveLayout.inlineGap(context) * 0.75;
    final gap = AdaptiveLayout.inlineGap(context) * 0.65;
    final isSniper = widget.mode == SniperModeSelection.sniper;
    final titleStyle = Theme.of(context).textTheme.titleMedium;
    final labelStyle = Theme.of(context).textTheme.labelMedium;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isSniper ? 'Sniper target' : 'Shotgun rank',
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            if (isSniper && widget.wideLensActive) ...[
              SizedBox(height: gap * 0.35),
              Text(
                'Wide Lens: also hits value ±1',
                style: labelStyle?.copyWith(
                  color: AppTheme.neoPurple,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            SizedBox(height: gap),
            _TargetingCardStrip(
              label: 'Board',
              cards: widget.communityCards,
            ),
            if (widget.holeCards.isNotEmpty) ...[
              SizedBox(height: gap * 0.5),
              _TargetingCardStrip(
                label: 'Your hand',
                cards: widget.holeCards,
              ),
            ],
            SizedBox(height: gap),
            Text('Hand rank', style: labelStyle),
            SizedBox(height: gap * 0.35),
            SizedBox(
              height: AdaptiveLayout.shortestSide(context) * 0.052,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: SniperHandRankLabel.targetingRanks.length,
                separatorBuilder: (_, __) => SizedBox(width: gap * 0.4),
                itemBuilder: (context, index) {
                  final rank = SniperHandRankLabel.targetingRanks[index];
                  return ChoiceChip(
                    label: Text(
                      rank.label,
                      style: labelStyle,
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.symmetric(horizontal: gap * 0.35),
                    selected: _rank == rank,
                    onSelected: (_) => setState(() => _rank = rank),
                  );
                },
              ),
            ),
            if (isSniper) ...[
              SizedBox(height: gap * 0.65),
              Row(
                children: [
                  Text('Value: $_value', style: labelStyle),
                  Expanded(
                    child: Slider(
                      value: _value.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      label: '$_value',
                      onChanged: (v) => setState(() => _value = v.round()),
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: gap * 0.5),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: vPad * 0.85),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Navigator.of(context).pop(
                isSniper ? (_rank, _value) : (_rank, null),
              ),
              child: Text(isSniper ? 'Lock sniper' : 'Fire shotgun'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetingCardStrip extends StatelessWidget {
  const _TargetingCardStrip({
    required this.label,
    required this.cards,
  });

  final String label;
  final List<SniperCard> cards;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context) * 0.4;
    final labelStyle = Theme.of(context).textTheme.labelSmall;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardH = AdaptiveLayout.sniperCardHeightForRow(
          context: context,
          rowMaxWidth: constraints.maxWidth,
          rowMaxHeight: AdaptiveLayout.shortestSide(context) * 0.11,
          cardCount: cards.isEmpty ? 4 : cards.length,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: labelStyle),
            SizedBox(height: gap * 0.35),
            if (cards.isEmpty)
              Text(
                '—',
                style: labelStyle?.copyWith(color: Colors.white54),
              )
            else
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < cards.length; i++) ...[
                      if (i > 0) SizedBox(width: gap),
                      SniperCardWidget(
                        extent: cardH,
                        card: cards[i],
                      ),
                    ],
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Compact raise amount picker.
class SniperRaiseSheet extends StatefulWidget {
  const SniperRaiseSheet({
    required this.maxRaise,
    required this.minRaise,
    super.key,
  });

  final int minRaise;
  final int maxRaise;

  static Future<int?> show(
    BuildContext context, {
    required int minRaise,
    required int maxRaise,
  }) {
    final maxH = AdaptiveLayout.longestSide(context) * 0.28;

    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.neoBackground,
      constraints: BoxConstraints(maxHeight: maxH),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AdaptiveLayout.sniperPanelRadius(context)),
        ),
      ),
      builder: (context) => SniperRaiseSheet(minRaise: minRaise, maxRaise: maxRaise),
    );
  }

  @override
  State<SniperRaiseSheet> createState() => _SniperRaiseSheetState();
}

class _SniperRaiseSheetState extends State<SniperRaiseSheet> {
  late int _amount = widget.minRaise;

  @override
  Widget build(BuildContext context) {
    final hPad = AdaptiveLayout.shortestSide(context) * 0.03;
    final vPad = AdaptiveLayout.inlineGap(context) * 0.75;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, vPad, hPad, vPad),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Raise +$_amount',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            Slider(
              value: _amount.toDouble(),
              min: widget.minRaise.toDouble(),
              max: widget.maxRaise.toDouble(),
              divisions: math.max(1, widget.maxRaise - widget.minRaise),
              label: '+$_amount',
              onChanged: (v) => setState(() => _amount = v.round()),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: vPad * 0.85),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: () => Navigator.of(context).pop(_amount),
              child: const Text('Confirm raise'),
            ),
          ],
        ),
      ),
    );
  }
}
