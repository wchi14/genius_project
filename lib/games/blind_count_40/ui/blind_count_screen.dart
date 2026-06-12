import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:genius_project/core/theme/app_theme.dart';
import 'package:genius_project/core/ui/adaptive_layout.dart';
import 'package:genius_project/core/ui/turn_countdown_chip.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_cubit.dart';
import 'package:genius_project/games/blind_count_40/logic/blind_count_state.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';
import 'package:genius_project/games/blind_count_40/models/game_player.dart';
import 'package:genius_project/games/blind_count_40/models/opponent_slot_ui.dart';
import 'package:genius_project/games/blind_count_40/ui/blind_count_block_tile.dart';

const Color _kTable = Color(0xFF123B2D);
const Color _kPanel = AppTheme.neoBackground;
const Color _kCapFlash = Color(0xFFEF4444);

class BlindCountScreen extends StatelessWidget {
  const BlindCountScreen({super.key, this.cubit});

  final BlindCountCubit? cubit;

  @override
  Widget build(BuildContext context) {
    const body = _BlindCountBody();

    if (cubit != null) {
      return BlocProvider<BlindCountCubit>.value(
        value: cubit!,
        child: body,
      );
    }
    return BlocProvider<BlindCountCubit>(
      create: (_) => BlindCountCubit(),
      child: body,
    );
  }
}

class _BlindCountBody extends StatefulWidget {
  const _BlindCountBody();

  @override
  State<_BlindCountBody> createState() => _BlindCountBodyState();
}

