import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_cubit.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_card_widget.dart';
import 'package:genius_project/core/ui/turn_countdown_chip.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_chip_label.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_showdown_overlay.dart';
import 'package:genius_project/games/sniper_poker/ui/sniper_targeting_sheet.dart';

const Color _kFelt = Color(0xFF123B2D);
const Color _kRail = AppTheme.neoBackground;
const Color _kGold = AppTheme.neoGold;
const Duration _kShowdownHold = Duration(seconds: 5);
const Duration _kRoundStarterBannerHold = Duration(seconds: 2);

class SniperPokerScreen extends StatelessWidget {
  const SniperPokerScreen({super.key, this.cubit});

  final SniperMatchCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const body = _SniperPokerBody();

    if (cubit != null) {
      return BlocProvider<SniperMatchCubit>.value(value: cubit!, child: body);
    }
    return BlocProvider<SniperMatchCubit>(
      create: (_) => SniperMatchCubit(),
      child: body,
    );
  }
}

class _SniperPokerBody extends StatefulWidget {
  const _SniperPokerBody();

  @override
  State<_SniperPokerBody> createState() => _SniperPokerBodyState();
}

class _SniperPokerBodyState extends State<_SniperPokerBody> {
  Timer? _showdownTimer;
  Timer? _starterBannerTimer;
  bool _wasShowdown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final cubit = context.read<SniperMatchCubit>();
      if (cubit.state.isBetweenHands && !cubit.state.isGameOver) {
        cubit.startNewHand();
      }
    });
  }

  @override
  void dispose() {
    _showdownTimer?.cancel();
    _starterBannerTimer?.cancel();
    super.dispose();
  }

  void _scheduleStarterBannerDismiss() {
    _starterBannerTimer?.cancel();
    _starterBannerTimer = Timer(_kRoundStarterBannerHold, () {
      if (!mounted) return;
      context.read<SniperMatchCubit>().dismissRoundStarterBanner();
    });
  }

  void _scheduleAfterShowdown() {
    _showdownTimer?.cancel();
    _showdownTimer = Timer(_kShowdownHold, () {
      if (!mounted) return;
      final cubit = context.read<SniperMatchCubit>();
      final s = cubit.state;
      if (!s.isShowdown) return;
      if (s.isGameOver) {
        cubit.dismissHandRecap();
      } else {
        cubit.startNewHand();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SniperMatchCubit, SniperMatchState>(
      listener: (context, state) {
        if (state.showRoundStarterBanner) {
          _scheduleStarterBannerDismiss();
        }

        if (state.isShowdown && !_wasShowdown) {
          _scheduleAfterShowdown();
        }
        _wasShowdown = state.isShowdown;
      },
      listenWhen: (prev, next) =>
          prev.isShowdown != next.isShowdown ||
          prev.showRoundStarterBanner != next.showRoundStarterBanner,
      builder: (context, state) {
        final cubit = context.read<SniperMatchCubit>();
        final canAct = state.canP1Act;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Sniper Poker'),
            centerTitle: true,
            actions: [
              TurnCountdownChip(seconds: state.p1TurnSecondsRemaining),
              SizedBox(width: AdaptiveLayout.inlineGap(context)),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _SniperFeltTable(state: state),
                  ),
                  _SniperBottomRail(
                    state: state,
                    cubit: cubit,
                    canAct: canAct,
                  ),
                ],
              ),
              if (state.showRoundStarterBanner)
                _RoundStarterBanner(starter: state.handStarter),
              if (state.opponentActionBanner != null)
                _OpponentActionBanner(message: state.opponentActionBanner!),
              if (state.isGameOver && !state.isShowdown)
                _SniperGameOverOverlay(
                  winner: state.matchWinner,
                  p1Chips: state.p1Chips,
                  p2Chips: state.p2Chips,
                  onLeave: () => context.pop(),
                ),
              if (state.isShowdown)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardHeight =
                        AdaptiveLayout.sniperCardHeightForRow(
                      context: context,
                      rowMaxWidth: constraints.maxWidth * 0.35,
                      rowMaxHeight: constraints.maxHeight * 0.12,
                      cardCount: 2,
                    );
                    return SniperShowdownOverlay(
                      state: state,
                      cardHeight: cardHeight,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _SniperGameOverOverlay extends StatelessWidget {
  const _SniperGameOverOverlay({
    required this.winner,
    required this.p1Chips,
    required this.p2Chips,
    required this.onLeave,
  });

  final SniperPlayerId? winner;
  final int p1Chips;
  final int p2Chips;
  final VoidCallback onLeave;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context);
    final pad = AdaptiveLayout.screenPadding(context);
    final headline = switch (winner) {
      SniperPlayerId.p1 => 'You win the match!',
      SniperPlayerId.p2 => 'Opponent wins the match',
      null => 'Match over',
    };

    return Material(
      color: Colors.black.withValues(alpha: 0.88),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: pad,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: AdaptiveLayout.longestSide(context) * 0.85,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.neoBackground,
                  borderRadius: BorderRadius.circular(
                    AdaptiveLayout.sniperPanelRadius(context),
                  ),
                  border: Border.all(color: _kGold.withValues(alpha: 0.5)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(gap * 1.5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Game over',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: _kGold,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      SizedBox(height: gap),
                      Text(
                        headline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(height: gap * 0.75),
                      Text(
                        'You: $p1Chips  ·  Opponent: $p2Chips',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: gap * 1.25),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: onLeave,
                          child: const Text('Back to hub'),
                        ),
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
}

/// Green felt table — layout mirrors Blind Bluff: Fatal Fold.
class _SniperFeltTable extends StatelessWidget {
  const _SniperFeltTable({required this.state});

  final SniperMatchState state;

  @override
  Widget build(BuildContext context) {
    final reveal = state.isShowdown;
    final roundLabel = state.handPhase != SniperHandPhase.betweenHands
        ? state.currentRoundCount + 1
        : math.max(state.currentRoundCount, 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        final h = constraints.maxHeight;
        final tight = AdaptiveLayout.tightVerticalRegion(h, context);
        final basePad = AdaptiveLayout.feltInnerPadding(h);
        final horizontalInset =
            AdaptiveLayout.blindBluffFeltHorizontalInset(context, h);
        final pad = AdaptiveLayout.blindBluffFeltInnerPaddingY(basePad, h);
        final ig = AdaptiveLayout.inlineGap(context);
        final outerR = AdaptiveLayout.blindBluffFeltOuterRadius(context);
        final borderW = AdaptiveLayout.blindBluffFeltFrameBorderWidth(context);
        final innerClipR =
            AdaptiveLayout.blindBluffFeltInnerClipRadius(context, outerR);
        final topMargin = horizontalInset *
            AdaptiveLayout.blindBluffFeltTopMarginFactor(tight);

        return Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(
            horizontalInset,
            topMargin,
            horizontalInset,
            0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(outerR),
            border: Border.all(
              color: _kGold.withValues(alpha: 0.35),
              width: borderW,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius:
                    AdaptiveLayout.blindBluffFeltPanelShadowBlur(context),
                offset:
                    AdaptiveLayout.blindBluffFeltPanelShadowOffset(context),
              ),
            ],
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A5C45),
                _kFelt,
                Color(0xFF0E2419),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(innerClipR),
            child: Padding(
              padding: EdgeInsets.fromLTRB(pad, pad * 0.75, pad, pad * 0.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ig * 1.1,
                          vertical: ig * 0.35,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(
                            AdaptiveLayout.blindBluffFeltRoundPillRadius(
                              context,
                            ),
                          ),
                        ),
                        child: Text(
                          'R$roundLabel',
                          style: TextStyle(
                            color: _kGold,
                            fontWeight: FontWeight.w600,
                            fontSize:
                                Theme.of(context).textTheme.labelLarge?.fontSize,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (state.carryOverPot > 0)
                        SniperChipLabel(
                          amount: state.carryOverPot,
                          compact: true,
                        ),
                    ],
                  ),
                  SizedBox(
                    height: AdaptiveLayout.blindBluffFeltHeaderStackGap(
                      context,
                      tight,
                    ),
                  ),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, stackC) {
                        final sw = stackC.maxWidth;
                        final sh = stackC.maxHeight;
                        if (sw <= 0 || sh <= 0) {
                          return const SizedBox.shrink();
                        }

                        final edge = AdaptiveLayout.feltStackEdge(sw, sh);
                        final cornerMax =
                            AdaptiveLayout.feltCornerBlockMax(sw, sh);
                        final cardGap = AdaptiveLayout.sniperCardGap(context);
                        final cornerColumnMaxH =
                            AdaptiveLayout.blindBluffFeltCornerColumnMaxHeight(
                          sh,
                          tight,
                        );
                        final potBlockMaxW =
                            AdaptiveLayout.blindBluffFeltPotBlockMaxWidth(
                          stackWidth: sw,
                          stackEdge: edge,
                          cornerBlockMax: cornerMax,
                        );
                        final communityBlockW = math.min(
                          sw - 2 * edge,
                          potBlockMaxW * 1.2,
                        );
                        final centerBottomInset = cornerColumnMaxH + edge * 1.2;
                        final potBandMaxH =
                            math.max(0.0, sh - centerBottomInset - edge * 2);
                        final holeCardDesignH =
                            AdaptiveLayout.feltCornerCardHeight(
                          stackWidth: sw,
                          stackHeight: sh,
                          tightVerticalRegion: tight,
                        );

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              bottom: edge,
                              left: edge,
                              child: SizedBox(
                                width: cornerMax,
                                height: cornerColumnMaxH,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.bottomLeft,
                                  child: _FeltCornerSeat(
                                    state: state,
                                    cardGap: cardGap,
                                    holeCardHeight: holeCardDesignH,
                                    alignEnd: false,
                                    faceDown: false,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: edge,
                              right: edge,
                              child: SizedBox(
                                width: cornerMax,
                                height: cornerColumnMaxH,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.bottomRight,
                                  child: _FeltCornerSeat(
                                    state: state,
                                    cardGap: cardGap,
                                    holeCardHeight: holeCardDesignH,
                                    alignEnd: true,
                                    faceDown: !reveal,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: edge,
                              right: edge,
                              top: edge,
                              bottom: centerBottomInset,
                              child: Center(
                                child: SizedBox(
                                  width: communityBlockW,
                                  height: potBandMaxH,
                                  child: _SniperPotBand(
                                    state: state,
                                    cardGap: cardGap,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SniperPotBand extends StatelessWidget {
  const _SniperPotBand({
    required this.state,
    required this.cardGap,
  });

  final SniperMatchState state;
  final double cardGap;

  @override
  Widget build(BuildContext context) {
    final potGap = AdaptiveLayout.blindBluffFeltCardPotGap(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SniperChipLabel(amount: state.currentPot),
            SizedBox(height: potGap),
            Expanded(
              child: LayoutBuilder(
                builder: (context, cardConstraints) {
                  final communityCardH =
                      AdaptiveLayout.sniperCommunityCardHeight(
                    context: context,
                    rowMaxWidth: cardConstraints.maxWidth,
                    rowMaxHeight: cardConstraints.maxHeight,
                  );
                  return Center(
                    child: _CommunityRow(
                      state: state,
                      cardHeight: communityCardH,
                      gap: cardGap,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Corner seat at natural size; parent [FittedBox] scales to fit the box.
class _FeltCornerSeat extends StatelessWidget {
  const _FeltCornerSeat({
    required this.state,
    required this.cardGap,
    required this.holeCardHeight,
    required this.alignEnd,
    required this.faceDown,
  });

  final SniperMatchState state;
  final double cardGap;
  final double holeCardHeight;
  final bool alignEnd;
  final bool faceDown;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context);
    final isP1 = !alignEnd;
    final chips = isP1 ? state.p1Chips : state.p2Chips;
    final investment = isP1 ? state.p1RoundInvestment : state.p2RoundInvestment;
    final activeSkill = isP1 ? state.p1ActiveSkill : state.p2ActiveSkill;
    final holeCards = isP1 ? state.p1HoleCards : state.p2HoleCards;
    final showKevlar = activeSkill == SniperMatchCubit.skillKevlar;
    final highlight = state.actingPlayer ==
            (isP1 ? SniperPlayerId.p1 : SniperPlayerId.p2) &&
        !state.isShowdown &&
        state.isBettingPhase;
    final title = isP1 ? 'You ($chips)' : 'Opponent ($chips)';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        _SeatLabel(
          title: title,
          investment: investment,
          activeSkill: activeSkill,
          highlight: highlight,
          alignEnd: alignEnd,
          compact: true,
        ),
        SizedBox(height: gap * 0.35),
        _HoleCardRow(
          cards: holeCards,
          cardHeight: holeCardHeight,
          gap: cardGap,
          faceDown: faceDown,
          emptyLabel: alignEnd ? '—' : null,
          showKevlarShield: showKevlar,
        ),
      ],
    );
  }
}

class _SeatLabel extends StatelessWidget {
  const _SeatLabel({
    required this.title,
    required this.investment,
    required this.activeSkill,
    required this.alignEnd,
    this.highlight = false,
    this.compact = false,
  });

  final String title;
  final int investment;
  final String? activeSkill;
  final bool alignEnd;
  final bool highlight;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context);
    final baseFs = Theme.of(context).textTheme.labelLarge?.fontSize ?? 14.0;
    final seatLabelFs = compact ? baseFs * 0.88 : baseFs;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: highlight ? _kGold : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: seatLabelFs,
          ),
        ),
        if (investment > 0) ...[
          SizedBox(
            height: AdaptiveLayout.blindBluffFeltSeatLabelChipGap(context),
          ),
          SniperChipLabel(amount: investment, compact: true),
        ],
        if (activeSkill == SniperMatchCubit.skillFlashbang ||
            activeSkill == SniperMatchCubit.skillLens) ...[
          SizedBox(height: gap * 0.35),
          _ActiveSkillGlyph(skillId: activeSkill!),
        ],
      ],
    );
  }
}

class _ActiveSkillGlyph extends StatelessWidget {
  const _ActiveSkillGlyph({required this.skillId});

  final String skillId;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (skillId) {
      SniperMatchCubit.skillFlashbang => (
          Icons.flash_on,
          Colors.orangeAccent,
        ),
      SniperMatchCubit.skillLens => (
          Icons.center_focus_strong_outlined,
          AppTheme.neoPurple,
        ),
      _ => (Icons.shield_outlined, _kGold),
    };
    return Icon(
      icon,
      size: AdaptiveLayout.sniperSkillIconSize(context),
      color: color,
    );
  }
}

class _HoleCardRow extends StatelessWidget {
  const _HoleCardRow({
    required this.cards,
    required this.cardHeight,
    required this.gap,
    required this.faceDown,
    this.emptyLabel,
    this.showKevlarShield = false,
  });

  final List<SniperCard> cards;
  final double cardHeight;
  final double gap;
  final bool faceDown;
  final String? emptyLabel;
  final bool showKevlarShield;

  @override
  Widget build(BuildContext context) {
    if (cards.isEmpty) {
      return Text(
        emptyLabel ?? '',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white54,
            ),
      );
    }

    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) SizedBox(width: gap),
            SniperCardWidget(
              extent: cardHeight,
              card: cards[i],
              faceDown: faceDown,
            ),
          ],
          if (showKevlarShield) ...[
            SizedBox(width: gap),
            Tooltip(
              message: 'Kevlar Vest — sniper blocked',
              child: Icon(
                Icons.security,
                size: cardHeight * 0.4,
                color: _kGold,
              ),
            ),
          ],
        ],
    );
  }
}

class _CommunityRow extends StatelessWidget {
  const _CommunityRow({
    required this.state,
    required this.cardHeight,
    required this.gap,
  });

  final SniperMatchState state;
  final double cardHeight;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final cards = state.communityCards;
    final riverPending = !state.riverDealt;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) SizedBox(width: gap),
          if (i < cards.length)
            SniperCardWidget(
              extent: cardHeight,
              card: cards[i],
              faceDown: riverPending && i >= 2,
            )
          else if (riverPending && i >= 2)
            SniperCardWidget(extent: cardHeight, faceDown: true)
          else
            SniperEmptyCardSlot(extent: cardHeight),
        ],
      ],
    );
  }
}

class _SniperBottomRail extends StatelessWidget {
  const _SniperBottomRail({
    required this.state,
    required this.cubit,
    required this.canAct,
  });

  final SniperMatchState state;
  final SniperMatchCubit cubit;
  final bool canAct;

  @override
  Widget build(BuildContext context) {
    final opponentActive = state.actingPlayer == SniperPlayerId.p2;
    final opponentAllIn = state.isAllIn(SniperPlayerId.p2);
    final thinking = !state.isShowdown &&
        opponentActive &&
        !opponentAllIn &&
        (state.isBettingPhase ||
            (state.handPhase == SniperHandPhase.sniper &&
                !state.p2SniperLocked) ||
            (state.handPhase == SniperHandPhase.skills &&
                !state.p2SkillLocked));
    final railTitle = switch (state.handPhase) {
      SniperHandPhase.skills =>
        canAct ? 'Choose your skill' : 'Opponent choosing skill…',
      SniperHandPhase.betting1 || SniperHandPhase.betting2 => canAct
          ? 'Your action'
          : thinking
              ? 'Opponent is thinking…'
              : 'Waiting…',
      SniperHandPhase.sniper => canAct
          ? 'Sniper targeting'
          : thinking
              ? 'Opponent targeting…'
              : 'Waiting…',
      _ => 'Waiting…',
    };

    return Material(
      color: _kRail,
      elevation: 12,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AdaptiveLayout.sniperBottomRailMinHeight(context),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AdaptiveLayout.shortestSide(context) * 0.025,
            AdaptiveLayout.sectionGap(context) * 0.2,
            AdaptiveLayout.shortestSide(context) * 0.025,
            AdaptiveLayout.sectionGap(context) * 0.28,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                railTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (state.handPhase == SniperHandPhase.skills) ...[
                SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.25),
                _SkillRow(
                  state: state,
                  enabled: canAct,
                  onPass: cubit.passSkill,
                ),
              ] else ...[
                SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.3),
                _ActionPanel(
                  state: state,
                  canAct: canAct,
                  cubit: cubit,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.state,
    required this.enabled,
    required this.onPass,
  });

  final SniperMatchState state;
  final bool enabled;
  final VoidCallback onPass;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SniperMatchCubit>();
    final gap = AdaptiveLayout.inlineGap(context);
    final vPad = AdaptiveLayout.inlineGap(context);

    bool skillEnabled(String id) =>
        enabled && !state.p1UsedSkills.contains(id);

    Widget skillButton({
      required String label,
      required VoidCallback? onTap,
    }) =>
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: vPad),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onTap,
            child: Text(label, textAlign: TextAlign.center),
          ),
        );

    return Row(
      children: [
        skillButton(
          label: 'Kevlar',
          onTap: skillEnabled(SniperMatchCubit.skillKevlar)
              ? () => cubit.executeSkill(SniperMatchCubit.skillKevlar)
              : null,
        ),
        SizedBox(width: gap),
        skillButton(
          label: 'Flashbang',
          onTap: skillEnabled(SniperMatchCubit.skillFlashbang)
              ? () => cubit.executeSkill(SniperMatchCubit.skillFlashbang)
              : null,
        ),
        SizedBox(width: gap),
        skillButton(
          label: 'Wide Lens',
          onTap: skillEnabled(SniperMatchCubit.skillLens)
              ? () => cubit.executeSkill(SniperMatchCubit.skillLens)
              : null,
        ),
        SizedBox(width: gap),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: vPad),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: enabled ? onPass : null,
            child: const Text('PASS'),
          ),
        ),
      ],
    );
  }
}

