import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_betting.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_cubit.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_match_state.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_match_ui_state.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/blind_bluff_skills.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/logic/showdown_comparator.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/models/blind_card.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/models/player_id.dart';
import 'package:genius_project/games/blind_bluff_fatal_fold/ui/joker_card_logo.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';

const Color _kFelt = Color(0xFF123B2D);
const Color _kRail = AppTheme.neoBackground;
const Color _kGold = AppTheme.neoGold;
const Color _kAccent = Color(0xFF8B2942);
const Color _kSkillButtonBg = Color(0xFF1A1A24);

/// Blind Bluff: Fatal Fold — dark table, phased intro (ante → deal → skills 10s).
class BlindBluffScreen extends StatelessWidget {
  const BlindBluffScreen({
    super.key,
    this.cubit,
  });

  final BlindBluffCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const child = _BlindBluffScaffold();

    if (cubit != null) {
      return BlocProvider<BlindBluffCubit>.value(
        value: cubit!,
        child: child,
      );
    }
    return BlocProvider<BlindBluffCubit>(
      create: (_) => BlindBluffCubit(),
      child: child,
    );
  }
}

enum _IntroVisual { idle, ante, yourReveal, opponentReveal }

class _BlindBluffScaffold extends StatefulWidget {
  const _BlindBluffScaffold();

  @override
  State<_BlindBluffScaffold> createState() => _BlindBluffScaffoldState();
}

class _BlindBluffScaffoldState extends State<_BlindBluffScaffold> {
  _IntroVisual _introVisual = _IntroVisual.idle;
  int? _introStartedForRound;

  Timer? _firstMoveBannerTimer;
  int? _firstMoveBannerScheduledForRound;
  bool _showFirstMoveBanner = false;

  Timer? _opponentBettingBannerTimer;
  bool _showOpponentBettingBanner = false;
  _OpponentBettingBannerKind? _opponentBettingBannerKind;
  int? _opponentBettingBannerRaiseChips;

  Timer? _anteDoubledBannerTimer;
  int? _anteDoubledBannerScheduledForRound;
  bool _showAnteDoubledBanner = false;
  int? _anteDoubledBannerFrom;
  int? _anteDoubledBannerTo;

  /// Avoid showing the match-end hand dialog twice for the same round.
  int? _terminalHandPopupShownForRound;

