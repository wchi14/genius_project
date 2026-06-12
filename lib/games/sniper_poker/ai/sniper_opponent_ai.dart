import 'dart:math';

import 'package:genius_project/games/sniper_poker/logic/poker_evaluator.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_engine.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_cubit.dart';
import 'package:genius_project/games/sniper_poker/logic/sniper_match_state.dart';
import 'package:genius_project/games/sniper_poker/models/poker_models.dart';
import 'package:genius_project/games/sniper_poker/models/sniper_player_id.dart';

/// Opponent (P2) decisions: betting, skills, sniper / shotgun.
class SniperOpponentAi {
  SniperOpponentAi({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const int _equitySamples = 48;

  SniperBettingDecision decideBetting(SniperMatchState state) {
    final bb = state.currentAnte;
    final stack = state.p2Chips;
    final oppStack = state.p1Chips;
    final toCall = state.amountToCall(SniperPlayerId.p2);

    if (stack <= 0) {
      return const SniperBettingCheckCall();
    }

    if (toCall >= stack) {
      final equity = _estimateEquity(state);
      if (equity >= 0.22 || toCall == stack) {
        return const SniperBettingCheckCall();
      }
      return const SniperBettingFold();
    }

    final equity = _estimateEquity(state);
    final strength = _currentHandStrength(state);
    final mustShove = stack <= bb || (stack <= toCall + bb && equity >= 0.45);
    if (mustShove) {
      return const SniperBettingRaise(bbUnits: 99);
    }

    final isLeader = stack > oppStack + bb;
    final isShort = stack <= bb * 4;
    final p1Aggressive = state.p1StreetBet > bb ||
        state.p1RoundInvestment > state.p2RoundInvestment + bb;

    if (equity < 0.18 && toCall > 0) {
      return const SniperBettingFold();
    }

    if (equity < 0.28 && toCall > bb && !isShort) {
      return const SniperBettingFold();
    }

    if (equity >= 0.62 && (isLeader || !isShort)) {
      final bbUnits = _pickRaiseBb(strength: strength, equity: equity);
      if (_random.nextDouble() < 0.75) {
        return SniperBettingRaise(bbUnits: bbUnits);
      }
    }

    if (equity >= 0.48 && toCall == 0 && !p1Aggressive) {
      if (_random.nextDouble() < (isLeader ? 0.55 : 0.35)) {
        return SniperBettingRaise(
          bbUnits: _pickRaiseBb(strength: strength, equity: equity),
        );
      }
    }

    if (isShort && equity >= 0.4) {
      return const SniperBettingRaise(bbUnits: 99);
    }

    if (toCall > 0 && equity >= 0.32) {
      return const SniperBettingCheckCall();
    }

    if (toCall == 0) {
      return const SniperBettingCheckCall();
    }

    return const SniperBettingFold();
  }

  String? pickSkill(SniperMatchState state) {
    final unused = [
      SniperMatchCubit.skillKevlar,
      SniperMatchCubit.skillFlashbang,
      SniperMatchCubit.skillLens,
    ].where((id) => !state.p2UsedSkills.contains(id)).toList();

    if (unused.isEmpty) return null;

    final equity = _estimateEquity(state);
    if (equity >= 0.55 && _random.nextDouble() < 0.7) {
      if (!unused.contains(SniperMatchCubit.skillLens)) {
        return unused[_random.nextInt(unused.length)];
      }
      return SniperMatchCubit.skillLens;
    }
    if (equity < 0.35 && _random.nextDouble() < 0.5) {
      return SniperMatchCubit.skillFlashbang;
    }
    if (_random.nextDouble() < 0.4) {
      return unused[_random.nextInt(unused.length)];
    }
    return null;
  }

  SniperTargetDecision decideSniper(SniperMatchState state) {
    if (state.communityCards.length < 4) {
      return const SniperTargetPass();
    }

    final p2Hand = PokerEvaluator.evaluateBestFour(
      state.p2HoleCards,
      state.communityCards,
    );

    final p1Decl = state.p1RiverDeclaration;
    final p1Locked = state.p1SniperLocked;

    if (p1Locked && p1Decl != null && p1Decl.mode != SniperModeSelection.none) {
      return _counterP1Declaration(state, p2Hand, p1Decl);
    }

    return _proactiveTarget(state, p2Hand);
  }

  /// Best sniper line against likely P1 hands (avoids self-snipe).
  SniperTargetSniper? _pickBestSnipeTarget(SniperMatchState state) {
    if (state.communityCards.length != 4) return null;

    final board = state.communityCards;
    final known = {...state.p2HoleCards, ...board};
    final deck = _remainingDeck(known);

    HandRank? bestRank;
    int? bestValue;
    var bestWeight = 0.0;

    for (var i = 0; i < deck.length; i++) {
      for (var j = i + 1; j < deck.length; j++) {
        final p1Hand = PokerEvaluator.evaluateBestFour(
          [deck[i], deck[j]],
          board,
        );
        if (_wouldSelfSnipe(state, p1Hand.rank, p1Hand.primaryValue)) {
          continue;
        }
        final w = _p1HandWeight(p1Hand, state, state.p1RiverDeclaration);
        if (w > bestWeight) {
          bestWeight = w;
          bestRank = p1Hand.rank;
          bestValue = p1Hand.primaryValue;
        }
      }
    }

    if (bestRank == null || bestValue == null) return null;
    return SniperTargetSniper(bestRank, bestValue);
  }

  SniperTargetDecision _counterP1Declaration(
    SniperMatchState state,
    ParsedHand p2Hand,
    SniperRiverDeclaration p1Decl,
  ) {
    final guessedP1 = _guessP1Hand(state, p1Decl);
    final equity = _estimateEquityVsHand(state, guessedP1);

    final snipe = _pickBestSnipeTarget(state);
    if (snipe != null && equity >= 0.2) {
      return snipe;
    }

    if (p1Decl.mode == SniperModeSelection.sniper) {
      final v = p1Decl.targetValue ?? guessedP1.primaryValue;
      if (!_wouldSelfSnipe(state, p1Decl.targetRank, v)) {
        return SniperTargetSniper(p1Decl.targetRank, v);
      }
    }

    if (p1Decl.mode == SniperModeSelection.shotgun &&
        state.p2ShotgunCooldownRounds == 0 &&
        equity >= 0.35) {
      return SniperTargetShotgun(guessedP1.rank);
    }

    if (equity >= 0.35 &&
        state.p2ShotgunCooldownRounds == 0 &&
        _random.nextDouble() < 0.4) {
      return SniperTargetShotgun(p2Hand.rank);
    }

    return const SniperTargetPass();
  }

  bool _wouldSelfSnipe(
    SniperMatchState state,
    HandRank rank,
    int value,
  ) {
    if (state.communityCards.length != 4) return false;
    final hand = PokerEvaluator.evaluateBestFour(
      state.p2HoleCards,
      state.communityCards,
    );
    final wideLens = state.p2ActiveSkill == SniperMatchCubit.skillLens;
    return SniperEngine.verifySniperHit(rank, value, hand, wideLens);
  }

  SniperTargetDecision _proactiveTarget(
    SniperMatchState state,
    ParsedHand p2Hand,
  ) {
    final equity = _estimateEquity(state);
    final snipe = _pickBestSnipeTarget(state);

    if (snipe != null) {
      if (equity >= 0.18 || _random.nextDouble() < 0.85) {
        return snipe;
      }
    }

    final p1Guess = _guessP1Hand(state, null);

    if (equity < 0.22) {
      if (state.p2ShotgunCooldownRounds == 0 &&
          _random.nextDouble() < 0.25) {
        return SniperTargetShotgun(p1Guess.rank);
      }
      return const SniperTargetPass();
    }

    if (state.p2ShotgunCooldownRounds == 0 &&
        equity < 0.45 &&
        _random.nextDouble() < 0.3) {
      return SniperTargetShotgun(p1Guess.rank);
    }

    if (snipe != null) {
      return snipe;
    }

    if (!_wouldSelfSnipe(
      state,
      p1Guess.rank,
      p1Guess.primaryValue,
    )) {
      return SniperTargetSniper(p1Guess.rank, p1Guess.primaryValue);
    }

    return const SniperTargetPass();
  }

  ParsedHand _guessP1Hand(
    SniperMatchState state,
    SniperRiverDeclaration? decl,
  ) {
    if (state.communityCards.length == 4) {
      final inferred = _bestLikelyP1FourCardHand(state, decl);
      if (inferred != null) return inferred;
    }

    if (decl != null && decl.mode == SniperModeSelection.sniper) {
      return ParsedHand(
        rank: decl.targetRank,
        primaryValue: decl.targetValue ?? 5,
      );
    }
    if (decl != null && decl.mode == SniperModeSelection.shotgun) {
      return ParsedHand(rank: decl.targetRank, primaryValue: 5);
    }

    return const ParsedHand(rank: HandRank.pair, primaryValue: 5);
  }

  ParsedHand? _bestLikelyP1FourCardHand(
    SniperMatchState state,
    SniperRiverDeclaration? decl,
  ) {
    final board = state.communityCards;
    final known = {
      ...state.p2HoleCards,
      ...board,
    };

    ParsedHand? best;
    var bestWeight = -1.0;

    final deck = _remainingDeck(known);
    for (var i = 0; i < deck.length; i++) {
      for (var j = i + 1; j < deck.length; j++) {
        final holes = [deck[i], deck[j]];
        final hand = PokerEvaluator.evaluateBestFour(holes, board);
        final w = _p1HandWeight(hand, state, decl);
        if (w > bestWeight) {
          bestWeight = w;
          best = hand;
        }
      }
    }
    return best;
  }

  double _p1HandWeight(
    ParsedHand hand,
    SniperMatchState state,
    SniperRiverDeclaration? decl,
  ) {
    var w = _rankScore(hand.rank) * 10 + hand.primaryValue * 0.1;
    if (decl != null) {
      if (decl.mode == SniperModeSelection.sniper &&
          hand.rank == decl.targetRank) {
        w += 8;
        if (decl.targetValue != null &&
            (hand.primaryValue - decl.targetValue!).abs() <= 1) {
          w += 6;
        }
      }
      if (decl.mode == SniperModeSelection.shotgun &&
          hand.rank == decl.targetRank) {
        w += 10;
      }
    }
    if (state.p1RoundInvestment > state.currentAnte * 2) {
      w += _rankScore(hand.rank) * 3;
    }
    return w;
  }

  double _estimateEquity(SniperMatchState state) {
    if (state.communityCards.length == 4) {
      return _enumerateRiverEquity(state);
    }

    final known = {
      ...state.p2HoleCards,
      ...state.communityCards,
    };
    final deck = _remainingDeck(known);
    if (deck.length < 4) return 0.5;

    var wins = 0;
    var samples = 0;
    for (var s = 0; s < _equitySamples; s++) {
      final shuffled = List<SniperCard>.from(deck)..shuffle(_random);
      final futureBoard = [
        ...state.communityCards,
        shuffled[0],
        shuffled[1],
      ];
      final oppHoles = [shuffled[2], shuffled[3]];
      final p2Hand = PokerEvaluator.evaluateBestFour(
        state.p2HoleCards,
        futureBoard,
      );
      final p1Hand = PokerEvaluator.evaluateBestFour(oppHoles, futureBoard);
      samples++;
      if (PokerEvaluator.compareParsedHands(p2Hand, p1Hand) >= 0) wins++;
    }
    return samples == 0 ? 0.5 : wins / samples;
  }

  double _enumerateRiverEquity(SniperMatchState state) {
    final board = state.communityCards;
    final known = {...state.p2HoleCards, ...board};
    final deck = _remainingDeck(known);
    final p2Hand = PokerEvaluator.evaluateBestFour(
      state.p2HoleCards,
      board,
    );

    var wins = 0;
    var ties = 0;
    var total = 0;

    for (var i = 0; i < deck.length; i++) {
      for (var j = i + 1; j < deck.length; j++) {
        final p1Hand = PokerEvaluator.evaluateBestFour(
          [deck[i], deck[j]],
          board,
        );
        total++;
        final cmp = PokerEvaluator.compareParsedHands(p2Hand, p1Hand);
        if (cmp > 0) {
          wins++;
        } else if (cmp == 0) {
          ties++;
        }
      }
    }
    if (total == 0) return 0.5;
    return (wins + ties * 0.5) / total;
  }

  double _estimateEquityVsHand(SniperMatchState state, ParsedHand oppHand) {
    final p2Hand = state.communityCards.length == 4
        ? PokerEvaluator.evaluateBestFour(
            state.p2HoleCards,
            state.communityCards,
          )
        : const ParsedHand(rank: HandRank.highCard, primaryValue: 0);

    final cmp = PokerEvaluator.compareParsedHands(p2Hand, oppHand);
    if (cmp > 0) return 0.85;
    if (cmp < 0) return 0.15;
    return 0.5;
  }

  double _currentHandStrength(SniperMatchState state) {
    if (state.communityCards.isEmpty) return 0.3;
    if (state.communityCards.length < 4) {
      return _estimateEquity(state);
    }
    final hand = PokerEvaluator.evaluateBestFour(
      state.p2HoleCards,
      state.communityCards,
    );
    return _rankScore(hand.rank) / 7.0 + hand.primaryValue / 100.0;
  }

  int _pickRaiseBb({required double strength, required double equity}) {
    if (equity >= 0.7 || strength >= 0.75) {
      return 2 + _random.nextInt(2);
    }
    if (equity >= 0.55) {
      return 1 + _random.nextInt(2);
    }
    return 1;
  }

  static double _rankScore(HandRank rank) => switch (rank) {
        HandRank.highCard => 0,
        HandRank.pair => 1,
        HandRank.twoPair => 2,
        HandRank.threeOfAKind => 3,
        HandRank.straight => 4,
        HandRank.flush => 5,
        HandRank.fourOfAKind => 6,
        HandRank.straightFlush => 7,
      };

  static List<SniperCard> _remainingDeck(Set<SniperCard> known) {
    final out = <SniperCard>[];
    for (final suit in PokerSuit.values) {
      for (var v = 1; v <= 10; v++) {
        final c = SniperCard(suit: suit, value: v);
        if (!known.contains(c)) out.add(c);
      }
    }
    return out;
  }
}

sealed class SniperBettingDecision {
  const SniperBettingDecision();
}

final class SniperBettingFold extends SniperBettingDecision {
  const SniperBettingFold();
}

final class SniperBettingCheckCall extends SniperBettingDecision {
  const SniperBettingCheckCall();
}

final class SniperBettingRaise extends SniperBettingDecision {
  const SniperBettingRaise({required this.bbUnits});
  final int bbUnits;
}

sealed class SniperTargetDecision {
  const SniperTargetDecision();
}

final class SniperTargetPass extends SniperTargetDecision {
  const SniperTargetPass();
}

final class SniperTargetSniper extends SniperTargetDecision {
  const SniperTargetSniper(this.rank, this.value);
  final HandRank rank;
  final int value;
}

final class SniperTargetShotgun extends SniperTargetDecision {
  const SniperTargetShotgun(this.rank);
  final HandRank rank;
}
