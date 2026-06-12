import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_evaluator.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_cubit.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_rules.dart';
import 'package:genius_project/games/bluff_cup/logic/bluff_match_state.dart';
import 'package:genius_project/games/bluff_cup/models/bid_model.dart';
import 'package:genius_project/games/bluff_cup/models/cup_player.dart';
import 'package:genius_project/games/bluff_cup/models/dice_model.dart';
import 'package:genius_project/games/bluff_cup/ui/cup_die_widget.dart';

/// App bar chip: seconds left for the local player to act.
class _TurnCountdownAction extends StatelessWidget {
  const _TurnCountdownAction({required this.seconds});

  final int? seconds;

  @override
  Widget build(BuildContext context) {
    final s = seconds;
    if (s == null) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;
    final urgent = s <= 5;
    return Center(
      child: Chip(
        avatar: Icon(
          Icons.timer_outlined,
          size: 18,
          color: urgent ? scheme.error : scheme.secondary,
        ),
        label: Text(
          '$s s',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: urgent ? scheme.error : scheme.onSurface,
              ),
        ),
        side: BorderSide(
          color: urgent ? scheme.error : scheme.outlineVariant,
        ),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.symmetric(
          horizontal: AdaptiveLayout.inlineGap(context) * 0.5,
        ),
      ),
    );
  }
}

/// Best-of-seven: green = you won the round, red = opponent, outline = not played.
class _MatchRoundIndicatorRow extends StatelessWidget {
  const _MatchRoundIndicatorRow({required this.state});

  final BluffMatchState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dot = AdaptiveLayout.bluffCupRoundDotExtent(context);
    final gap = AdaptiveLayout.bluffCupRoundDotGap(context);
    final results = state.roundResults;

    return Padding(
      padding: EdgeInsets.only(bottom: AdaptiveLayout.inlineGap(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < BluffMatchRules.totalRounds; i++) ...[
            if (i > 0) SizedBox(width: gap),
            _RoundDot(
              extent: dot,
              winner: i < results.length ? results[i] : null,
              isCurrentRound:
                  i == state.currentRoundIndex && !state.isShowdown,
              scheme: scheme,
            ),
          ],
        ],
      ),
    );
  }
}

class _RoundDot extends StatelessWidget {
  const _RoundDot({
    required this.extent,
    required this.winner,
    required this.isCurrentRound,
    required this.scheme,
  });

  final double extent;
  final CupPlayerId? winner;
  final bool isCurrentRound;
  final ColorScheme scheme;

  static const Color _playerGreen = Color(0xFF22C55E);
  static const Color _opponentRed = Color(0xFFEF4444);

  @override
  Widget build(BuildContext context) {
    final borderW = extent * 0.12;
    if (winner == CupPlayerId.p1) {
      return Container(
        width: extent,
        height: extent,
        decoration: BoxDecoration(
          color: _playerGreen,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCurrentRound ? scheme.secondary : Colors.transparent,
            width: isCurrentRound ? borderW * 1.8 : 0,
          ),
        ),
      );
    }
    if (winner == CupPlayerId.p2) {
      return Container(
        width: extent,
        height: extent,
        decoration: BoxDecoration(
          color: _opponentRed,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCurrentRound ? scheme.secondary : Colors.transparent,
            width: isCurrentRound ? borderW * 1.8 : 0,
          ),
        ),
      );
    }
    return Container(
      width: extent,
      height: extent,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrentRound
              ? scheme.secondary
              : scheme.outlineVariant,
          width: isCurrentRound ? borderW * 1.6 : borderW,
        ),
      ),
    );
  }
}

/// Blind Cup: Liar's dice — dark casino felt table.
class BluffCupScreen extends StatelessWidget {
  const BluffCupScreen({super.key, this.cubit});

  final BluffMatchCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const body = _BluffCupBody();

    if (cubit != null) {
      return BlocProvider<BluffMatchCubit>.value(
        value: cubit!,
        child: body,
      );
    }
    return BlocProvider<BluffMatchCubit>(
      create: (_) => BluffMatchCubit(),
      child: body,
    );
  }
}

class _BluffCupBody extends StatefulWidget {
  const _BluffCupBody();