  Future<void> _runRoundIntro(BlindBluffCubit cubit) async {
    if (!mounted) {
      return;
    }
    setState(() => _introVisual = _IntroVisual.ante);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) {
      return;
    }
    setState(() => _introVisual = _IntroVisual.yourReveal);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) {
      return;
    }
    setState(() => _introVisual = _IntroVisual.opponentReveal);
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    if (!mounted) {
      return;
    }
    setState(() => _introVisual = _IntroVisual.idle);
    cubit.notifySkillIntroComplete();
  }

  /// Runs [_runRoundIntro] once per [roundNumber] while the cubit still awaits intro.
  void _ensureIntroScheduled(BuildContext context, int roundNumber) {
    if (!context.mounted) {
      return;
    }
    if (_introStartedForRound == roundNumber) {
      return;
    }
    final live = context
        .read<BlindBluffCubit>()
        .state
        .mapOrNull(staredownPhase: (s) => s);
    if (live == null ||
        !live.awaitingIntroSequence ||
        live.roundNumber != roundNumber) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_introStartedForRound == roundNumber) {
        return;
      }
      final s = context
          .read<BlindBluffCubit>()
          .state
          .mapOrNull(staredownPhase: (x) => x);
      if (s == null ||
          !s.awaitingIntroSequence ||
          s.roundNumber != roundNumber) {
        return;
      }
      _introStartedForRound = roundNumber;
      _runRoundIntro(context.read<BlindBluffCubit>());
    });
  }

  /// One-second toast when betting opens: who acts first (random round 1, then alternates).
  void _ensureFirstMoveBannerScheduled(int roundNumber) {
    if (_firstMoveBannerScheduledForRound == roundNumber) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_firstMoveBannerScheduledForRound == roundNumber) {
        return;
      }
      final b = context
          .read<BlindBluffCubit>()
          .state
          .mapOrNull(bettingPhase: (x) => x);
      if (b == null || b.roundNumber != roundNumber) {
        return;
      }
      _firstMoveBannerScheduledForRound = roundNumber;
      _firstMoveBannerTimer?.cancel();
      setState(() => _showFirstMoveBanner = true);
      _firstMoveBannerTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted) {
          return;
        }
        setState(() => _showFirstMoveBanner = false);
      });
    });
  }

  /// One-second toast when the shoe recycles and ante doubles.
  void _ensureAnteDoubledBannerScheduled({
    required int roundNumber,
    required int from,
    required int to,
  }) {
    if (_anteDoubledBannerScheduledForRound == roundNumber) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_anteDoubledBannerScheduledForRound == roundNumber) {
        return;
      }
      _anteDoubledBannerScheduledForRound = roundNumber;
      _anteDoubledBannerTimer?.cancel();
      setState(() {
        _showAnteDoubledBanner = true;
        _anteDoubledBannerFrom = from;
        _anteDoubledBannerTo = to;
      });
      _anteDoubledBannerTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted) {
          return;
        }
        setState(() => _showAnteDoubledBanner = false);
      });
    });
  }

  /// Full-screen banner (matches [_FirstMoveOrderOverlay]) when opponent checks or raises.
  void _scheduleOpponentBettingBanner({
    required _OpponentBettingBannerKind kind,
    int? raiseChips,
  }) {
    if (kind == _OpponentBettingBannerKind.raise &&
        (raiseChips == null || raiseChips <= 0)) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _opponentBettingBannerTimer?.cancel();
      setState(() {
        _showOpponentBettingBanner = true;
        _opponentBettingBannerKind = kind;
        _opponentBettingBannerRaiseChips = raiseChips;
      });
      _opponentBettingBannerTimer = Timer(const Duration(seconds: 1), () {
        if (!mounted) {
          return;
        }
        setState(() => _showOpponentBettingBanner = false);
      });
    });
  }

  @override
  void dispose() {
    _firstMoveBannerTimer?.cancel();
    _opponentBettingBannerTimer?.cancel();
    _anteDoubledBannerTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final s =
        context.read<BlindBluffCubit>().state.mapOrNull(staredownPhase: (x) => x);
    if (s != null && s.awaitingIntroSequence) {
      _ensureIntroScheduled(context, s.roundNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blind Bluff: Fatal Fold'),
        centerTitle: true,
      ),
      body: BlocListener<BlindBluffCubit, BlindBluffMatchState>(
        listenWhen: (prev, curr) {
          final sd = curr.mapOrNull(showdown: (s) => s);
          if (sd != null && sd.matchCompletePending) {
            final prevSd = prev.mapOrNull(showdown: (s) => s);
            return prevSd == null || !prevSd.matchCompletePending;
          }
          final go = curr.mapOrNull(gameOver: (g) => g);
          if (go?.terminalRoundResolution != null) {
            return prev.mapOrNull(gameOver: (g) => g) == null;
          }
          return false;
        },
        listener: (context, state) {
          final sd = state.mapOrNull(showdown: (s) => s);
          final go = state.mapOrNull(gameOver: (g) => g);
          final resolution = sd?.resolution ?? go?.terminalRoundResolution;
          final roundNumber = sd?.roundNumber ?? go?.terminalRoundNumber;
          final matchComplete = sd?.matchCompletePending == true ||
              go?.terminalRoundResolution != null;
          if (!matchComplete || resolution == null || roundNumber == null) {
            return;
          }
          if (_terminalHandPopupShownForRound == roundNumber) {
            return;
          }
          _terminalHandPopupShownForRound = roundNumber;
          final BlindBluffPlayerId winner;
          if (go != null) {
            winner = go.winner;
          } else {
            winner = resolution.map(
              fold: (f) => f.potWinner,
              showdown: (s) => switch (s.outcome) {
                ShowdownOutcome.playerOneWins => BlindBluffPlayerId.playerOne,
                ShowdownOutcome.playerTwoWins => BlindBluffPlayerId.playerTwo,
                ShowdownOutcome.tie => BlindBluffPlayerId.playerTwo,
              },
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!context.mounted) {
              return;
            }
            await _showGameOverTerminalHandPopup(
              context: context,
              winner: winner,
              resolution: resolution,
              roundNumber: roundNumber,
            );
            if (!context.mounted) {
              return;
            }
            final cubit = context.read<BlindBluffCubit>();
            if (cubit.state.mapOrNull(showdown: (_) => true) != null) {
              cubit.advanceFromShowdown();
            }
          });
        },
        child: BlocBuilder<BlindBluffCubit, BlindBluffMatchState>(
          builder: (context, state) {
              return state.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: _kGold),
            ),
            staredownPhase: (
              roundNumber,
              playerChips,
              opponentChips,
              pot,
              baseAnteFrozenForRound,
              opponentCard,
              playerCard,
              playerSkillsRemaining,
              opponentSkillsRemaining,
              playerLockedSkill,
              opponentLockedSkill,
              awaitingIntroSequence,
              skillReflectionSecondsRemaining,
              awaitingSkillRevealAnimation,
              revealedPlayerSkill,
              revealedOpponentSkill,
              secondsRemaining,
              _,
              anteDoubledFrom,
              anteDoubledTo,
            ) {
              final cubit = context.read<BlindBluffCubit>();
              if (anteDoubledFrom != null && anteDoubledTo != null) {
                _ensureAnteDoubledBannerScheduled(
                  roundNumber: roundNumber,
                  from: anteDoubledFrom,
                  to: anteDoubledTo,
                );
              }
              if (awaitingIntroSequence) {
                _ensureIntroScheduled(context, roundNumber);
              }
              final skillPhaseCountdown = skillReflectionSecondsRemaining > 0
                  ? skillReflectionSecondsRemaining
                  : secondsRemaining;
              final feltPhaseLabel = awaitingIntroSequence
                  ? _introPhaseLabel()
                  : awaitingSkillRevealAnimation
                      ? 'Skills revealed'
                      : 'Skills (${skillPhaseCountdown}s)';
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: _FeltTable(
                          roundNumber: roundNumber,
                          phaseLabel: feltPhaseLabel,
                          playerChips: playerChips,
                          opponentChips: opponentChips,
                          pot: pot,
                          baseAnte: baseAnteFrozenForRound,
                          opponentCard: opponentCard,
                          hideOpponentCard: false,
                          secondsRemaining: skillPhaseCountdown,
                          timerActive: !awaitingIntroSequence &&
                              !awaitingSkillRevealAnimation &&
                              !playerLockedSkill,
                          playerSkillsRemaining: playerSkillsRemaining,
                          opponentSkillsRemaining: opponentSkillsRemaining,
                          introVisual: awaitingIntroSequence
                              ? _introVisual
                              : _IntroVisual.idle,
                        ),
                      ),
                      _StaredownPanel(
                        cubit: cubit,
                        awaitingIntro: awaitingIntroSequence,
                        skillReflectionSecondsRemaining:
                            skillReflectionSecondsRemaining,
                        skillDeclareSecondsRemaining: secondsRemaining,
                        awaitingSkillReveal: awaitingSkillRevealAnimation,
                        playerSkillsRemaining: playerSkillsRemaining,
                        locked: playerLockedSkill,
                        opponentLocked: opponentLockedSkill,
                        enabled: !awaitingIntroSequence &&
                            !awaitingSkillRevealAnimation,
                      ),
                    ],
                  ),
                  if (awaitingSkillRevealAnimation)
                    Positioned.fill(
                      child: _SkillRevealOverlay(
                        you: revealedPlayerSkill,
                        opponentSkill: revealedOpponentSkill,
                      ),
                    ),
                  if (_showAnteDoubledBanner &&
                      _anteDoubledBannerFrom != null &&
                      _anteDoubledBannerTo != null)
                    Positioned.fill(
                      child: _AnteDoubledOverlay(
                        from: _anteDoubledBannerFrom!,
                        to: _anteDoubledBannerTo!,
                      ),
                    ),
                ],
              );
            },
            bettingPhase: (
              roundNumber,
              playerChips,
              opponentChips,
              pot,
              baseAnteFrozenForRound,
              opponentCard,
              playerCard,
              betting,
              chipsToCallPlayer,
              _,
              __,
              secondsRemaining,
              actionLog,
              playerSkillsRemaining,
              opponentSkillsRemaining,
              opponentRaiseNoticeChips,
              opponentCheckNotice,
            ) {
              Object.hashAll(actionLog);
              _ensureFirstMoveBannerScheduled(roundNumber);
              final bump = opponentRaiseNoticeChips;
              if (bump != null && bump > 0) {
                _scheduleOpponentBettingBanner(
                  kind: _OpponentBettingBannerKind.raise,
                  raiseChips: bump,
                );
              } else if (opponentCheckNotice) {
                _scheduleOpponentBettingBanner(
                  kind: _OpponentBettingBannerKind.check,
                );
              }
              final humanTurn = !betting.isClosed &&
                  betting.actingPlayer == BlindBluffPlayerId.playerOne;
              final bettingUnlocked = humanTurn &&
                  !_showFirstMoveBanner &&
                  !_showOpponentBettingBanner;
              return Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: _FeltTable(
                          roundNumber: roundNumber,
                          phaseLabel: 'Betting',
                          playerChips: playerChips,
                          opponentChips: opponentChips,
                          pot: pot,
                          baseAnte: baseAnteFrozenForRound,
                          opponentCard: opponentCard,
                          hideOpponentCard: false,
                          secondsRemaining: secondsRemaining,
                          timerActive: bettingUnlocked,
                          playerSkillsRemaining: playerSkillsRemaining,
                          opponentSkillsRemaining: opponentSkillsRemaining,
                          introVisual: _IntroVisual.idle,
                        ),
                      ),
                      _BettingPanel(
                        cubit: context.read<BlindBluffCubit>(),
                        chipsToCall: chipsToCallPlayer,
                        minRaise: betting.minRaise,
                        playerChips: playerChips,
                        playerContribution: betting.contributionPlayerOne,
                        opponentChips: opponentChips,
                        opponentContribution: betting.contributionPlayerTwo,
                        firstToAct: betting.firstToAct,
                        enabled: bettingUnlocked,
                      ),
                    ],
                  ),
                  if (_showFirstMoveBanner)
                    Positioned.fill(
                      child: _FirstMoveOrderOverlay(
                        firstToAct: betting.firstToAct,
                      ),
                    ),
                  if (_showOpponentBettingBanner &&
                      _opponentBettingBannerKind != null)
                    Positioned.fill(
                      child: _OpponentBettingActionOverlay(
                        kind: _opponentBettingBannerKind!,
                        raiseChips: _opponentBettingBannerRaiseChips,
                      ),
                    ),
                ],
              );
            },
            showdown: (
              roundNumber,
              resolution,
              playerChips,
              opponentChips,
              _,
              matchCompletePending,
            ) {
              if (matchCompletePending) {
                return const ColoredBox(color: _kFelt);
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 8),
                child: _ShowdownCard(
                  roundNumber: roundNumber,
                  resolution: resolution,
                  playerChips: playerChips,
                  opponentChips: opponentChips,
                ),
              );
            },
            gameOver: (
              winner,
              reason,
              __,
              ___,
              ____,
              _____,
            ) {
              final s = AdaptiveLayout.shortestSide(context);
              final pad = AdaptiveLayout.screenPadding(context);
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: pad,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              winner == BlindBluffPlayerId.playerOne
                                  ? Icons.emoji_events
                                  : Icons.sentiment_dissatisfied,
                              size: s * 0.11,
                              color: _kGold,
                            ),
                            SizedBox(
                              height: AdaptiveLayout.inlineGap(context) * 1.2,
                            ),
                            Text(
                              winner == BlindBluffPlayerId.playerOne
                                  ? 'You cleared the table'
                                  : 'Opponent took it all',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            SizedBox(
                              height: AdaptiveLayout.inlineGap(context) * 0.55,
                            ),
                            Text(
                              reason,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.fontSize,
                              ),
                            ),
                            SizedBox(
                              height: AdaptiveLayout.sectionGap(context),
                            ),
                            FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: _kGold,
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(
                                  horizontal: s * 0.09,
                                  vertical: s * 0.028,
                                ),
                              ),
                              onPressed: () =>
                                  Navigator.of(context).maybePop(),
                              child: const Text('Leave table'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        ),
      ),
    );
  }

  String _introPhaseLabel() {
    return switch (_introVisual) {
      _IntroVisual.ante => 'Ante — chips to pot',
      _IntroVisual.yourReveal => 'Your hole is dealt face-down',
      _IntroVisual.opponentReveal => 'Opponent’s card is shown to you',
      _IntroVisual.idle => 'Skills',
    };
  }
}

