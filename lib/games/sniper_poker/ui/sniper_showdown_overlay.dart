import 'package:flutter/material.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_card_widget.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_hand_labels.dart';

/// Brief round recap table (5s) — hands, chip deltas, sniper/shotgun lines.
class SniperShowdownOverlay extends StatelessWidget {
  const SniperShowdownOverlay({
    required this.state,
    required this.cardHeight,
    super.key,
  });

  final SniperMatchState state;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final snapshot = state.showdownSnapshot;
    if (snapshot == null) return const SizedBox.shrink();

    final gap = AdaptiveLayout.inlineGap(context);
    final pad = AdaptiveLayout.screenPadding(context);
    final folded = snapshot.foldedPlayer;

    return Material(
      color: Colors.black.withValues(alpha: 0.82),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: pad,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AdaptiveLayout.longestSide(context) * 0.92,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.neoBackground,
                  borderRadius: BorderRadius.circular(
                    AdaptiveLayout.sniperPanelRadius(context),
                  ),
                  border: Border.all(
                    color: AppTheme.neoGold.withValues(alpha: 0.4),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(gap * 1.2),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.1),
                      1: FlexColumnWidth(1.4),
                      2: FlexColumnWidth(1.2),
                      3: FlexColumnWidth(1.4),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                        children: [
                          _HeaderCell(''),
                          _HeaderCell('Hand'),
                          _HeaderCell('Chips'),
                          _HeaderCell('Target'),
                        ],
                      ),
                      _dataRow(
                        context,
                        label: 'You',
                        hideHand: folded == SniperPlayerId.p1,
                        holeCards: state.p1HoleCards,
                        hand: snapshot.p1Hand,
                        chipsEnd: snapshot.p1ChipsEnd,
                        chipDelta: snapshot.p1ChipDelta,
                        skillLine: snapshot.p1SkillLine,
                        targetLine: snapshot.p1TargetLine,
                        snipedLabel: snapshot.p1SnipedLabel,
                        shotgunLabel: snapshot.p1ShotgunLabel,
                        cardHeight: cardHeight,
                        gap: gap,
                      ),
                      _dataRow(
                        context,
                        label: 'Opponent',
                        hideHand: folded == SniperPlayerId.p2,
                        holeCards: state.p2HoleCards,
                        hand: snapshot.p2Hand,
                        chipsEnd: snapshot.p2ChipsEnd,
                        chipDelta: snapshot.p2ChipDelta,
                        skillLine: snapshot.p2SkillLine,
                        targetLine: snapshot.p2TargetLine,
                        snipedLabel: snapshot.p2SnipedLabel,
                        shotgunLabel: snapshot.p2ShotgunLabel,
                        cardHeight: cardHeight,
                        gap: gap,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TableRow _dataRow(
    BuildContext context, {
    required String label,
    required bool hideHand,
    required List<SniperCard> holeCards,
    required ParsedHand hand,
    required int chipsEnd,
    required int chipDelta,
    required String skillLine,
    required String targetLine,
    required bool snipedLabel,
    required bool shotgunLabel,
    required double cardHeight,
    required double gap,
  }) {
    final deltaText = chipDelta >= 0 ? '(+$chipDelta)' : '($chipDelta)';
    final chipsText = '$chipsEnd$deltaText';

    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: gap * 0.6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: gap * 0.4),
          child: hideHand
              ? Text(
                  'Folded',
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (var i = 0; i < holeCards.length; i++) ...[
                            if (i > 0) SizedBox(width: gap * 0.35),
                            SniperCardWidget(
                              extent: cardHeight,
                              card: holeCards[i],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: gap * 0.25),
                    Text(
                      hand.rank.label,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (snipedLabel) ...[
                      SizedBox(height: gap * 0.2),
                      Text(
                        'Sniped',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ],
                ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: gap * 0.6),
          child: Text(
            chipsText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: chipDelta >= 0
                      ? Colors.greenAccent
                      : (chipDelta < 0 ? Colors.redAccent : null),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: gap * 0.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                skillLine,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                targetLine,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.neoGold,
                    ),
              ),
              if (shotgunLabel) ...[
                SizedBox(height: gap * 0.2),
                Text(
                  'Shotgun',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(
        bottom: AdaptiveLayout.inlineGap(context) * 0.4,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: AppTheme.neoGold,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