class _BlindCountBodyState extends State<_BlindCountBody>
    with SingleTickerProviderStateMixin {
  bool _opponentBusy = false;
  bool _feedbackHold = false;

  final Map<String, BlindCountBlockAnim> _p1Anim = {};
  final Map<String, BlindCountBlockAnim> _oppAnim = {};

  Set<String> _prevP1Ids = {};
  Set<String> _prevOppIds = {};
  BlindCountState? _lastBlocState;

  late final AnimationController _capFlash;

  @override
  void initState() {
    super.initState();
    _capFlash = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = context.read<BlindCountCubit>().state;
      _prevP1Ids = s.p1Blocks.map((b) => b.id).toSet();
      _prevOppIds = s.hiddenP2Blocks.map((b) => b.id).toSet();
      _scheduleOpponentTurn(s);
    });
  }

  @override
  void dispose() {
    _capFlash.dispose();
    super.dispose();
  }

  void _trackBlockAnimations(BlindCountState prev, BlindCountState next) {
    final nextP1 = next.p1Blocks.map((b) => b.id).toSet();
    final nextOpp = next.hiddenP2Blocks.map((b) => b.id).toSet();

    for (final id in _prevP1Ids.difference(nextP1)) {
      _p1Anim[id] = BlindCountBlockAnim.vanish;
    }
    for (final id in nextP1.difference(_prevP1Ids)) {
      _p1Anim[id] = BlindCountBlockAnim.spawn;
    }

    for (final id in _prevOppIds.difference(nextOpp)) {
      _oppAnim[id] = BlindCountBlockAnim.vanish;
    }
    for (final id in nextOpp.difference(_prevOppIds)) {
      _oppAnim[id] = BlindCountBlockAnim.spawn;
    }

    final newlyRevealed =
        next.revealedP2BlockIds.difference(prev.revealedP2BlockIds);
    for (final id in newlyRevealed) {
      if (nextOpp.contains(id)) {
        _oppAnim[id] = BlindCountBlockAnim.reveal;
      }
    }

    _prevP1Ids = nextP1;
    _prevOppIds = nextOpp;
  }

  void _holdFeedbackThenSchedule(BlindCountState state) {
    if (state.lastGuessFeedback == null) return;
    _feedbackHold = true;
    unawaited(
      Future<void>.delayed(BlindCountCubit.wrongGuessOverlayDelay, () {
        if (!mounted) return;
        _feedbackHold = false;
        _scheduleOpponentTurn(context.read<BlindCountCubit>().state);
      }),
    );
  }

  void _scheduleOpponentTurn(BlindCountState state) {
    if (!mounted ||
        state.isGameOver ||
        state.isSkillPeekActive ||
        state.isResolvingGuess ||
        _opponentBusy ||
        _feedbackHold ||
        state.currentTurn != BlindPlayerId.p2) {
      return;
    }
    _opponentBusy = true;
    unawaited(
      Future<void>.delayed(const Duration(milliseconds: 700), () async {
        if (!mounted) {
          _opponentBusy = false;
          return;
        }
        final cubit = context.read<BlindCountCubit>();
        final live = cubit.state;
        if (live.isGameOver ||
            live.isSkillPeekActive ||
            live.isResolvingGuess ||
            live.currentTurn != BlindPlayerId.p2) {
          _opponentBusy = false;
          return;
        }
        cubit.runOpponentTurn();
        _opponentBusy = false;
        if (mounted &&
            !_feedbackHold &&
            !cubit.opponentSkillJustUsed &&
            cubit.state.currentTurn == BlindPlayerId.p2 &&
            !cubit.state.isResolvingGuess) {
          _scheduleOpponentTurn(cubit.state);
        }
      }),
    );
  }

  Future<void> _openGuessPicker(BuildContext context) async {
    final value = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppTheme.neoBackground,
      isScrollControlled: true,
      builder: (ctx) => const _GuessNumberSheet(),
    );
    if (value == null || !context.mounted) return;
    context.read<BlindCountCubit>().guessNumber(value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BlindCountCubit, BlindCountState>(
      listenWhen: (prev, next) => !prev.isGameOver && next.isGameOver,
      listener: (context, state) => _showGameOverSheet(context, state),
      child: BlocConsumer<BlindCountCubit, BlindCountState>(
        listenWhen: (a, b) =>
            a != b &&
            (a.currentTurn != b.currentTurn ||
                a.isSkillPeekActive != b.isSkillPeekActive ||
                a.isResolvingGuess != b.isResolvingGuess ||
                a.lastGuessFeedback != b.lastGuessFeedback ||
                a.skillUsedBy != b.skillUsedBy ||
                a.p1Blocks != b.p1Blocks ||
                a.hiddenP2Blocks != b.hiddenP2Blocks ||
                a.revealedP2BlockIds != b.revealedP2BlockIds),
        listener: (context, state) {
        final prev = _lastBlocState;
        if (prev != null) {
          _trackBlockAnimations(prev, state);
          if (state.lastGuessFeedback != null &&
              state.lastGuessFeedback != prev.lastGuessFeedback) {
            _holdFeedbackThenSchedule(state);
          }
        }
        _lastBlocState = state;
        if (!_feedbackHold) {
          _scheduleOpponentTurn(state);
        }
      },
      buildWhen: (a, b) => a != b,
      builder: (context, state) {
        final ui = state.toUiSnapshot();
        final atCap = ui.p2BlockCount >= BlindCountCubit.maxOpponentBlocks;
        if (atCap && !_capFlash.isAnimating) {
          _capFlash.repeat(reverse: true);
        } else if (!atCap && _capFlash.isAnimating) {
          _capFlash.stop();
        }

        final p1Turn = ui.currentTurn == BlindPlayerId.p1;
          final canAct = p1Turn &&
            !state.isSkillPeekActive &&
            !state.isResolvingGuess &&
            !ui.isGameOver;
          final inCombo = p1Turn && ui.canStopGuessing;
          final canGiveBlock = canAct && ui.canGiveBlockThisTurn && !atCap;
          final canStopGuessing = canAct && inCombo;

        final showTimer = !state.isSkillPeekActive && !ui.isGameOver;

        return Scaffold(
          backgroundColor: _kPanel,
          appBar: AppBar(
            title: const Text('Blind Count 40'),
            backgroundColor: _kPanel,
            actions: [
              if (showTimer)
                Padding(
                  padding: EdgeInsets.only(
                    right: AdaptiveLayout.inlineGap(context),
                  ),
                  child: Center(
                    child: TurnCountdownChip(
                      seconds: ui.turnRemainingSeconds,
                      showWhenInactive: true,
                    ),
                  ),
                ),
            ],
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SafeArea(
                child: Padding(
                  padding: AdaptiveLayout.screenPadding(context),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SeatHeader(
                        label: 'Opponent',
                        score: ui.p2Score,
                        blocks: ui.p2BlockCount,
                        atCap: atCap,
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Expanded(
                        flex: 2,
                        child: _OpponentBlockRow(
                          slots: ui.opponentSlots,
                          animById: _oppAnim,
                          capFlash: _capFlash,
                          atCap: atCap,
                        ),
                      ),
                      SizedBox(height: AdaptiveLayout.sectionGap(context)),
                      _PoolLine(
                        pool: ui.poolRemaining,
                        combo: ui.currentTurnComboScore,
                        p1Sum: ui.p1HandSumWhenPoolEmpty,
                        p2Sum: ui.p2HandSumWhenPoolEmpty,
                      ),
                      SizedBox(height: AdaptiveLayout.sectionGap(context)),
                      _SeatHeader(
                        label: 'Player',
                        score: ui.p1Score,
                        blocks: ui.p1Blocks.length,
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Expanded(
                        flex: 2,
                        child: _PlayerBlockRow(
                          blocks: ui.p1Blocks,
                          animById: _p1Anim,
                        ),
                      ),
                      SizedBox(height: AdaptiveLayout.sectionGap(context)),
                      Row(
                        children: [
                          Expanded(
                            child: inCombo
                                ? FilledButton(
                                    onPressed: canStopGuessing
                                        ? () => context
                                            .read<BlindCountCubit>()
                                            .stopGuessing()
                                        : null,
                                    child: const Text('Stop guessing'),
                                  )
                                : FilledButton(
                                    onPressed: canGiveBlock
                                        ? () => context
                                            .read<BlindCountCubit>()
                                            .giveBlockToOpponent()
                                        : null,
                                    child: const Text('Add block'),
                                  ),
                          ),
                          SizedBox(width: AdaptiveLayout.inlineGap(context)),
                          Expanded(
                            child: FilledButton.tonal(
                              onPressed: canAct
                                  ? () => _openGuessPicker(context)
                                  : null,
                              child: const Text('Guess number'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      _SkillRow(
                        cubit: context.read<BlindCountCubit>(),
                      ),
                    ],
                  ),
                ),
              ),
              if (ui.lastGuessFeedback != null &&
                  ui.lastGuessFeedback!.isCorrect &&
                  state.isResolvingGuess)
                _CorrectGuessOverlay(feedback: ui.lastGuessFeedback!),
              if (ui.lastGuessFeedback != null &&
                  !ui.lastGuessFeedback!.isCorrect &&
                  (state.isResolvingGuess || _feedbackHold))
                _WrongGuessOverlay(feedback: ui.lastGuessFeedback!),
              if (state.isSkillPeekActive &&
                  state.activeSkillNotification != null)
                _SkillPeekOverlay(
                  notification: state.activeSkillNotification!,
                  intel: state.showSkillIntelToLocalPlayer
                      ? state.skillResultData
                      : null,
                  secondsLeft: state.skillPeekRemainingSeconds ?? 0,
                ),
            ],
          ),
        );
        },
      ),
    );
  }

  void _showGameOverSheet(BuildContext context, BlindCountState state) {
    final winner = state.matchWinner;
    final headline = switch (winner) {
      BlindPlayerId.p1 => 'You win!',
      BlindPlayerId.p2 => 'Opponent wins',
      _ => 'Match over',
    };
    final detail = switch (state.clearedSeatWhenPoolEmpty) {
      BlindPlayerId.p1 => 'Your blocks were cleared · dealer empty',
      BlindPlayerId.p2 => 'Opponent cleared · dealer empty',
      _ => 'Dealer pool empty',
    };

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHigh,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) {
        return Padding(
          padding: AdaptiveLayout.panelPadding(ctx),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(headline, style: Theme.of(ctx).textTheme.titleLarge),
              SizedBox(height: AdaptiveLayout.inlineGap(ctx)),
              Text(detail, style: Theme.of(ctx).textTheme.bodyMedium),
              SizedBox(height: AdaptiveLayout.sectionGap(ctx)),
              Text(
                'You ${state.p1Score} · Opponent ${state.p2Score}',
                style: Theme.of(ctx).textTheme.bodyLarge,
              ),
              SizedBox(height: AdaptiveLayout.sectionGap(ctx)),
              FilledButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (context.mounted) {
                    context.pop();
                  }
                },
                child: const Text('Back'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SeatHeader extends StatelessWidget {
  const _SeatHeader({
    required this.label,
    required this.score,
    required this.blocks,
    this.atCap = false,
  });

  final String label;
  final int score;
  final int blocks;
  final bool atCap;

  @override
  Widget build(BuildContext context) {
    return Text(
      '$label score: $score   block: $blocks${atCap ? ' (CAP)' : ''}',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class _PoolLine extends StatelessWidget {
  const _PoolLine({
    required this.pool,
    required this.combo,
    this.p1Sum,
    this.p2Sum,
  });

  final int pool;
  final int combo;
  final int? p1Sum;
  final int? p2Sum;

  @override
  Widget build(BuildContext context) {
    final comboText = combo > 0 ? ' · P1 combo: $combo' : '';
    if (pool == 0 && p1Sum != null && p2Sum != null) {
      return Text(
        'Dealer empty · Player sum: $p1Sum · Opponent sum: $p2Sum$comboText',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: AppTheme.neoGold,
              fontWeight: FontWeight.w700,
            ),
      );
    }
    return Text(
      'Dealer pool: $pool$comboText',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _CorrectGuessOverlay extends StatelessWidget {
  const _CorrectGuessOverlay({required this.feedback});

  final BlindCountGuessFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final radius = AdaptiveLayout.blindCountPanelRadius(context);
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.72),
          child: Center(
            child: Padding(
              padding: AdaptiveLayout.dialogInsets(context),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(color: AppTheme.neoGold, width: 2),
                ),
                child: Padding(
                  padding: AdaptiveLayout.panelPadding(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: AdaptiveLayout.shortestSide(context) * 0.12,
                        color: AppTheme.neoGold,
                      ),
                      SizedBox(height: AdaptiveLayout.sectionGap(context)),
                      Text(
                        'CORRECT',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppTheme.neoGold,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                            ),
                      ),
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Text(
                        feedback.headline,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
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

class _WrongGuessOverlay extends StatelessWidget {
  const _WrongGuessOverlay({required this.feedback});

  final BlindCountGuessFeedback feedback;

  @override
  Widget build(BuildContext context) {
    final who =
        feedback.guesser == BlindPlayerId.p1 ? 'You' : 'Opponent';
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.72),
          child: Center(
            child: Padding(
              padding: AdaptiveLayout.dialogInsets(context),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.highlight_off_rounded,
                    size: AdaptiveLayout.shortestSide(context) * 0.14,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: AdaptiveLayout.sectionGap(context)),
                  Text(
                    'No block for this number',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  SizedBox(height: AdaptiveLayout.inlineGap(context)),
                  Text(
                    '$who guessed ${feedback.guessedValue}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.neoTextMuted,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkillPeekOverlay extends StatelessWidget {
  const _SkillPeekOverlay({
    required this.notification,
    required this.secondsLeft,
    this.intel,
  });

  final String notification;
  final String? intel;
  final int secondsLeft;

  @override
  Widget build(BuildContext context) {
    final radius = AdaptiveLayout.blindCountPanelRadius(context);
    return Positioned.fill(
      child: AbsorbPointer(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.78),
          child: Center(
            child: Padding(
              padding: AdaptiveLayout.dialogInsets(context),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1117),
                  borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: AppTheme.neoPurple.withValues(alpha: 0.9),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: AdaptiveLayout.panelPadding(context),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: AdaptiveLayout.shortestSide(context) * 0.1,
                        color: AppTheme.neoPurple,
                      ),
                      SizedBox(height: AdaptiveLayout.sectionGap(context)),
                      Text(
                        notification,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      if (intel != null) ...[
                        SizedBox(height: AdaptiveLayout.sectionGap(context)),
                        Text(
                          'SECRET INTEL',
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: AppTheme.neoGold,
                                letterSpacing: 1.5,
                              ),
                        ),
                        SizedBox(height: AdaptiveLayout.inlineGap(context)),
                        Text(
                          intel!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                      SizedBox(height: AdaptiveLayout.inlineGap(context)),
                      Text(
                        '${math.max(secondsLeft, 0)}s',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppTheme.neoTextMuted,
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

class _OpponentBlockRow extends StatelessWidget {
  const _OpponentBlockRow({
    required this.slots,
    required this.animById,
    required this.capFlash,
    required this.atCap,
  });

  final List<OpponentSlotUi> slots;
  final Map<String, BlindCountBlockAnim> animById;
  final AnimationController capFlash;
  final bool atCap;

  @override
  Widget build(BuildContext context) {
    final radius = AdaptiveLayout.blindCountPanelRadius(context);
    return AnimatedBuilder(
      animation: capFlash,
      builder: (context, child) {
        final flash = atCap
            ? Color.lerp(
                _kCapFlash.withValues(alpha: 0.35),
                _kCapFlash,
                capFlash.value,
              )!
            : Colors.white.withValues(alpha: 0.1);
        return DecoratedBox(
          decoration: BoxDecoration(
            color: _kTable,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: flash,
              width: atCap
                  ? AdaptiveLayout.blindCountCapFlashBorderWidth(context) * 1.5
                  : AdaptiveLayout.blindCountCapFlashBorderWidth(context) * 0.4,
            ),
          ),
          child: child,
        );
      },
      child: _BlockRow(
        count: slots.length,
        itemBuilder: (extent, i) {
          final slot = slots[i];
          final anim = animById[slot.id] ?? BlindCountBlockAnim.none;
          return BlindCountBlockTile(
            key: ValueKey('opp-${slot.id}'),
            extent: extent,
            hidden: !slot.isRevealed,
            value: slot.value,
            anim: anim,
          );
        },
      ),
    );
  }
}

class _PlayerBlockRow extends StatelessWidget {
  const _PlayerBlockRow({
    required this.blocks,
    required this.animById,
  });

  final List<BlockModel> blocks;
  final Map<String, BlindCountBlockAnim> animById;

  @override
  Widget build(BuildContext context) {
    return _BlockRow(
      count: blocks.length,
      itemBuilder: (extent, i) {
        final block = blocks[i];
        return BlindCountBlockTile(
          key: ValueKey('p1-${block.id}'),
          extent: extent,
          hidden: false,
          value: block.value,
          anim: animById[block.id] ?? BlindCountBlockAnim.none,
        );
      },
    );
  }
}

class _BlockRow extends StatelessWidget {
  const _BlockRow({
    required this.count,
    required this.itemBuilder,
  });

  final int count;
  final Widget Function(double extent, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final n = math.max(count, 1);
        final extent = AdaptiveLayout.blindCountBlockExtent(
          context,
          rowMaxWidth: constraints.maxWidth,
          blockCount: n,
        );
        return Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < count; i++) ...[
                  if (i > 0)
                    SizedBox(width: AdaptiveLayout.blindCountBlockGap(context)),
                  itemBuilder(extent, i),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.cubit});

  final BlindCountCubit cubit;

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.inlineGap(context) * 0.5;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: cubit.canUseP1Skill(BlindCountSkillId.sum)
                ? cubit.useSumRevealSkill
                : null,
            child: const Text(BlindCountSkillId.labelSum, maxLines: 1),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: OutlinedButton(
            onPressed: cubit.canUseP1Skill(BlindCountSkillId.radar)
                ? cubit.useRadarSkill
                : null,
            child: const Text(BlindCountSkillId.labelDuplicate, maxLines: 1),
          ),
        ),
        SizedBox(width: gap),
        Expanded(
          child: OutlinedButton(
            onPressed: cubit.canUseP1Skill(BlindCountSkillId.bloat)
                ? cubit.useForceBloatSkill
                : null,
            child: const Text(BlindCountSkillId.labelAddBlock, maxLines: 1),
          ),
        ),
      ],
    );
  }
}

class _GuessNumberSheet extends StatelessWidget {
  const _GuessNumberSheet();

  @override
  Widget build(BuildContext context) {
    final gap = AdaptiveLayout.blindCountGuessGridGap(context);
    final pad = AdaptiveLayout.panelPadding(context);

    return Padding(
      padding: EdgeInsets.only(
        left: pad.left,
        right: pad.right,
        top: pad.top,
        bottom: pad.bottom + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Guess opponent number',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: AdaptiveLayout.sectionGap(context)),
          LayoutBuilder(
            builder: (context, constraints) {
              final cell = AdaptiveLayout.blindCountGuessGridCellExtentForWidth(
                context,
                constraints.maxWidth,
              );
              final fontSize = AdaptiveLayout.blindCountGuessGridFontSize(cell);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _GuessNumberRow(
                    values: const [1, 2, 3, 4, 5],
                    cellExtent: cell,
                    gap: gap,
                    fontSize: fontSize,
                  ),
                  SizedBox(height: gap),
                  _GuessNumberRow(
                    values: const [6, 7, 8, 9, 10],
                    cellExtent: cell,
                    gap: gap,
                    fontSize: fontSize,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GuessNumberRow extends StatelessWidget {
  const _GuessNumberRow({
    required this.values,
    required this.cellExtent,
    required this.gap,
    required this.fontSize,
  });

  final List<int> values;
  final double cellExtent;
  final double gap;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < values.length; i++) ...[
          if (i > 0) SizedBox(width: gap),
          Expanded(
            child: SizedBox(
              height: cellExtent,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(values[i]),
                style: FilledButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  '${values[i]}',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