(BlindCard, BlindCard) _yourVsOpponentHoles(BlindBluffRoundResolution resolution) {
  return resolution.map(
    fold: (f) => (
      f.foldingPlayer == BlindBluffPlayerId.playerOne
          ? f.foldingPlayersCard
          : f.opponentsVisibleCard,
      f.foldingPlayer == BlindBluffPlayerId.playerOne
          ? f.opponentsVisibleCard
          : f.foldingPlayersCard,
    ),
    showdown: (s) => (s.playerOneCard, s.playerTwoCard),
  );
}

/// One line summarizing how each seat ended the betting street.
String _roundBettingActionLine(BlindBluffRoundResolution resolution) {
  return resolution.map(
    fold: (f) =>
        f.foldingPlayer == BlindBluffPlayerId.playerOne
            ? 'You folded · Opponent called'
            : 'Opponent folded · You called',
    showdown: (s) {
      if (s.outcome == ShowdownOutcome.tie) {
        return 'Both players called';
      }
      return 'You called · Opponent called';
    },
  );
}

Future<void> _showGameOverTerminalHandPopup({
  required BuildContext context,
  required BlindBluffPlayerId winner,
  required BlindBluffRoundResolution resolution,
  required int roundNumber,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      final mq = AdaptiveLayout.screenSize(dialogContext);
      final s = AdaptiveLayout.shortestSide(dialogContext);
      final maxW = math.min<double>(s * 0.9, mq.width * 0.92);
      final cardH =
          AdaptiveLayout.showdownCardHeight(maxW * 0.88, mq.height * 0.22);
      final holes = _yourVsOpponentHoles(resolution);
      final your = holes.$1;
      final opp = holes.$2;
      final subtitle = _roundBettingActionLine(resolution);
      final caption = Theme.of(dialogContext).textTheme.labelMedium?.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          );

      return AlertDialog(
        backgroundColor: _kRail,
        insetPadding: AdaptiveLayout.dialogInsets(dialogContext),
        title: Text(
          'Final hand · Round $roundNumber',
          textAlign: TextAlign.center,
          style:
              Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                    color: _kGold,
                    fontWeight: FontWeight.w700,
                  ),
        ),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Player card vs opponent card',
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(height: AdaptiveLayout.sectionGap(dialogContext)),
                Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Your card',
                                style: caption, textAlign: TextAlign.center),
                            SizedBox(
                                height: AdaptiveLayout.inlineGap(dialogContext)),
                            _PlayingCard(card: your, height: cardH),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AdaptiveLayout.inlineGap(dialogContext),
                            vertical: AdaptiveLayout.shortestSide(dialogContext) *
                                0.06,
                          ),
                          child: Text(
                            'vs',
                            style: Theme.of(dialogContext)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.white54),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Opponent's card",
                                style: caption, textAlign: TextAlign.center),
                            SizedBox(
                                height: AdaptiveLayout.inlineGap(dialogContext)),
                            _PlayingCard(card: opp, height: cardH),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AdaptiveLayout.sectionGap(dialogContext)),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.35,
                      ),
                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _kGold,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(
                horizontal: s * 0.08,
                vertical: AdaptiveLayout.inlineGap(dialogContext),
              ),
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

/// Pot + ante centered under the opponent up-card (stacks live on seat rows).
class _PotUnderOpponentCard extends StatelessWidget {
  const _PotUnderOpponentCard({
    required this.pot,
    required this.baseAnte,
    required this.tight,
  });