class _ActionPanel extends StatelessWidget {
  const _ActionPanel({
    required this.state,
    required this.canAct,
    required this.cubit,
  });

  final SniperMatchState state;
  final bool canAct;
  final SniperMatchCubit cubit;

  @override
  Widget build(BuildContext context) {
    if (state.isBetweenHands || state.isShowdown) {
      return const SizedBox.shrink();
    }

    final gap = AdaptiveLayout.inlineGap(context);
    final vPad = AdaptiveLayout.inlineGap(context);

    if (state.isBettingPhase) {
      final toCall = state.amountToCall(SniperPlayerId.p1);
      final callLabel = toCall > 0 ? 'Call $toCall' : 'Check';

      Future<void> openRaise() async {
        final maxRaise = cubit.maxRaiseFor(SniperPlayerId.p1);
        if (maxRaise < SniperMatchCubit.minRaise) return;
        final amount = await SniperRaiseSheet.show(
          context,
          minRaise: SniperMatchCubit.minRaise,
          maxRaise: maxRaise,
        );
        if (amount == null || !context.mounted) return;
        cubit.raise(SniperPlayerId.p1, amount);
      }

      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent, width: 1.5),
                padding: EdgeInsets.symmetric(vertical: vPad),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: canAct ? () => cubit.fold(SniperPlayerId.p1) : null,
              child: const Text('FOLD'),
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            flex: 2,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF4B5563),
                padding: EdgeInsets.symmetric(vertical: vPad),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed:
                  canAct ? () => cubit.checkOrCall(SniperPlayerId.p1) : null,
              child: Text(callLabel),
            ),
          ),
          SizedBox(width: gap),
          Expanded(
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _kGold,
                foregroundColor: AppTheme.neoBackground,
                padding: EdgeInsets.symmetric(vertical: vPad),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: canAct &&
                      cubit.maxRaiseFor(SniperPlayerId.p1) >=
                          SniperMatchCubit.minRaise
                  ? openRaise
                  : null,
              child: const Text('RAISE'),
            ),
          ),
        ],
      );
    }

    if (state.handPhase != SniperHandPhase.sniper) {
      return const SizedBox.shrink();
    }

    final blindedByFlashbang =
        state.p2ActiveSkill == SniperMatchCubit.skillFlashbang;
    final attackCanAct = canAct && !blindedByFlashbang;
    final wideLensActive =
        state.p1ActiveSkill == SniperMatchCubit.skillLens;

    Future<void> openSniper() async {
      if (blindedByFlashbang) return;
      final result = await SniperTargetingSheet.show(
        context,
        mode: SniperModeSelection.sniper,
        communityCards: state.communityCards,
        holeCards: state.p1HoleCards,
        wideLensActive: wideLensActive,
      );
      if (result == null || !context.mounted) return;
      cubit.declareSniperOrShotgun(
        SniperPlayerId.p1,
        SniperModeSelection.sniper,
        result.$1,
        result.$2,
      );
    }

    Future<void> openShotgun() async {
      if (blindedByFlashbang) return;
      final result = await SniperTargetingSheet.show(
        context,
        mode: SniperModeSelection.shotgun,
        communityCards: state.communityCards,
        holeCards: state.p1HoleCards,
      );
      if (result == null || !context.mounted) return;
      cubit.declareSniperOrShotgun(
        SniperPlayerId.p1,
        SniperModeSelection.shotgun,
        result.$1,
        null,
      );
    }

    Widget attackRow() {
      return Stack(
        alignment: Alignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: vPad),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: attackCanAct ? openSniper : null,
                  child: const Text('SNIPER'),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: vPad),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: attackCanAct &&
                          state.p1ShotgunCooldownRounds == 0
                      ? openShotgun
                      : null,
                  child: const Text('SHOTGUN'),
                ),
              ),
              SizedBox(width: gap),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: vPad),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  onPressed: canAct ? cubit.passSniper : null,
                  child: const Text('PASS'),
                ),
              ),
            ],
          ),
          if (blindedByFlashbang)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _kRail.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(
                    AdaptiveLayout.sniperPanelRadius(context),
                  ),
                  border: Border.all(
                    color: Colors.orangeAccent.withValues(alpha: 0.6),
                  ),
                ),
                child: Center(
                  child: Text(
                    'BLINDED BY FLASHBANG',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      );
    }

    return attackRow();
  }
}

class _RoundStarterBanner extends StatelessWidget {
  const _RoundStarterBanner({required this.starter});

  final SniperPlayerId? starter;

  @override
  Widget build(BuildContext context) {
    final youStart = starter == SniperPlayerId.p1;
    final text = youStart
        ? 'You act first this round'
        : 'Opponent acts first this round';

    return _CenterBanner(
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: _kGold,
              fontWeight: FontWeight.w800,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OpponentActionBanner extends StatelessWidget {
  const _OpponentActionBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return _CenterBanner(
      child: Text(
        message,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _CenterBanner extends StatelessWidget {
  const _CenterBanner({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final pad = AdaptiveLayout.screenPadding(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.55),
          child: Center(
            child: Padding(
              padding: pad,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _kRail,
                  borderRadius: BorderRadius.circular(
                    AdaptiveLayout.sniperPanelRadius(context),
                  ),
                  border: Border.all(
                    color: _kGold.withValues(alpha: 0.45),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: pad.horizontal * 1.2,
                    vertical: AdaptiveLayout.sectionGap(context),
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