  @override
  State<_BluffCupBody> createState() => _BluffCupBodyState();
}

class _BluffCupBodyState extends State<_BluffCupBody> {
  int? _opponentBidScheduledForTurn;
  int _opponentScheduleGeneration = 0;
  bool _raiseBidOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_scheduleOpponentIfNeeded);
  }

  void _scheduleOpponentIfNeeded(_) {
    if (!mounted) {
      return;
    }
    _maybeScheduleOpponentBid(context, context.read<BluffMatchCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return MultiBlocListener(
      listeners: [
        BlocListener<BluffMatchCubit, BluffMatchState>(
          listenWhen: (prev, next) =>
              !prev.isShowdown && next.isShowdown,
          listener: (context, state) {
            _opponentScheduleGeneration++;
            _opponentBidScheduledForTurn = null;
            if (_raiseBidOpen) {
              setState(() => _raiseBidOpen = false);
            }
          },
        ),
        BlocListener<BluffMatchCubit, BluffMatchState>(
          listenWhen: (prev, next) =>
              prev.showRoundOpenerOverlay && !next.showRoundOpenerOverlay,
          listener: (context, state) {
            _maybeScheduleOpponentBid(context, state);
          },
        ),
        BlocListener<BluffMatchCubit, BluffMatchState>(
          listenWhen: (prev, next) {
            if (next.isShowdown ||
                next.matchWinner != null ||
                next.showRoundOpenerOverlay) {
              return false;
            }
            if (next.currentTurn != CupPlayerId.p2) {
              return false;
            }
            return prev.currentTurn != next.currentTurn ||
                prev.currentRoundIndex != next.currentRoundIndex ||
                (prev.isShowdown && !next.isShowdown);
          },
          listener: (context, state) {
            _maybeScheduleOpponentBid(context, state);
          },
        ),
      ],
      child: BlocBuilder<BluffMatchCubit, BluffMatchState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: scheme.surface,
            appBar: AppBar(
              title: Text(
                "Blind Cup: Liar's dice",
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              actions: [
                Padding(
                  padding: EdgeInsets.only(
                    right: AdaptiveLayout.inlineGap(context),
                  ),
                  child: _TurnCountdownAction(seconds: state.p1TurnSecondsRemaining),
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: AdaptiveLayout.bluffCupPlayInsets(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _MatchRoundIndicatorRow(state: state),
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: _TableTopRow(state: state),
                              ),
                              SizedBox(
                                height: AdaptiveLayout.sectionGap(context),
                              ),
                              _PlayerRail(
                                state: state,
                                onRaiseBid: () =>
                                    setState(() => _raiseBidOpen = true),
                              ),
                            ],
                          ),
                          if (_raiseBidOpen)
                            _RaiseBidOverlay(
                              onClose: () =>
                                  setState(() => _raiseBidOpen = false),
                            ),
                          if (state.showRoundOpenerOverlay && !state.isShowdown)
                            _RoundOpenerOverlay(
                              key: ValueKey<int>(state.currentRoundIndex),
                              state: state,
                            ),
                          if (state.isShowdown)
                            _RoundResultOverlay(
                              key: ValueKey<int>(state.currentRoundIndex),
                              state: state,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _maybeScheduleOpponentBid(BuildContext context, BluffMatchState state) {
    if (state.isShowdown ||
        state.matchWinner != null ||
        state.showRoundOpenerOverlay ||
        state.currentTurn != CupPlayerId.p2) {
      return;
    }
    final turnKey = Object.hash(
      state.currentRoundIndex,
      state.currentTurn.index,
      state.currentBid?.quantity,
      state.currentBid?.faceValue,
    );
    if (_opponentBidScheduledForTurn == turnKey) {
      return;
    }
    _opponentBidScheduledForTurn = turnKey;
    final generation = _opponentScheduleGeneration;

    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 700), () {
        if (!context.mounted || generation != _opponentScheduleGeneration) {
          return;
        }
        final cubit = context.read<BluffMatchCubit>();
        final live = cubit.state;
        if (live.isShowdown ||
            live.matchWinner != null ||
            live.currentTurn != CupPlayerId.p2) {
          return;
        }
        cubit.runOpponentTurn();
      }),
    );
  }
}

/// Top row: opponent (left, green felt) | current bid (right).
class _TableTopRow extends StatelessWidget {
  const _TableTopRow({required this.state});

  final BluffMatchState state;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gap = AdaptiveLayout.sectionGap(context);
    final diceGap = AdaptiveLayout.bluffCupDiceGap(context);
    final feltTop =
        Color.lerp(Colors.green.shade800, Colors.green.shade900, 0.35)!;
    final feltBottom = Colors.green.shade900;
    final oppRadius = AdaptiveLayout.bluffCupOpponentFeltRadius(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final rowH = constraints.maxHeight;
        final oppW = constraints.maxWidth * 0.58;
        final dieP2 = AdaptiveLayout.bluffCupDieExtentForRow(
          context: context,
          rowMaxWidth: oppW,
          rowMaxHeight: rowH * 0.55,
        );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(oppRadius),
                  border: Border.all(
                    color: scheme.secondary.withValues(alpha: 0.7),
                    width: AdaptiveLayout.bluffCupFeltBorderWidth(context),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [feltTop, feltBottom],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AdaptiveLayout.inlineGap(context),
                    vertical: gap * 0.35,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _SeatLabel(
                        label: 'Opponent',
                        highlight: state.currentTurn == CupPlayerId.p2 &&
                            !state.isShowdown,
                      ),
                      SizedBox(width: gap * 0.6),
                      Expanded(
                        child: _DiceRow(
                          dice: state.p2Dice,
                          dieExtent: dieP2,
                          gap: diceGap,
                          revealBlind: state.isShowdown,
                          hideOpponentCup: !state.isShowdown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: gap),
            Expanded(
              flex: 2,
              child: _CurrentBidBox(
                bid: state.currentBid,
                currentTurn: state.currentTurn,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SeatLabel extends StatelessWidget {
  const _SeatLabel({
    required this.label,
    required this.highlight,
  });

  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(
          Icons.person_outline,
          size: Theme.of(context).textTheme.titleSmall?.fontSize ?? 16,
          color: highlight ? scheme.secondary : scheme.onSurfaceVariant,
        ),
        SizedBox(width: AdaptiveLayout.inlineGap(context) * 0.6),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: highlight ? scheme.secondary : scheme.onSurfaceVariant,
                fontWeight: highlight ? FontWeight.w700 : FontWeight.w600,
                letterSpacing: 0.4,
              ),
        ),
      ],
    );
  }
}

/// Card-style readout of the bid on the table (empty at round start).
class _CurrentBidBox extends StatelessWidget {
  const _CurrentBidBox({
    required this.bid,
    required this.currentTurn,
  });

  final BidModel? bid;
  final CupPlayerId currentTurn;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final activeBid = bid;
    final hasBid = activeBid != null;
    final isYourTurn = currentTurn == CupPlayerId.p1;

    final borderColor = !hasBid
        ? scheme.outlineVariant
        : isYourTurn
            ? scheme.secondary.withValues(alpha: 0.75)
            : scheme.outline;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: hasBid && isYourTurn ? 2 : 1.5),
      ),
      child: Padding(
        padding: AdaptiveLayout.panelPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Current bid',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.6),
            if (!hasBid)
              Expanded(
                child: Center(
                  child: Text(
                    'No bid yet',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              )
            else ...[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _BidValueColumn(
                        label: 'Quantity',
                        hint: 'How many dice',
                        value: '${activeBid.quantity}',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AdaptiveLayout.inlineGap(context) * 0.35,
                      ),
                      child: Text(
                        '×',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w300,
                            ),
                      ),
                    ),
                    Expanded(
                      child: _BidValueColumn(
                        label: 'Face',
                        hint: 'Pip value',
                        value: '${activeBid.faceValue}',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                activeBid.playerId == CupPlayerId.p1 ? 'You bid' : 'Opponent bid',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Bottom rail: label, dice, and actions on one line.
class _PlayerRail extends StatelessWidget {
  const _PlayerRail({
    required this.state,
    required this.onRaiseBid,
  });

  final BluffMatchState state;
  final VoidCallback onRaiseBid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gap = AdaptiveLayout.inlineGap(context);
    final diceGap = AdaptiveLayout.bluffCupDiceGap(context);
    final railRadius = AdaptiveLayout.bluffCupRailRadius(context);
    final panelPad = AdaptiveLayout.panelPadding(context);

    final canAct = state.currentTurn == CupPlayerId.p1 &&
        !state.isShowdown &&
        !state.showRoundOpenerOverlay &&
        state.matchWinner == null;
    final canCatch = canAct &&
        state.currentBid != null &&
        state.currentBid!.playerId == CupPlayerId.p2;

    final railColor = Color.lerp(
      scheme.surfaceContainerHigh,
      Colors.brown.shade900,
      0.45,
    )!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final dieP1 = AdaptiveLayout.bluffCupDieExtentForRow(
          context: context,
          rowMaxWidth: constraints.maxWidth * 0.45,
          rowMaxHeight: constraints.maxHeight,
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: railColor,
            borderRadius: BorderRadius.circular(railRadius),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: panelPad.left,
              vertical: panelPad.top * 0.65,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SeatLabel(
                  label: 'Your cup',
                  highlight: canAct,
                ),
                SizedBox(width: gap),
                _DiceRow(
                  dice: state.p1Dice,
                  dieExtent: dieP1,
                  gap: diceGap,
                  revealBlind: state.isShowdown,
                  hideOpponentCup: false,
                ),
                const Spacer(),
                if (canAct) ...[
                  FilledButton.icon(
                    onPressed: onRaiseBid,
                    icon: const Icon(Icons.trending_up, size: 20),
                    label: const Text('Raise Bid'),
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.symmetric(
                        horizontal: gap,
                        vertical: gap * 0.65,
                      ),
                    ),
                  ),
                  if (canCatch) ...[
                    SizedBox(width: gap),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.read<BluffMatchCubit>().callCatch(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: scheme.secondary,
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.symmetric(
                          horizontal: gap,
                          vertical: gap * 0.65,
                        ),
                        side: BorderSide(
                          color: scheme.secondary.withValues(alpha: 0.85),
                        ),
                      ),
                      icon: const Icon(Icons.gavel_outlined, size: 20),
                      label: const Text('Catch'),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DiceRow extends StatelessWidget {
  const _DiceRow({
    required this.dice,
    required this.dieExtent,
    required this.gap,
    required this.revealBlind,
    required this.hideOpponentCup,
  });

  final List<DiceModel> dice;
  final double dieExtent;
  final double gap;
  final bool revealBlind;
  final bool hideOpponentCup;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < dice.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          CupDieWidget(
            die: dice[i],
            extent: dieExtent,
            revealBlind: revealBlind,
            forceHidden: hideOpponentCup,
          ),
        ],
      ],
    );
  }
}

/// Brief banner at the start of each round: who bids first.
class _RoundOpenerOverlay extends StatefulWidget {
  const _RoundOpenerOverlay({required this.state, super.key});

  final BluffMatchState state;

  @override
  State<_RoundOpenerOverlay> createState() => _RoundOpenerOverlayState();
}

class _RoundOpenerOverlayState extends State<_RoundOpenerOverlay> {
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _dismissTimer = Timer(AdaptiveLayout.bluffCupRoundOpenerDuration(), () {
      if (!mounted) {
        return;
      }
      context.read<BluffMatchCubit>().dismissRoundOpenerOverlay();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final opener = widget.state.currentTurn;
    final round = widget.state.currentRoundIndex + 1;
    final youOpen = opener == CupPlayerId.p1;

    return Material(
      color: Colors.black.withValues(alpha: 0.72),
      child: Center(
        child: Padding(
          padding: AdaptiveLayout.screenPadding(context),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                youOpen ? Icons.play_arrow_rounded : Icons.hourglass_top_rounded,
                size: AdaptiveLayout.bluffCupShowdownIconSize(context),
                color: scheme.secondary,
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(context)),
              Text(
                'Round $round',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AdaptiveLayout.inlineGap(context)),
              Text(
                youOpen ? 'You bid first' : 'Opponent bids first',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scheme.secondary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Post-round overlay: result text + both cups revealed, then auto-advance.
class _RoundResultOverlay extends StatefulWidget {
  const _RoundResultOverlay({required this.state, super.key});

  final BluffMatchState state;

  @override
  State<_RoundResultOverlay> createState() => _RoundResultOverlayState();
}

class _RoundResultOverlayState extends State<_RoundResultOverlay> {
  Timer? _phaseTimer;
  bool _showGameOver = false;

  BluffMatchState get state => widget.state;

  @override
  void initState() {
    super.initState();
    _schedulePhaseEnd(AdaptiveLayout.bluffCupRoundRevealDuration());
  }

  void _schedulePhaseEnd(Duration delay) {
    _phaseTimer?.cancel();
    _phaseTimer = Timer(delay, _onPhaseEnd);
  }

  void _onPhaseEnd() {
    if (!mounted) {
      return;
    }
    final matchW = state.matchWinner;
    if (matchW != null && !_showGameOver) {
      setState(() => _showGameOver = true);
      _schedulePhaseEnd(AdaptiveLayout.bluffCupMatchGameOverDuration());
      return;
    }
    context.read<BluffMatchCubit>().nextRound();
  }

  @override
  void dispose() {
    _phaseTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gap = AdaptiveLayout.sectionGap(context);
    final inline = AdaptiveLayout.inlineGap(context);
    final matchW = state.matchWinner;
    final roundWinner = state.winner ?? matchW ?? CupPlayerId.p1;
    final p1Wins =
        BluffMatchRules.countWins(state.roundResults, CupPlayerId.p1);
    final p2Wins =
        BluffMatchRules.countWins(state.roundResults, CupPlayerId.p2);

    final countdownSeconds = _showGameOver
        ? AdaptiveLayout.bluffCupMatchGameOverDuration().inSeconds
        : AdaptiveLayout.bluffCupRoundRevealDuration().inSeconds;
    final countdownLabel = _showGameOver
        ? 'New match in $countdownSeconds seconds…'
        : (matchW != null
            ? 'Game over in $countdownSeconds seconds…'
            : 'Next round in $countdownSeconds seconds…');

    if (_showGameOver && matchW != null) {
      return _MatchGameOverOverlay(
        matchWinner: matchW,
        playerWins: p1Wins,
        opponentWins: p2Wins,
        opponentDice: state.p2Dice,
        playerDice: state.p1Dice,
        countdownLabel: countdownLabel,
      );
    }

    return Material(
      color: Colors.black.withValues(alpha: 0.82),
      child: SafeArea(
        child: Padding(
          padding: AdaptiveLayout.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              LayoutBuilder(
                builder: (context, constraints) {
                  return _RoundResultRevealPanel(
                    maxWidth: constraints.maxWidth,
                    maxHeight: constraints.maxHeight,
                    roundNumber: state.currentRoundIndex + 1,
                    roundWinner: roundWinner,
                    opponentDice: state.p2Dice,
                    playerDice: state.p1Dice,
                    opponentWins: p2Wins,
                    playerWins: p1Wins,
                  );
                },
              ),
              SizedBox(height: gap),
              Text(
                countdownLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
              SizedBox(height: inline),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown after the 4th round win: match is over before a new game starts.
class _MatchGameOverOverlay extends StatelessWidget {
  const _MatchGameOverOverlay({
    required this.matchWinner,
    required this.playerWins,
    required this.opponentWins,
    required this.opponentDice,
    required this.playerDice,
    required this.countdownLabel,
  });

  final CupPlayerId matchWinner;
  final int playerWins;
  final int opponentWins;
  final List<DiceModel> opponentDice;
  final List<DiceModel> playerDice;
  final String countdownLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inline = AdaptiveLayout.inlineGap(context);
    final pad = AdaptiveLayout.panelPadding(context);
    final radius = AdaptiveLayout.bluffCupRailRadius(context);
    final youWon = matchWinner == CupPlayerId.p1;
    final opponentWon = !youWon;

    return Material(
      color: Colors.black.withValues(alpha: 0.88),
      child: SafeArea(
        child: Padding(
          padding: AdaptiveLayout.screenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: inline * 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_cafe_outlined,
                    size: AdaptiveLayout.bluffCupGameOverIconSize(context),
                    color: scheme.secondary,
                  ),
                  SizedBox(width: inline * 0.45),
                  Text(
                    'Game over',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
              SizedBox(height: inline),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final rowH = (constraints.maxHeight - inline * 5)
                        .clamp(inline * 4, inline * 6.5);
                    final dieExtent =
                        AdaptiveLayout.bluffCupResultDieExtentForRow(
                      context: context,
                      rowMaxWidth: constraints.maxWidth * 0.55,
                      rowMaxHeight: rowH,
                    );
                    final headerStyle =
                        Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                            );

                    return DecoratedBox(
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHigh.withValues(alpha: 0.92),
                        borderRadius: BorderRadius.circular(radius),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Padding(
                        padding: pad,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: inline * 0.5),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 26,
                                    child: Text('Player', style: headerStyle),
                                  ),
                                  Expanded(
                                    flex: 54,
                                    child: Text(
                                      'Final dice',
                                      style: headerStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 20,
                                    child: Text(
                                      'Wins',
                                      style: headerStyle,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              height: inline * 0.5,
                              color: scheme.outlineVariant,
                            ),
                            if (opponentWon) ...[
                              const _MatchWinnerLabel(),
                              SizedBox(height: inline * 0.3),
                            ],
                            _ResultPlayerTableRow(
                              playerLabel: 'Opponent',
                              dice: opponentDice,
                              dieExtent: dieExtent,
                              totalWins: opponentWins,
                              isRoundWinner: opponentWon,
                              rowHeight: rowH,
                            ),
                            SizedBox(height: inline * 0.45),
                            if (!opponentWon) ...[
                              const _MatchWinnerLabel(),
                              SizedBox(height: inline * 0.3),
                            ],
                            _ResultPlayerTableRow(
                              playerLabel: 'You',
                              dice: playerDice,
                              dieExtent: dieExtent,
                              totalWins: playerWins,
                              isRoundWinner: youWon,
                              rowHeight: rowH,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: inline),
              Text(
                countdownLabel,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MatchWinnerLabel extends StatelessWidget {
  const _MatchWinnerLabel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inline = AdaptiveLayout.inlineGap(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.emoji_events_outlined,
          size: Theme.of(context).textTheme.labelLarge?.fontSize ?? 14,
          color: scheme.secondary,
        ),
        SizedBox(width: inline * 0.35),
        Text(
          'Match winner',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.secondary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

/// Round result: player status table; winner row marked below a small label.
class _RoundResultRevealPanel extends StatelessWidget {
  const _RoundResultRevealPanel({
    required this.maxWidth,
    required this.maxHeight,
    required this.roundNumber,
    required this.roundWinner,
    required this.opponentDice,
    required this.playerDice,
    required this.opponentWins,
    required this.playerWins,
  });

  final double maxWidth;
  final double maxHeight;
  final int roundNumber;
  final CupPlayerId roundWinner;
  final List<DiceModel> opponentDice;
  final List<DiceModel> playerDice;
  final int opponentWins;
  final int playerWins;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inline = AdaptiveLayout.inlineGap(context);
    final pad = AdaptiveLayout.panelPadding(context);
    final radius = AdaptiveLayout.bluffCupRailRadius(context);
    final headerStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        );

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: scheme.secondary.withValues(alpha: 0.65),
              width: AdaptiveLayout.bluffCupFeltBorderWidth(context) * 1.5,
            ),
          ),
          child: Padding(
            padding: pad,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final rowH =
                    (constraints.maxHeight - inline * 8).clamp(inline * 4, inline * 7);
                final diceColWidth = constraints.maxWidth * 0.58;
                final dieExtent = AdaptiveLayout.bluffCupResultDieExtentForRow(
                  context: context,
                  rowMaxWidth: diceColWidth,
                  rowMaxHeight: rowH,
                );

                final opponentWon = roundWinner == CupPlayerId.p2;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Round $roundNumber',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: inline),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: inline * 0.25),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 28,
                            child: Text('Player', style: headerStyle),
                          ),
                          Expanded(
                            flex: 52,
                            child: Text(
                              'This round',
                              style: headerStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: Text(
                              'Wins',
                              style: headerStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: inline, color: scheme.outlineVariant),
                    if (opponentWon) ...[
                      const _ThisRoundWinnerLabel(),
                      SizedBox(height: inline * 0.35),
                    ],
                    _ResultPlayerTableRow(
                      playerLabel: 'Opponent',
                      dice: opponentDice,
                      dieExtent: dieExtent,
                      totalWins: opponentWins,
                      isRoundWinner: opponentWon,
                      rowHeight: rowH,
                    ),
                    SizedBox(height: inline * 0.5),
                    if (!opponentWon) ...[
                      const _ThisRoundWinnerLabel(),
                      SizedBox(height: inline * 0.35),
                    ],
                    _ResultPlayerTableRow(
                      playerLabel: 'You',
                      dice: playerDice,
                      dieExtent: dieExtent,
                      totalWins: playerWins,
                      isRoundWinner: !opponentWon,
                      rowHeight: rowH,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Label above the bordered winner row on the result table.
class _ThisRoundWinnerLabel extends StatelessWidget {
  const _ThisRoundWinnerLabel();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inline = AdaptiveLayout.inlineGap(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.local_cafe_outlined,
          size: AdaptiveLayout.bluffCupChipIconSize(context),
          color: scheme.secondary,
        ),
        SizedBox(width: inline * 0.45),
        Text(
          "This round's winner",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: scheme.secondary,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

/// One row in the round-result player table.
class _ResultPlayerTableRow extends StatelessWidget {
  const _ResultPlayerTableRow({
    required this.playerLabel,
    required this.dice,
    required this.dieExtent,
    required this.totalWins,
    required this.isRoundWinner,
    required this.rowHeight,
  });

  final String playerLabel;
  final List<DiceModel> dice;
  final double dieExtent;
  final int totalWins;
  final bool isRoundWinner;
  final double rowHeight;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final inline = AdaptiveLayout.inlineGap(context);
    final diceGap = AdaptiveLayout.bluffCupDiceGap(context);
    final radius = AdaptiveLayout.bluffCupRailRadius(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isRoundWinner
            ? scheme.secondaryContainer.withValues(alpha: 0.28)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(radius * 0.8),
        border: isRoundWinner
            ? Border.all(color: scheme.secondary.withValues(alpha: 0.55))
            : null,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: inline * 0.35,
          vertical: inline * 0.4,
        ),
        child: SizedBox(
          height: rowHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 28,
                child: Text(
                  playerLabel,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isRoundWinner
                            ? scheme.secondary
                            : scheme.onSurface,
                      ),
                ),
              ),
              Expanded(
                flex: 52,
                child: Center(
                  child: _DiceRow(
                    dice: dice,
                    dieExtent: dieExtent,
                    gap: diceGap,
                    revealBlind: true,
                    hideOpponentCup: false,
                  ),
                ),
              ),
              Expanded(
                flex: 20,
                child: _ResultWinsCell(count: totalWins),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Total round wins for one player (count only; column header labels the column).
class _ResultWinsCell extends StatelessWidget {
  const _ResultWinsCell({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$count',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.05,
            ),
      ),
    );
  }
}

class _BidValueColumn extends StatelessWidget {
  const _BidValueColumn({
    required this.label,
    required this.hint,
    required this.value,
  });

  final String label;
  final String hint;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.25),
        Text(
          hint,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
              ),
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.35),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: scheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ],
    );
  }
}

/// Upper-half panel to raise a bid (timer stays on the main app bar).
class _RaiseBidOverlay extends StatefulWidget {
  const _RaiseBidOverlay({required this.onClose});

  final VoidCallback onClose;

  @override
  State<_RaiseBidOverlay> createState() => _RaiseBidOverlayState();
}

class _RaiseBidOverlayState extends State<_RaiseBidOverlay> {
  late int _quantity;
  late int _faceValue;
  late BidModel? _tableBid;
  late List<({int quantity, int faceValue})> _legalBids;

  @override
  void initState() {
    super.initState();
    _syncFromState(context.read<BluffMatchCubit>().state);
  }

  void _syncFromState(BluffMatchState state) {
    _tableBid = state.currentBid;
    _legalBids = BluffEvaluator.legalNextBids(currentBid: _tableBid);
    final first = _legalBids.first;
    _quantity = first.quantity;
    _faceValue = first.faceValue;
  }

  List<int> get _quantityChoices {
    final set = <int>{};
    for (final b in _legalBids) {
      set.add(b.quantity);
    }
    final list = set.toList()..sort();
    return list;
  }

  List<int> _faceChoicesForQuantity(int quantity) {
    final faces = <int>[];
    for (final b in _legalBids) {
      if (b.quantity == quantity) {
        faces.add(b.faceValue);
      }
    }
    faces.sort();
    return faces;
  }

  bool _isValidBid(int face) => BluffEvaluator.isValidNextBid(
        currentBid: _tableBid,
        newQuantity: _quantity,
        newFaceValue: face,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pad = AdaptiveLayout.screenPadding(context);
    final inline = AdaptiveLayout.inlineGap(context);

    final denseDecoration = InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: inline,
        vertical: inline * 0.65,
      ),
      border: const OutlineInputBorder(),
      filled: true,
      fillColor: scheme.surface.withValues(alpha: 0.4),
    );

    final cubit = context.read<BluffMatchCubit>();

    final faceChoices = _faceChoicesForQuantity(_quantity);
    final effectiveFace =
        faceChoices.contains(_faceValue) ? _faceValue : faceChoices.first;
    final valid = _isValidBid(effectiveFace);

    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomClearance =
            AdaptiveLayout.bluffCupRaiseBidBottomClearance(context);
        final panelHeight = MediaQuery.sizeOf(context).height *
            AdaptiveLayout.bluffCupRaiseBidPanelScreenHeightFraction();
        final spaceAboveRail = constraints.maxHeight - bottomClearance;
        final topOffset = spaceAboveRail >= panelHeight
            ? 0.0
            : spaceAboveRail - panelHeight;

        return Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: bottomClearance,
              child: ColoredBox(
                color: Colors.black.withValues(alpha: 0.55),
              ),
            ),
            Positioned(
              top: topOffset,
              left: 0,
              right: 0,
              height: panelHeight,
              child: Material(
                color: scheme.surfaceContainerHigh,
                elevation: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                  Padding(
                    padding: EdgeInsets.only(left: pad.left * 0.25),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: widget.onClose,
                          tooltip: 'Close',
                        ),
                        Expanded(
                          child: Text(
                            'Raise bid',
                            style: Theme.of(context).textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: AdaptiveLayout.hubIconExtent(context)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: pad.left),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _CompactBidDropdown<int>(
                                  label: 'Quantity',
                                  hint: 'How many dice',
                                  value: _quantity,
                                  items: _quantityChoices,
                                  itemLabel: (v) => '$v',
                                  decoration: denseDecoration,
                                  onChanged: (v) {
                                    if (v == null) {
                                      return;
                                    }
                                    final faces = _faceChoicesForQuantity(v);
                                    setState(() {
                                      _quantity = v;
                                      _faceValue = faces.contains(_faceValue)
                                          ? _faceValue
                                          : faces.first;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: inline),
                              Expanded(
                                child: _CompactBidDropdown<int>(
                                  label: 'Face',
                                  hint: 'Pip value',
                                  value: effectiveFace,
                                  items: faceChoices,
                                  itemLabel: (v) => '$v',
                                  decoration: denseDecoration,
                                  onChanged: (v) {
                                    if (v != null) {
                                      setState(() => _faceValue = v);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: pad,
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: valid
                            ? () {
                                cubit.placeBid(_quantity, effectiveFace);
                                widget.onClose();
                              }
                            : null,
                        child: const Text('Confirm bid'),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _CompactBidDropdown<T> extends StatelessWidget {
  const _CompactBidDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.decoration,
    required this.onChanged,
  });

  final String label;
  final String hint;
  final T value;
  final List<T> items;
  final String Function(T) itemLabel;
  final InputDecoration decoration;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.45),
        InputDecorator(
          decoration: decoration,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              isExpanded: true,
              isDense: true,
              value: items.contains(value) ? value : null,
              hint: Text(hint),
              borderRadius: BorderRadius.circular(8),
              items: [
                for (final v in items)
                  DropdownMenuItem<T>(
                    value: v,
                    child: Text(itemLabel(v)),
                  ),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