  final int pot;
  final int baseAnte;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    final baseFs = Theme.of(context).textTheme.labelMedium?.fontSize ?? 13;
    final fs = baseFs * (tight ? 0.88 : 1.0);
    final rowGap = AdaptiveLayout.blindBluffFeltPotRowElementGap(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.toll_rounded, color: _kGold, size: fs * 1.15),
            SizedBox(width: rowGap),
            Text(
              'POT',
              style: TextStyle(
                fontSize: fs * 0.72,
                color: Colors.amber.shade100,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(width: rowGap),
            _ChipAmountLabel(
              amount: pot,
              style: TextStyle(
                fontSize: fs * 1.12,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                height: 1.0,
              ),
            ),
          ],
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.22),
        _ChipAmountLabel(
          amount: baseAnte,
          prefix: 'Ante ',
          compact: tight,
          style: TextStyle(
            fontSize: fs * 0.8,
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Non-scrolling felt: flex layout + [LayoutBuilder] scales cards/pot to fit height.
class _FeltTable extends StatelessWidget {
  const _FeltTable({
    required this.roundNumber,
    required this.phaseLabel,
    required this.playerChips,
    required this.opponentChips,
    required this.pot,
    required this.baseAnte,
    required this.opponentCard,
    required this.hideOpponentCard,
    required this.secondsRemaining,
    required this.timerActive,
    required this.playerSkillsRemaining,
    required this.opponentSkillsRemaining,
    required this.introVisual,
  });

  final int roundNumber;
  final String phaseLabel;
  final int playerChips;
  final int opponentChips;
  final int pot;
  final int baseAnte;
  final BlindCard opponentCard;
  final bool hideOpponentCard;
  final int secondsRemaining;
  final bool timerActive;
  final Set<BlindBluffSkill> playerSkillsRemaining;
  final Set<BlindBluffSkill> opponentSkillsRemaining;
  final _IntroVisual introVisual;

  @override
  Widget build(BuildContext context) {
    final potBefore = (pot - 2 * baseAnte).clamp(0, pot);
    final displayPot =
        introVisual == _IntroVisual.ante ? potBefore : pot;

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
        final headerRow = Row(
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
                  AdaptiveLayout.blindBluffFeltRoundPillRadius(context),
                ),
              ),
              child: Text(
                'R$roundNumber',
                style: TextStyle(
                  color: _kGold,
                  fontWeight: FontWeight.w600,
                  fontSize:
                      Theme.of(context).textTheme.labelLarge?.fontSize,
                ),
              ),
            ),
            SizedBox(width: ig),
            Expanded(
              child: Text(
                phaseLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade100,
                  fontSize:
                      Theme.of(context).textTheme.labelLarge?.fontSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: AdaptiveLayout.blindBluffFeltHeaderTimerGap(context),
            ),
            _TimerPill(
              seconds: secondsRemaining,
              active: timerActive,
              compact: tight,
            ),
          ],
        );
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
                  headerRow,
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
                        final cardH = AdaptiveLayout.feltCornerCardHeight(
                          stackWidth: sw,
                          stackHeight: sh,
                          tightVerticalRegion: tight,
                        );
                        final ar = AdaptiveLayout.feltCornerAvatarRadius(
                          cornerBlockMaxWidth: cornerMax,
                          cardHeight: cardH,
                          stackHeight: sh,
                        );

                        final opponentCardWidget = hideOpponentCard
                            ? _CardBack(height: cardH)
                            : _PlayingCard(
                                card: opponentCard,
                                height: cardH,
                                faceUp: true,
                              );

                        final cardW =
                            cardH * AdaptiveLayout.blindBluffPlayingCardWidthRatio;

                        final playerSpent =
                            _spentSkillsOrdered(playerSkillsRemaining);
                        final opponentSpent =
                            _spentSkillsOrdered(opponentSkillsRemaining);

                        final labelFs =
                            Theme.of(context).textTheme.labelLarge?.fontSize ??
                                14.0;
                        final opponentCaptionH =
                            AdaptiveLayout.blindBluffFeltOpponentCaptionHeight(
                          labelFs,
                        );

                        final rawPotTop =
                            AdaptiveLayout.blindBluffFeltPotBandTop(
                          context: context,
                          stackEdge: edge,
                          opponentCaptionHeight: opponentCaptionH,
                          cardHeight: cardH,
                        );
                        final rawPotBottom =
                            AdaptiveLayout.blindBluffFeltPotBandBottom(
                          context: context,
                          stackEdge: edge,
                          avatarRadius: ar,
                        );
                        final midMin =
                            AdaptiveLayout.blindBluffFeltPotBandMidMinHeight(
                          context,
                        );
                        var potBandTop = rawPotTop;
                        var potBandBottom = rawPotBottom;
                        if (potBandTop + potBandBottom + midMin > sh) {
                          final denom = potBandTop + potBandBottom;
                          if (denom > 0) {
                            final scale = (sh - midMin) / denom;
                            potBandTop *= scale;
                            potBandBottom *= scale;
                          }
                        }
                        final potBlockMaxW =
                            AdaptiveLayout.blindBluffFeltPotBlockMaxWidth(
                          stackWidth: sw,
                          stackEdge: edge,
                          cornerBlockMax: cornerMax,
                        );
                        final cornerColumnMaxH =
                            AdaptiveLayout.blindBluffFeltCornerColumnMaxHeight(
                          sh,
                          tight,
                        );
                        final oppTopMaxH = AdaptiveLayout
                            .blindBluffFeltOpponentTopColumnMaxHeight(
                          sh,
                          tight,
                        );

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: edge,
                              left: edge,
                              right: edge,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.topCenter,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: math.max(0.0, sw - 2 * edge),
                                      maxHeight: oppTopMaxH,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Opponent card',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge
                                              ?.copyWith(
                                                color: Colors.amber.shade100,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(
                                          height: AdaptiveLayout
                                              .blindBluffFeltOpponentCaptionCardGap(
                                            context,
                                          ),
                                        ),
                                        SizedBox(
                                          width: cardW,
                                          child: opponentCardWidget,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: edge,
                              left: edge,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomLeft,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: cornerMax,
                                    maxHeight: cornerColumnMaxH,
                                  ),
                                  child: _FeltCornerIdentity(
                                    label: 'You',
                                    chips: playerChips,
                                    avatar: Icons.person_outline,
                                    avatarRadius: ar,
                                    alignEnd: false,
                                    spentSkills: playerSpent,
                                    tight: tight,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: edge,
                              right: edge,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.bottomRight,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: cornerMax,
                                    maxHeight: cornerColumnMaxH,
                                  ),
                                  child: _FeltCornerIdentity(
                                    label: 'Opponent',
                                    chips: opponentChips,
                                    avatar: Icons.person,
                                    avatarRadius: ar,
                                    alignEnd: true,
                                    spentSkills: opponentSpent,
                                    tight: tight,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: edge,
                              right: edge,
                              top: potBandTop,
                              bottom: potBandBottom,
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.center,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: potBlockMaxW,
                                    ),
                                    child: _PotUnderOpponentCard(
                                      pot: displayPot,
                                      baseAnte: baseAnte,
                                      tight: tight,
                                    ),
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

List<BlindBluffSkill> _spentSkillsOrdered(Set<BlindBluffSkill> remaining) {
  return BlindBluffSkill.values
      .where((s) => !remaining.contains(s))
      .toList(growable: false);
}

IconData _feltSkillGlyph(BlindBluffSkill s) {
  return switch (s) {
    BlindBluffSkill.plusTwoModifier => Icons.trending_up,
    BlindBluffSkill.doubleBlind => Icons.layers_outlined,
    BlindBluffSkill.penaltyInsurance => Icons.shield_outlined,
  };
}

/// Small glyphs for skills already spent this match (shown by each seat).
class _FeltSpentSkillIcons extends StatelessWidget {
  const _FeltSpentSkillIcons({
    required this.spent,
    required this.alignEnd,
    required this.tight,
    this.inline = false,
  });

  final List<BlindBluffSkill> spent;
  final bool alignEnd;
  final bool tight;
  final bool inline;

  Widget _orb(BuildContext context, BlindBluffSkill s) {
    final iconS = AdaptiveLayout.blindBluffFeltSeatSkillIconSize(
      context,
      tight,
    );
    final pad = AdaptiveLayout.blindBluffFeltSeatSkillGlyphPadding(context);
    return Tooltip(
      message: _skillTitle(s),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: _kGold.withValues(alpha: 0.45)),
          color: Colors.black.withValues(alpha: 0.35),
        ),
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Icon(
            _feltSkillGlyph(s),
            size: iconS,
            color: Colors.amber.shade100,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (spent.isEmpty) {
      return const SizedBox.shrink();
    }
    final spacing = AdaptiveLayout.blindBluffFeltSeatSkillSpacing(context);
    if (inline) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          for (var i = 0; i < spent.length; i++) ...[
            if (i > 0) SizedBox(width: spacing),
            _orb(context, spent[i]),
          ],
        ],
      );
    }
    final runSpacing =
        AdaptiveLayout.blindBluffFeltSeatSkillRunSpacing(context);
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: alignEnd ? WrapAlignment.end : WrapAlignment.start,
      spacing: spacing,
      runSpacing: runSpacing,
      children: [for (final s in spent) _orb(context, s)],
    );
  }
}

class _FeltCornerIdentity extends StatelessWidget {
  const _FeltCornerIdentity({
    required this.label,
    required this.chips,
    required this.avatar,
    required this.avatarRadius,
    required this.alignEnd,
    this.spentSkills = const [],
    required this.tight,
  });

  final String label;
  final int chips;
  final IconData avatar;
  final double avatarRadius;
  final bool alignEnd;
  final List<BlindBluffSkill> spentSkills;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context);
    final seatLabelFs =
        Theme.of(context).textTheme.labelLarge?.fontSize ?? 14.0;
    final avatarBlock = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: CircleAvatar(
        radius: avatarRadius,
        backgroundColor: Colors.black38,
        child: Icon(avatar, color: Colors.white70, size: avatarRadius),
      ),
    );
    final chipStack = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: _ChipStack(count: chips, compact: true),
    );
    final chipSkillGap =
        AdaptiveLayout.blindBluffFeltSeatChipSkillGap(context);
    final skills = spentSkills.isEmpty
        ? null
        : _FeltSpentSkillIcons(
            spent: spentSkills,
            alignEnd: alignEnd,
            tight: tight,
            inline: true,
          );

    final Widget chipSkillRow;
    if (skills == null) {
      chipSkillRow = chipStack;
    } else if (alignEnd) {
      chipSkillRow = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          skills,
          SizedBox(width: chipSkillGap),
          chipStack,
        ],
      );
    } else {
      chipSkillRow = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          chipStack,
          SizedBox(width: chipSkillGap),
          skills,
        ],
      );
    }

    final textBlock = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: seatLabelFs,
          ),
        ),
        SizedBox(
          height: AdaptiveLayout.blindBluffFeltSeatLabelChipGap(context),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment:
              alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: chipSkillRow,
        ),
      ],
    );

    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: alignEnd ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: alignEnd
            ? [
                textBlock,
                SizedBox(width: gap),
                avatarBlock,
              ]
            : [
                avatarBlock,
                SizedBox(width: gap),
                textBlock,
              ],
      ),
    );
  }
}

class _PlayingCard extends StatelessWidget {
  const _PlayingCard({
    required this.card,
    this.height = 100,
    this.faceUp = true,
  });

  final BlindCard card;
  final double height;
  final bool faceUp;

  @override
  Widget build(BuildContext context) {
    if (!faceUp) {
      return _CardBack(height: height);
    }
    final w = height * AdaptiveLayout.blindBluffPlayingCardWidthRatio;
    final r = AdaptiveLayout.blindBluffPlayingCardBorderRadius(height);
    final blur = AdaptiveLayout.blindBluffPlayingCardShadowBlur(context);
    final off = AdaptiveLayout.blindBluffPlayingCardShadowOffset(context);
    final rankFs =
        AdaptiveLayout.blindBluffPlayingCardRankFontSize(height, context);
    final jokerS = AdaptiveLayout.blindBluffPlayingCardJokerLogoSize(height);
    return Container(
      width: w,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(r),
        border: Border.all(color: Colors.black26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: blur,
            offset: off,
          ),
        ],
      ),
      child: card.isJoker
          ? Center(
              child: JokerCardLogo(size: jokerS),
            )
          : Center(
              child: Text(
                '${card.rank}',
                style: TextStyle(
                  fontSize: rankFs,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                ),
              ),
            ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    this.height = 100,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    final w = height * AdaptiveLayout.blindBluffPlayingCardWidthRatio;
    final r = AdaptiveLayout.blindBluffPlayingCardBorderRadius(height);
    final blur = AdaptiveLayout.blindBluffPlayingCardShadowBlur(context);
    final off = AdaptiveLayout.blindBluffPlayingCardShadowOffset(context);
    return Container(
      width: w,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _kAccent,
            _kAccent.withValues(alpha: 0.75),
            const Color(0xFF4A1530),
          ],
        ),
        border: Border.all(color: _kGold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: blur,
            offset: off,
          ),
        ],
      ),
    );
  }
}

/// Inline chip count with a gold [Icons.toll_rounded] marker.
class _ChipAmountLabel extends StatelessWidget {
  const _ChipAmountLabel({
    required this.amount,
    this.prefix = '',
    this.suffix = '',
    this.style,
    this.compact = false,
    this.iconColor = _kGold,
  });

  final int amount;
  final String prefix;
  final String suffix;
  final TextStyle? style;
  final bool compact;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final baseFs = style?.fontSize ??
        Theme.of(context).textTheme.labelLarge?.fontSize ??
        14;
    final iconSize = baseFs * (compact ? 0.95 : 1.1);
    final gap = AdaptiveLayout.inlineGap(context) * (compact ? 0.25 : 0.35);
    final textStyle = (style ??
            Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ))
        ?.copyWith(height: 1.0);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix.isNotEmpty)
          Text(prefix, style: textStyle?.copyWith(color: style?.color)),
        Icon(Icons.toll_rounded, size: iconSize, color: iconColor),
        SizedBox(width: gap),
        Text('$amount$suffix', style: textStyle),
      ],
    );
  }
}

class _ChipStack extends StatelessWidget {
  const _ChipStack({required this.count, this.compact = false});

  final int count;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final hPad = s * (compact ? 0.01 : 0.016);
    final vPad = s * (compact ? 0.004 : 0.007);
    final radius = s * 0.045;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: _kGold.withValues(alpha: 0.4)),
      ),
      child: _ChipAmountLabel(amount: count, compact: compact),
    );
  }
}

class _TimerPill extends StatelessWidget {
  const _TimerPill({
    required this.seconds,
    required this.active,
    this.compact = false,
  });

  final int seconds;
  final bool active;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final padH = s * (compact ? 0.006 : 0.01);
    final padW = s * (compact ? 0.014 : 0.022);
    final iconS = (Theme.of(context).textTheme.labelLarge?.fontSize ?? 14) *
        (compact ? 0.85 : 1.0);
    final fs = (Theme.of(context).textTheme.labelLarge?.fontSize ?? 14) *
        (compact ? 0.78 : 0.9);
    final radius = s * 0.045;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: padW,
        vertical: padH,
      ),
      decoration: BoxDecoration(
        color: active ? _kAccent.withValues(alpha: 0.85) : Colors.black38,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: iconS,
            color: active ? Colors.white : Colors.white38,
          ),
          SizedBox(width: AdaptiveLayout.inlineGap(context) * 0.35),
          Text(
            active ? '${seconds}s' : '—',
            style: TextStyle(
              color: active ? Colors.white : Colors.white38,
              fontWeight: FontWeight.w700,
              fontSize: fs,
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown ~1s when the shoe recycles and [base ante] doubles.
class _AnteDoubledOverlay extends StatelessWidget {
  const _AnteDoubledOverlay({
    required this.from,
    required this.to,
  });

  final int from;
  final int to;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final title = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );
    final body = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        );
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.94 + 0.06 * t,
                child: child,
              ),
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: s * 0.82),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _kRail,
                borderRadius: BorderRadius.circular(s * 0.04),
                border: Border.all(color: _kGold.withValues(alpha: 0.45)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: s * 0.06,
                  vertical: AdaptiveLayout.sectionGap(context) * 0.65,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: _kGold,
                      size: (title?.fontSize ?? 22) * 1.6,
                    ),
                    SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
                    Text(
                      'Ante doubles',
                      textAlign: TextAlign.center,
                      style: title,
                    ),
                    SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.55),
                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AdaptiveLayout.inlineGap(context) * 0.35,
                      children: [
                        Text('from ', style: body),
                        _ChipAmountLabel(
                          amount: from,
                          compact: true,
                          style: body,
                        ),
                        Text(' to ', style: body),
                        _ChipAmountLabel(
                          amount: to,
                          compact: true,
                          style: body,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Who opens the betting street this round (round 1 random; later rounds alternate).
class _FirstMoveOrderOverlay extends StatelessWidget {
  const _FirstMoveOrderOverlay({
    required this.firstToAct,
  });

  final BlindBluffPlayerId firstToAct;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final title = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );
    final body = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        );
    final line = firstToAct == BlindBluffPlayerId.playerOne
        ? 'You move first this round.'
        : 'Opponent moves first this round.';
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.94 + 0.06 * t,
                child: child,
              ),
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: s * 0.78),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _kRail,
                borderRadius: BorderRadius.circular(s * 0.04),
                border: Border.all(color: _kGold.withValues(alpha: 0.45)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: s * 0.06,
                  vertical: AdaptiveLayout.sectionGap(context) * 0.65,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swap_horiz_rounded,
                      color: _kGold,
                      size: (title?.fontSize ?? 22) * 1.6,
                    ),
                    SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
                    Text(
                      'First to act',
                      textAlign: TextAlign.center,
                      style: title,
                    ),
                    SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.5),
                    Text(
                      line,
                      textAlign: TextAlign.center,
                      style: body,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _OpponentBettingBannerKind { check, raise }

/// Brief notice when the opponent checks or raises (pairs with [_FirstMoveOrderOverlay]).
class _OpponentBettingActionOverlay extends StatelessWidget {
  const _OpponentBettingActionOverlay({
    required this.kind,
    this.raiseChips,
  });

  final _OpponentBettingBannerKind kind;
  final int? raiseChips;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    final title = Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        );
    final body = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white70,
        );
    final isRaise = kind == _OpponentBettingBannerKind.raise;
    final chips = raiseChips ?? 0;
    return Material(
      color: Colors.black.withValues(alpha: 0.55),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.94 + 0.06 * t,
                child: child,
              ),
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: s * 0.78),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _kRail,
                borderRadius: BorderRadius.circular(s * 0.04),
                border: Border.all(color: _kGold.withValues(alpha: 0.45)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: s * 0.06,
                  vertical: AdaptiveLayout.sectionGap(context) * 0.65,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isRaise ? Icons.toll_rounded : Icons.check_circle_outline,
                      color: _kGold,
                      size: (title?.fontSize ?? 22) * 1.6,
                    ),
                    SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
                    Text(
                      isRaise ? 'Opponent raises' : 'Opponent checks',
                      textAlign: TextAlign.center,
                      style: title,
                    ),
                    if (isRaise && chips > 0) ...[
                      SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.5),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.toll_rounded,
                            color: _kGold,
                            size: (body?.fontSize ?? 14) * 1.15,
                          ),
                          SizedBox(
                            width: AdaptiveLayout.inlineGap(context) * 0.45,
                          ),
                          Text(
                            'Adds +$chips',
                            textAlign: TextAlign.center,
                            style: body,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Brief overlay after both seats lock skills, before betting begins.
class _SkillRevealOverlay extends StatelessWidget {
  const _SkillRevealOverlay({
    required this.you,
    required this.opponentSkill,
  });

  final BlindBluffSkill? you;
  final BlindBluffSkill? opponentSkill;

  @override
  Widget build(BuildContext context) {
    final s = AdaptiveLayout.shortestSide(context);
    return Material(
      color: Colors.black.withValues(alpha: 0.72),
      child: Center(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
          builder: (context, t, child) {
            return Opacity(
              opacity: t,
              child: Transform.scale(
                scale: 0.92 + 0.08 * t,
                child: child,
              ),
            );
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: s * 0.85),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: _kRail,
                borderRadius: BorderRadius.circular(s * 0.04),
                border: Border.all(color: _kGold.withValues(alpha: 0.45)),
              ),
              child: Padding(
                padding: EdgeInsets.all(s * 0.04),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Skills',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: _kGold,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    SizedBox(height: AdaptiveLayout.sectionGap(context)),
                    Row(
                      children: [
                        Expanded(
                          child: _SkillRevealTile(
                            label: 'You',
                            skill: you,
                          ),
                        ),
                        SizedBox(width: AdaptiveLayout.inlineGap(context)),
                        Expanded(
                          child: _SkillRevealTile(
                            label: 'Opponent',
                            skill: opponentSkill,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillRevealTile extends StatelessWidget {
  const _SkillRevealTile({
    required this.label,
    required this.skill,
  });

  final String label;
  final BlindBluffSkill? skill;

  @override
  Widget build(BuildContext context) {
    final icon = skill == null
        ? Icons.not_interested_outlined
        : _blindBluffSkillIcon(skill!);
    final title = skill == null ? 'No skill' : _skillTitle(skill!);
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white54,
              ),
        ),
        SizedBox(height: AdaptiveLayout.inlineGap(context)),
        Icon(icon, color: _kGold, size: AdaptiveLayout.shortestSide(context) * 0.07),
        SizedBox(height: AdaptiveLayout.inlineGap(context) * 0.5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

String _staredownHeadline({
  required bool awaitingIntro,
  required int skillReflectionSecondsRemaining,
  required int skillDeclareSecondsRemaining,
  required bool awaitingSkillReveal,
  required bool enabled,
  required bool locked,
  required bool opponentLocked,
}) {
  if (awaitingIntro) {
    return 'Skills — unlock after intro (ante → deal)';
  }
  if (skillReflectionSecondsRemaining > 0) {
    return 'Skills (${skillReflectionSecondsRemaining}s)';
  }
  if (awaitingSkillReveal) {
    return 'Skills revealed — betting next';
  }
  if (!enabled) {
    return 'Watch the table…';
  }
  if (locked) {
    return opponentLocked ? 'Starting betting…' : 'Opponent still choosing…';
  }
  return 'Skills (${skillDeclareSecondsRemaining}s)';
}

class _StaredownPanel extends StatelessWidget {
  const _StaredownPanel({
    required this.cubit,
    required this.awaitingIntro,
    required this.skillReflectionSecondsRemaining,
    required this.skillDeclareSecondsRemaining,
    required this.awaitingSkillReveal,
    required this.playerSkillsRemaining,
    required this.locked,
    required this.opponentLocked,
    required this.enabled,
  });

  final BlindBluffCubit cubit;
  final bool awaitingIntro;
  final int skillReflectionSecondsRemaining;
  final int skillDeclareSecondsRemaining;
  final bool awaitingSkillReveal;
  final Set<BlindBluffSkill> playerSkillsRemaining;
  final bool locked;
  final bool opponentLocked;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _kRail,
      elevation: 12,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AdaptiveLayout.blindBluffBottomRailMinHeight(context),
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
                _staredownHeadline(
                  awaitingIntro: awaitingIntro,
                  skillReflectionSecondsRemaining:
                      skillReflectionSecondsRemaining,
                  skillDeclareSecondsRemaining: skillDeclareSecondsRemaining,
                  awaitingSkillReveal: awaitingSkillReveal,
                  enabled: enabled,
                  locked: locked,
                  opponentLocked: opponentLocked,
                ),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = AdaptiveLayout.inlineGap(context);
                  final narrow =
                      constraints.maxWidth < AdaptiveLayout.shortestSide(context) * 0.72;
                  final chips = <Widget>[
                    _skillChip(
                      context,
                      label: '+2',
                      icon: _blindBluffSkillIcon(BlindBluffSkill.plusTwoModifier),
                      skill: BlindBluffSkill.plusTwoModifier,
                    ),
                    _skillChip(
                      context,
                      label: 'Double',
                      icon: _blindBluffSkillIcon(BlindBluffSkill.doubleBlind),
                      skill: BlindBluffSkill.doubleBlind,
                    ),
                    _skillChip(
                      context,
                      label: 'Immunity',
                      icon: _blindBluffSkillIcon(BlindBluffSkill.penaltyInsurance),
                      skill: BlindBluffSkill.penaltyInsurance,
                    ),
                  ];
                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(child: chips[0]),
                            SizedBox(width: gap),
                            Expanded(child: chips[1]),
                          ],
                        ),
                        SizedBox(height: gap),
                        Row(
                          children: [
                            Expanded(child: chips[2]),
                          ],
                        ),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: chips[0]),
                      SizedBox(width: gap),
                      Expanded(child: chips[1]),
                      SizedBox(width: gap),
                      Expanded(child: chips[2]),
                    ],
                  );
                },
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade500,
                  side: BorderSide(color: Colors.grey.shade700),
                  padding: EdgeInsets.symmetric(
                    vertical: AdaptiveLayout.inlineGap(context),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: (locked || !enabled)
                    ? null
                    : () => cubit.declarePlayerSkill(null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.skip_next_rounded,
                      size: AdaptiveLayout.shortestSide(context) * 0.042,
                    ),
                    SizedBox(width: AdaptiveLayout.inlineGap(context) * 0.6),
                    const Text('Skip skills'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _skillChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required BlindBluffSkill skill,
  }) {
    final canUse =
        enabled && !locked && playerSkillsRemaining.contains(skill);
    final iconSize = AdaptiveLayout.shortestSide(context) * 0.048;
    final gap = AdaptiveLayout.inlineGap(context) * 0.35;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: _kSkillButtonBg,
        foregroundColor: canUse ? _kGold : Colors.white38,
        disabledForegroundColor: Colors.white30,
        disabledBackgroundColor: _kSkillButtonBg,
        side: BorderSide(
          color: canUse ? _kGold : Colors.grey.shade700,
          width: 1.5,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AdaptiveLayout.inlineGap(context),
          vertical: AdaptiveLayout.inlineGap(context) * 0.85,
        ),
        textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: canUse ? () => cubit.declarePlayerSkill(skill) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: canUse ? _kGold : Colors.white30,
          ),
          SizedBox(height: gap),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Skill “logos” (Material icons) for the staredown rail.
IconData _blindBluffSkillIcon(BlindBluffSkill skill) {
  return switch (skill) {
    BlindBluffSkill.plusTwoModifier => Icons.trending_up_rounded,
    BlindBluffSkill.doubleBlind => Icons.layers_rounded,
    BlindBluffSkill.penaltyInsurance => Icons.shield_moon_outlined,
  };
}

/// Max raise-by amount so the opponent can still cover your total wager.
int _maxRaiseBumpOpponentCanCover({
  required int chipsToCall,
  required int playerContribution,
  required int opponentChips,
  required int opponentContribution,
}) {
  final maxTotalWager = opponentContribution + opponentChips;
  return math.max(
    0,
    maxTotalWager - playerContribution - chipsToCall,
  );
}

class _BettingPanel extends StatelessWidget {
  const _BettingPanel({
    required this.cubit,
    required this.chipsToCall,
    required this.minRaise,
    required this.playerChips,
    required this.playerContribution,
    required this.opponentChips,
    required this.opponentContribution,
    required this.firstToAct,
    required this.enabled,
  });

  final BlindBluffCubit cubit;
  final int chipsToCall;
  final int minRaise;
  final int playerChips;
  final int playerContribution;
  final int opponentChips;
  final int opponentContribution;
  final BlindBluffPlayerId firstToAct;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final maxBump = math.min(
      playerChips - chipsToCall,
      _maxRaiseBumpOpponentCanCover(
        chipsToCall: chipsToCall,
        playerContribution: playerContribution,
        opponentChips: opponentChips,
        opponentContribution: opponentContribution,
      ),
    );
    final canRaiseSheet = enabled && maxBump >= minRaise;
    final canForceOpponentAllIn =
        enabled && maxBump >= 1 && maxBump < minRaise;

    return Material(
      color: _kRail,
      elevation: 12,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: AdaptiveLayout.blindBluffBottomRailMinHeight(context),
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
                enabled ? 'Your action' : 'Opponent is thinking…',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.22),
              Text(
                firstToAct == BlindBluffPlayerId.playerOne
                    ? 'You open betting this round.'
                    : 'Opponent opens betting this round.',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white38,
                    ),
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(context) * 0.35),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = AdaptiveLayout.inlineGap(context);
                  final narrow =
                      constraints.maxWidth < AdaptiveLayout.shortestSide(context) * 0.72;
                  final vPad = AdaptiveLayout.inlineGap(context);
                  final fold = Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                        side: const BorderSide(
                          color: Colors.redAccent,
                          width: 1.5,
                        ),
                        padding: EdgeInsets.symmetric(vertical: vPad),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: enabled
                          ? () => cubit.submitPlayerBetting(
                                const BlindBluffBettingAction.fold(),
                              )
                          : null,
                      child: const Text('FOLD'),
                    ),
                  );
                  final needsCallChips =
                      chipsToCall > 0 && playerChips == 0;
                  final call = Expanded(
                    flex: 2,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF4B5563),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFF374151),
                        disabledForegroundColor: Colors.white38,
                        padding: EdgeInsets.symmetric(vertical: vPad),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: enabled && !needsCallChips
                          ? () => chipsToCall == 0
                              ? cubit.submitPlayerBetting(
                                  const BlindBluffBettingAction.check(),
                                )
                              : cubit.submitPlayerBetting(
                                  const BlindBluffBettingAction.call(),
                                )
                          : null,
                      child: chipsToCall == 0
                          ? const Text('CHECK', textAlign: TextAlign.center)
                          : Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                Text(
                                  chipsToCall > playerChips
                                      ? 'ALL-IN '
                                      : 'CALL ',
                                  textAlign: TextAlign.center,
                                ),
                                _ChipAmountLabel(
                                  amount: chipsToCall > playerChips
                                      ? playerChips
                                      : chipsToCall,
                                  compact: true,
                                ),
                              ],
                            ),
                    ),
                  );
                  final raise = Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.neoGold,
                        foregroundColor: AppTheme.neoBackground,
                        disabledBackgroundColor: const Color(0xFF374151),
                        disabledForegroundColor: Colors.white38,
                        padding: EdgeInsets.symmetric(vertical: vPad),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: !enabled
                          ? null
                          : canRaiseSheet
                              ? () => _openRaiseSheet(
                                    context,
                                    cubit: cubit,
                                    minRaise: minRaise,
                                    chipsToCall: chipsToCall,
                                    playerChips: playerChips,
                                    playerContribution: playerContribution,
                                    opponentChips: opponentChips,
                                    opponentContribution:
                                        opponentContribution,
                                  )
                              : canForceOpponentAllIn
                                  ? () => cubit.submitPlayerBetting(
                                        BlindBluffBettingAction.raise(
                                          raiseBy: maxBump,
                                        ),
                                      )
                                  : null,
                      child: const Text('RAISE'),
                    ),
                  );
                  if (narrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [fold, SizedBox(width: gap), call]),
                        SizedBox(height: gap),
                        Row(children: [raise]),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      fold,
                      SizedBox(width: gap),
                      call,
                      SizedBox(width: gap),
                      raise,
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShowdownCard extends StatelessWidget {
  const _ShowdownCard({
    required this.roundNumber,
    required this.resolution,
    required this.playerChips,
    required this.opponentChips,
  });

  final int roundNumber;
  final BlindBluffRoundResolution resolution;
  final int playerChips;
  final int opponentChips;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final pad = AdaptiveLayout.shortestSide(context) * 0.032;
        final gap = AdaptiveLayout.sectionGap(context);
        final cardH =
            AdaptiveLayout.showdownCardHeight(c.maxWidth, c.maxHeight * 0.42);
        final captionStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _kGold,
            );
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: c.maxWidth),
            child: Container(
              padding: EdgeInsets.all(pad),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _kGold.withValues(alpha: 0.35)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Hand result · Round $roundNumber',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _kGold,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  SizedBox(height: gap * 0.75),
                  resolution.when(
                    fold: (
                      potWinner,
                      foldingPlayer,
                      foldingPlayersCard,
                      opponentsVisibleCard,
                      potAwarded,
                      fatalFoldPenaltyApplied,
                      fatalFoldPenaltyPaid,
                    ) {
                      final holes = _yourVsOpponentHoles(resolution);
                      final actionLine = _roundBettingActionLine(resolution);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Your card',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      SizedBox(height: gap * 0.25),
                                      _PlayingCard(
                                        card: holes.$1,
                                        height: cardH,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: gap * 0.35,
                                    ),
                                    child: Text(
                                      'vs',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(color: Colors.white54),
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Opponent's card",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      SizedBox(height: gap * 0.25),
                                      _PlayingCard(
                                        card: holes.$2,
                                        height: cardH,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: gap * 0.65),
                          Text(
                            actionLine,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          SizedBox(height: gap),
                          Align(
                            alignment: Alignment.center,
                            child: potWinner == BlindBluffPlayerId.playerOne
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'You take the pot (+',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      _ChipAmountLabel(
                                        amount: potAwarded,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        ')',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Opponent takes the pot (+',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      _ChipAmountLabel(
                                        amount: potAwarded,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        ')',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ),
                          if (fatalFoldPenaltyApplied) ...[
                            SizedBox(height: gap * 0.5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Fatal Fold: ',
                                  style: const TextStyle(
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                                _ChipAmountLabel(
                                  amount: fatalFoldPenaltyPaid,
                                  style: const TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  iconColor: Colors.deepOrangeAccent,
                                ),
                                const Text(
                                  ' moved',
                                  style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                    showdown: (
                      outcome,
                      playerOneCard,
                      playerTwoCard,
                      playerOneUsedPlusTwo,
                      playerTwoUsedPlusTwo,
                      potAwardedToWinner,
                      matchedWagerPerSeat,
                      rolledPotNextRound,
                    ) {
                      final contestedFromOpponent = matchedWagerPerSeat > 0
                          ? matchedWagerPerSeat
                          : potAwardedToWinner;
                      final showPotTotal = matchedWagerPerSeat > 0 &&
                          potAwardedToWinner > matchedWagerPerSeat;
                      final actionLine = _roundBettingActionLine(resolution);
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Your card',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      SizedBox(height: gap * 0.25),
                                      _PlayingCard(
                                          card: playerOneCard, height: cardH),
                                      if (_strengthCaption(playerOneCard,
                                              playerOneUsedPlusTwo)
                                          .isNotEmpty)
                                        Text(
                                          _strengthCaption(playerOneCard,
                                              playerOneUsedPlusTwo),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: captionStyle,
                                        ),
                                    ],
                                  ),
                                  SizedBox(width: gap),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Opponent's card",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.copyWith(color: Colors.white70),
                                      ),
                                      SizedBox(height: gap * 0.25),
                                      _PlayingCard(
                                          card: playerTwoCard, height: cardH),
                                      if (_strengthCaption(playerTwoCard,
                                              playerTwoUsedPlusTwo)
                                          .isNotEmpty)
                                        Text(
                                          _strengthCaption(playerTwoCard,
                                              playerTwoUsedPlusTwo),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: captionStyle,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: gap * 0.65),
                          Text(
                            actionLine,
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                          SizedBox(height: gap),
                          Align(
                            alignment: Alignment.center,
                            child: switch (outcome) {
                              ShowdownOutcome.playerOneWins => Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'You win +',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        _ChipAmountLabel(
                                          amount: contestedFromOpponent,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        Text(
                                          matchedWagerPerSeat > 0
                                              ? ' from Opponent'
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                      ],
                                    ),
                                    if (showPotTotal) ...[
                                      SizedBox(height: gap * 0.35),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            'Pot total ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: Colors.white54,
                                                ),
                                          ),
                                          _ChipAmountLabel(
                                            amount: potAwardedToWinner,
                                            compact: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: Colors.white54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ShowdownOutcome.playerTwoWins => Column(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.center,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Opponent wins +',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        _ChipAmountLabel(
                                          amount: contestedFromOpponent,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        if (matchedWagerPerSeat > 0)
                                          Text(
                                            ' from you',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                      ],
                                    ),
                                    if (showPotTotal) ...[
                                      SizedBox(height: gap * 0.35),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            'Pot total ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: Colors.white54,
                                                ),
                                          ),
                                          _ChipAmountLabel(
                                            amount: potAwardedToWinner,
                                            compact: true,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium
                                                ?.copyWith(
                                                  color: Colors.white54,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ShowdownOutcome.tie => Wrap(
                                  alignment: WrapAlignment.center,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Text(
                                      'Push — ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    _ChipAmountLabel(
                                      amount: rolledPotNextRound,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    Text(
                                      ' in the pot next hand',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: gap * 0.75),
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AdaptiveLayout.inlineGap(context) * 0.5,
                    runSpacing: AdaptiveLayout.inlineGap(context) * 0.35,
                    children: [
                      Text(
                        'Stacks:',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                      Text(
                        'you',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                      _ChipAmountLabel(
                        amount: playerChips,
                        compact: true,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                      Text(
                        '· opponent',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                      _ChipAmountLabel(
                        amount: opponentChips,
                        compact: true,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade400,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: gap * 0.75),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: _kGold,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        vertical: AdaptiveLayout.inlineGap(context),
                      ),
                    ),
                    onPressed: () =>
                        context.read<BlindBluffCubit>().advanceFromShowdown(),
                    child: const Text('Next hand'),
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

Future<void> _openRaiseSheet(
  BuildContext context, {
  required BlindBluffCubit cubit,
  required int minRaise,
  required int chipsToCall,
  required int playerChips,
  required int playerContribution,
  required int opponentChips,
  required int opponentContribution,
}) async {
  final maxBump = math.min(
    playerChips - chipsToCall,
    _maxRaiseBumpOpponentCanCover(
      chipsToCall: chipsToCall,
      playerContribution: playerContribution,
      opponentChips: opponentChips,
      opponentContribution: opponentContribution,
    ),
  );
  if (maxBump < 1) {
    return;
  }
  if (maxBump < minRaise) {
    if (context.mounted) {
      await cubit.submitPlayerBetting(
        BlindBluffBettingAction.raise(raiseBy: maxBump),
      );
    }
    return;
  }

  var bump = minRaise.toDouble();

  final chosen = await showDialog<int>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: _kRail,
        title: const Text('Raise', style: TextStyle(color: _kGold)),
        content: StatefulBuilder(
          builder: (context, setLocal) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add ${bump.toInt()} beyond the call (min $minRaise, max $maxBump)',
                  style: const TextStyle(color: Colors.white70),
                ),
                Slider(
                  min: minRaise.toDouble(),
                  max: maxBump.toDouble(),
                  divisions: maxBump > minRaise ? (maxBump - minRaise) : null,
                  value: bump.clamp(minRaise.toDouble(), maxBump.toDouble()),
                  activeColor: _kGold,
                  label: '${bump.toInt()}',
                  onChanged: (v) => setLocal(() => bump = v),
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _kGold,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(ctx, bump.round()),
            child: const Text('Raise'),
          ),
        ],
      );
    },
  );

  if (chosen != null && context.mounted) {
    await cubit.submitPlayerBetting(
      BlindBluffBettingAction.raise(raiseBy: chosen),
    );
  }
}

String _strengthCaption(BlindCard card, bool plusTwo) {
  if (card.isJoker) {
    return '';
  }
  final bonus = plusTwo ? 2 : 0;
  final total = card.rank + bonus;
  if (plusTwo) {
    return '${card.rank} + 2 = $total';
  }
  return '${card.rank}';
}

String _skillTitle(BlindBluffSkill s) {
  return switch (s) {
    BlindBluffSkill.plusTwoModifier => '+2',
    BlindBluffSkill.doubleBlind => 'Double',
    BlindBluffSkill.penaltyInsurance => 'Immunity',
  };
}
