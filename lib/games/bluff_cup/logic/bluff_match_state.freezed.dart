// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluff_match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BluffMatchState {
  /// Seat whose action is expected (bid or catch).
  CupPlayerId get currentTurn => throw _privateConstructorUsedError;

  /// Local player cup (six dice, one blind).
  List<DiceModel> get p1Dice => throw _privateConstructorUsedError;

  /// Opponent cup (six dice, one blind).
  List<DiceModel> get p2Dice => throw _privateConstructorUsedError;

  /// Latest bid this round; `null` before the first bid.
  BidModel? get currentBid => throw _privateConstructorUsedError;

  /// `true` after [BluffMatchCubit.callCatch] until [nextRound].
  bool get isShowdown => throw _privateConstructorUsedError;

  /// Set when [isShowdown] is resolved; cleared on [nextRound].
  CupPlayerId? get winner => throw _privateConstructorUsedError;

  /// Seconds left for the local player (`p1`) to act; `null` on opponent turn or after round ends.
  int? get p1TurnSecondsRemaining => throw _privateConstructorUsedError;

  /// `true` when [winner] is [CupPlayerId.p2] because [p1] did not act in time.
  bool get endedByP1TimeForfeit => throw _privateConstructorUsedError;

  /// Which round is in progress (`0`..[BluffMatchRules.totalRounds] - 1).
  int get currentRoundIndex => throw _privateConstructorUsedError;

  /// Randomly chosen opener for round 1; later rounds follow [BluffMatchRules.openingPlayerForRound].
  CupPlayerId get matchFirstPlayer => throw _privateConstructorUsedError;

  /// Outcome per round slot; `null` = not played yet.
  List<CupPlayerId?> get roundResults => throw _privateConstructorUsedError;

  /// Set when either side reaches [BluffMatchRules.winsToWinMatch] round wins.
  CupPlayerId? get matchWinner => throw _privateConstructorUsedError;

  /// Brief banner at the start of each round showing who bids first.
  bool get showRoundOpenerOverlay => throw _privateConstructorUsedError;

  /// `false` after any bid on face `1` this round (pure / 叫齋).
  bool get wildcardsActiveThisRound => throw _privateConstructorUsedError;

  /// Local player's bids this round (for AI bluff reads).
  List<BidModel> get playerBidsThisRound => throw _privateConstructorUsedError;

  /// Create a copy of BluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BluffMatchStateCopyWith<BluffMatchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BluffMatchStateCopyWith<$Res> {
  factory $BluffMatchStateCopyWith(
          BluffMatchState value, $Res Function(BluffMatchState) then) =
      _$BluffMatchStateCopyWithImpl<$Res, BluffMatchState>;
  @useResult
  $Res call(
      {CupPlayerId currentTurn,
      List<DiceModel> p1Dice,
      List<DiceModel> p2Dice,
      BidModel? currentBid,
      bool isShowdown,
      CupPlayerId? winner,
      int? p1TurnSecondsRemaining,
      bool endedByP1TimeForfeit,
      int currentRoundIndex,
      CupPlayerId matchFirstPlayer,
      List<CupPlayerId?> roundResults,
      CupPlayerId? matchWinner,
      bool showRoundOpenerOverlay,
      bool wildcardsActiveThisRound,
      List<BidModel> playerBidsThisRound});
}

/// @nodoc
class _$BluffMatchStateCopyWithImpl<$Res, $Val extends BluffMatchState>
    implements $BluffMatchStateCopyWith<$Res> {
  _$BluffMatchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTurn = null,
    Object? p1Dice = null,
    Object? p2Dice = null,
    Object? currentBid = freezed,
    Object? isShowdown = null,
    Object? winner = freezed,
    Object? p1TurnSecondsRemaining = freezed,
    Object? endedByP1TimeForfeit = null,
    Object? currentRoundIndex = null,
    Object? matchFirstPlayer = null,
    Object? roundResults = null,
    Object? matchWinner = freezed,
    Object? showRoundOpenerOverlay = null,
    Object? wildcardsActiveThisRound = null,
    Object? playerBidsThisRound = null,
  }) {
    return _then(_value.copyWith(
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as CupPlayerId,
      p1Dice: null == p1Dice
          ? _value.p1Dice
          : p1Dice // ignore: cast_nullable_to_non_nullable
              as List<DiceModel>,
      p2Dice: null == p2Dice
          ? _value.p2Dice
          : p2Dice // ignore: cast_nullable_to_non_nullable
              as List<DiceModel>,
      currentBid: freezed == currentBid
          ? _value.currentBid
          : currentBid // ignore: cast_nullable_to_non_nullable
              as BidModel?,
      isShowdown: null == isShowdown
          ? _value.isShowdown
          : isShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      winner: freezed == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as CupPlayerId?,
      p1TurnSecondsRemaining: freezed == p1TurnSecondsRemaining
          ? _value.p1TurnSecondsRemaining
          : p1TurnSecondsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      endedByP1TimeForfeit: null == endedByP1TimeForfeit
          ? _value.endedByP1TimeForfeit
          : endedByP1TimeForfeit // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRoundIndex: null == currentRoundIndex
          ? _value.currentRoundIndex
          : currentRoundIndex // ignore: cast_nullable_to_non_nullable
              as int,
      matchFirstPlayer: null == matchFirstPlayer
          ? _value.matchFirstPlayer
          : matchFirstPlayer // ignore: cast_nullable_to_non_nullable
              as CupPlayerId,
      roundResults: null == roundResults
          ? _value.roundResults
          : roundResults // ignore: cast_nullable_to_non_nullable
              as List<CupPlayerId?>,
      matchWinner: freezed == matchWinner
          ? _value.matchWinner
          : matchWinner // ignore: cast_nullable_to_non_nullable
              as CupPlayerId?,
      showRoundOpenerOverlay: null == showRoundOpenerOverlay
          ? _value.showRoundOpenerOverlay
          : showRoundOpenerOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      wildcardsActiveThisRound: null == wildcardsActiveThisRound
          ? _value.wildcardsActiveThisRound
          : wildcardsActiveThisRound // ignore: cast_nullable_to_non_nullable
              as bool,
      playerBidsThisRound: null == playerBidsThisRound
          ? _value.playerBidsThisRound
          : playerBidsThisRound // ignore: cast_nullable_to_non_nullable
              as List<BidModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BluffMatchStateImplCopyWith<$Res>
    implements $BluffMatchStateCopyWith<$Res> {
  factory _$$BluffMatchStateImplCopyWith(_$BluffMatchStateImpl value,
          $Res Function(_$BluffMatchStateImpl) then) =
      __$$BluffMatchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CupPlayerId currentTurn,
      List<DiceModel> p1Dice,
      List<DiceModel> p2Dice,
      BidModel? currentBid,
      bool isShowdown,
      CupPlayerId? winner,
      int? p1TurnSecondsRemaining,
      bool endedByP1TimeForfeit,
      int currentRoundIndex,
      CupPlayerId matchFirstPlayer,
      List<CupPlayerId?> roundResults,
      CupPlayerId? matchWinner,
      bool showRoundOpenerOverlay,
      bool wildcardsActiveThisRound,
      List<BidModel> playerBidsThisRound});
}

/// @nodoc
class __$$BluffMatchStateImplCopyWithImpl<$Res>
    extends _$BluffMatchStateCopyWithImpl<$Res, _$BluffMatchStateImpl>
    implements _$$BluffMatchStateImplCopyWith<$Res> {
  __$$BluffMatchStateImplCopyWithImpl(
      _$BluffMatchStateImpl _value, $Res Function(_$BluffMatchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTurn = null,
    Object? p1Dice = null,
    Object? p2Dice = null,
    Object? currentBid = freezed,
    Object? isShowdown = null,
    Object? winner = freezed,
    Object? p1TurnSecondsRemaining = freezed,
    Object? endedByP1TimeForfeit = null,
    Object? currentRoundIndex = null,
    Object? matchFirstPlayer = null,
    Object? roundResults = null,
    Object? matchWinner = freezed,
    Object? showRoundOpenerOverlay = null,
    Object? wildcardsActiveThisRound = null,
    Object? playerBidsThisRound = null,
  }) {
    return _then(_$BluffMatchStateImpl(
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as CupPlayerId,
      p1Dice: null == p1Dice
          ? _value._p1Dice
          : p1Dice // ignore: cast_nullable_to_non_nullable
              as List<DiceModel>,
      p2Dice: null == p2Dice
          ? _value._p2Dice
          : p2Dice // ignore: cast_nullable_to_non_nullable
              as List<DiceModel>,
      currentBid: freezed == currentBid
          ? _value.currentBid
          : currentBid // ignore: cast_nullable_to_non_nullable
              as BidModel?,
      isShowdown: null == isShowdown
          ? _value.isShowdown
          : isShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      winner: freezed == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as CupPlayerId?,
      p1TurnSecondsRemaining: freezed == p1TurnSecondsRemaining
          ? _value.p1TurnSecondsRemaining
          : p1TurnSecondsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      endedByP1TimeForfeit: null == endedByP1TimeForfeit
          ? _value.endedByP1TimeForfeit
          : endedByP1TimeForfeit // ignore: cast_nullable_to_non_nullable
              as bool,
      currentRoundIndex: null == currentRoundIndex
          ? _value.currentRoundIndex
          : currentRoundIndex // ignore: cast_nullable_to_non_nullable
              as int,
      matchFirstPlayer: null == matchFirstPlayer
          ? _value.matchFirstPlayer
          : matchFirstPlayer // ignore: cast_nullable_to_non_nullable
              as CupPlayerId,
      roundResults: null == roundResults
          ? _value._roundResults
          : roundResults // ignore: cast_nullable_to_non_nullable
              as List<CupPlayerId?>,
      matchWinner: freezed == matchWinner
          ? _value.matchWinner
          : matchWinner // ignore: cast_nullable_to_non_nullable
              as CupPlayerId?,
      showRoundOpenerOverlay: null == showRoundOpenerOverlay
          ? _value.showRoundOpenerOverlay
          : showRoundOpenerOverlay // ignore: cast_nullable_to_non_nullable
              as bool,
      wildcardsActiveThisRound: null == wildcardsActiveThisRound
          ? _value.wildcardsActiveThisRound
          : wildcardsActiveThisRound // ignore: cast_nullable_to_non_nullable
              as bool,
      playerBidsThisRound: null == playerBidsThisRound
          ? _value._playerBidsThisRound
          : playerBidsThisRound // ignore: cast_nullable_to_non_nullable
              as List<BidModel>,
    ));
  }
}

/// @nodoc

class _$BluffMatchStateImpl implements _BluffMatchState {
  const _$BluffMatchStateImpl(
      {required this.currentTurn,
      required final List<DiceModel> p1Dice,
      required final List<DiceModel> p2Dice,
      this.currentBid,
      required this.isShowdown,
      this.winner,
      this.p1TurnSecondsRemaining,
      this.endedByP1TimeForfeit = false,
      this.currentRoundIndex = 0,
      required this.matchFirstPlayer,
      final List<CupPlayerId?> roundResults = BluffMatchRules.emptyRoundResults,
      this.matchWinner,
      this.showRoundOpenerOverlay = false,
      this.wildcardsActiveThisRound = true,
      final List<BidModel> playerBidsThisRound = const <BidModel>[]})
      : _p1Dice = p1Dice,
        _p2Dice = p2Dice,
        _roundResults = roundResults,
        _playerBidsThisRound = playerBidsThisRound;

  /// Seat whose action is expected (bid or catch).
  @override
  final CupPlayerId currentTurn;

  /// Local player cup (six dice, one blind).
  final List<DiceModel> _p1Dice;

  /// Local player cup (six dice, one blind).
  @override
  List<DiceModel> get p1Dice {
    if (_p1Dice is EqualUnmodifiableListView) return _p1Dice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p1Dice);
  }

  /// Opponent cup (six dice, one blind).
  final List<DiceModel> _p2Dice;

  /// Opponent cup (six dice, one blind).
  @override
  List<DiceModel> get p2Dice {
    if (_p2Dice is EqualUnmodifiableListView) return _p2Dice;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p2Dice);
  }

  /// Latest bid this round; `null` before the first bid.
  @override
  final BidModel? currentBid;

  /// `true` after [BluffMatchCubit.callCatch] until [nextRound].
  @override
  final bool isShowdown;

  /// Set when [isShowdown] is resolved; cleared on [nextRound].
  @override
  final CupPlayerId? winner;

  /// Seconds left for the local player (`p1`) to act; `null` on opponent turn or after round ends.
  @override
  final int? p1TurnSecondsRemaining;

  /// `true` when [winner] is [CupPlayerId.p2] because [p1] did not act in time.
  @override
  @JsonKey()
  final bool endedByP1TimeForfeit;

  /// Which round is in progress (`0`..[BluffMatchRules.totalRounds] - 1).
  @override
  @JsonKey()
  final int currentRoundIndex;

  /// Randomly chosen opener for round 1; later rounds follow [BluffMatchRules.openingPlayerForRound].
  @override
  final CupPlayerId matchFirstPlayer;

  /// Outcome per round slot; `null` = not played yet.
  final List<CupPlayerId?> _roundResults;

  /// Outcome per round slot; `null` = not played yet.
  @override
  @JsonKey()
  List<CupPlayerId?> get roundResults {
    if (_roundResults is EqualUnmodifiableListView) return _roundResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_roundResults);
  }

  /// Set when either side reaches [BluffMatchRules.winsToWinMatch] round wins.
  @override
  final CupPlayerId? matchWinner;

  /// Brief banner at the start of each round showing who bids first.
  @override
  @JsonKey()
  final bool showRoundOpenerOverlay;

  /// `false` after any bid on face `1` this round (pure / 叫齋).
  @override
  @JsonKey()
  final bool wildcardsActiveThisRound;

  /// Local player's bids this round (for AI bluff reads).
  final List<BidModel> _playerBidsThisRound;

  /// Local player's bids this round (for AI bluff reads).
  @override
  @JsonKey()
  List<BidModel> get playerBidsThisRound {
    if (_playerBidsThisRound is EqualUnmodifiableListView)
      return _playerBidsThisRound;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerBidsThisRound);
  }

  @override
  String toString() {
    return 'BluffMatchState(currentTurn: $currentTurn, p1Dice: $p1Dice, p2Dice: $p2Dice, currentBid: $currentBid, isShowdown: $isShowdown, winner: $winner, p1TurnSecondsRemaining: $p1TurnSecondsRemaining, endedByP1TimeForfeit: $endedByP1TimeForfeit, currentRoundIndex: $currentRoundIndex, matchFirstPlayer: $matchFirstPlayer, roundResults: $roundResults, matchWinner: $matchWinner, showRoundOpenerOverlay: $showRoundOpenerOverlay, wildcardsActiveThisRound: $wildcardsActiveThisRound, playerBidsThisRound: $playerBidsThisRound)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BluffMatchStateImpl &&
            (identical(other.currentTurn, currentTurn) ||
                other.currentTurn == currentTurn) &&
            const DeepCollectionEquality().equals(other._p1Dice, _p1Dice) &&
            const DeepCollectionEquality().equals(other._p2Dice, _p2Dice) &&
            (identical(other.currentBid, currentBid) ||
                other.currentBid == currentBid) &&
            (identical(other.isShowdown, isShowdown) ||
                other.isShowdown == isShowdown) &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.p1TurnSecondsRemaining, p1TurnSecondsRemaining) ||
                other.p1TurnSecondsRemaining == p1TurnSecondsRemaining) &&
            (identical(other.endedByP1TimeForfeit, endedByP1TimeForfeit) ||
                other.endedByP1TimeForfeit == endedByP1TimeForfeit) &&
            (identical(other.currentRoundIndex, currentRoundIndex) ||
                other.currentRoundIndex == currentRoundIndex) &&
            (identical(other.matchFirstPlayer, matchFirstPlayer) ||
                other.matchFirstPlayer == matchFirstPlayer) &&
            const DeepCollectionEquality()
                .equals(other._roundResults, _roundResults) &&
            (identical(other.matchWinner, matchWinner) ||
                other.matchWinner == matchWinner) &&
            (identical(other.showRoundOpenerOverlay, showRoundOpenerOverlay) ||
                other.showRoundOpenerOverlay == showRoundOpenerOverlay) &&
            (identical(
                    other.wildcardsActiveThisRound, wildcardsActiveThisRound) ||
                other.wildcardsActiveThisRound == wildcardsActiveThisRound) &&
            const DeepCollectionEquality()
                .equals(other._playerBidsThisRound, _playerBidsThisRound));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentTurn,
      const DeepCollectionEquality().hash(_p1Dice),
      const DeepCollectionEquality().hash(_p2Dice),
      currentBid,
      isShowdown,
      winner,
      p1TurnSecondsRemaining,
      endedByP1TimeForfeit,
      currentRoundIndex,
      matchFirstPlayer,
      const DeepCollectionEquality().hash(_roundResults),
      matchWinner,
      showRoundOpenerOverlay,
      wildcardsActiveThisRound,
      const DeepCollectionEquality().hash(_playerBidsThisRound));

  /// Create a copy of BluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BluffMatchStateImplCopyWith<_$BluffMatchStateImpl> get copyWith =>
      __$$BluffMatchStateImplCopyWithImpl<_$BluffMatchStateImpl>(
          this, _$identity);
}

abstract class _BluffMatchState implements BluffMatchState {
  const factory _BluffMatchState(
      {required final CupPlayerId currentTurn,
      required final List<DiceModel> p1Dice,
      required final List<DiceModel> p2Dice,
      final BidModel? currentBid,
      required final bool isShowdown,
      final CupPlayerId? winner,
      final int? p1TurnSecondsRemaining,
      final bool endedByP1TimeForfeit,
      final int currentRoundIndex,
      required final CupPlayerId matchFirstPlayer,
      final List<CupPlayerId?> roundResults,
      final CupPlayerId? matchWinner,
      final bool showRoundOpenerOverlay,
      final bool wildcardsActiveThisRound,
      final List<BidModel> playerBidsThisRound}) = _$BluffMatchStateImpl;

  /// Seat whose action is expected (bid or catch).
  @override
  CupPlayerId get currentTurn;

  /// Local player cup (six dice, one blind).
  @override
  List<DiceModel> get p1Dice;

  /// Opponent cup (six dice, one blind).
  @override
  List<DiceModel> get p2Dice;

  /// Latest bid this round; `null` before the first bid.
  @override
  BidModel? get currentBid;

  /// `true` after [BluffMatchCubit.callCatch] until [nextRound].
  @override
  bool get isShowdown;

  /// Set when [isShowdown] is resolved; cleared on [nextRound].
  @override
  CupPlayerId? get winner;

  /// Seconds left for the local player (`p1`) to act; `null` on opponent turn or after round ends.
  @override
  int? get p1TurnSecondsRemaining;

  /// `true` when [winner] is [CupPlayerId.p2] because [p1] did not act in time.
  @override
  bool get endedByP1TimeForfeit;

  /// Which round is in progress (`0`..[BluffMatchRules.totalRounds] - 1).
  @override
  int get currentRoundIndex;

  /// Randomly chosen opener for round 1; later rounds follow [BluffMatchRules.openingPlayerForRound].
  @override
  CupPlayerId get matchFirstPlayer;

  /// Outcome per round slot; `null` = not played yet.
  @override
  List<CupPlayerId?> get roundResults;

  /// Set when either side reaches [BluffMatchRules.winsToWinMatch] round wins.
  @override
  CupPlayerId? get matchWinner;

  /// Brief banner at the start of each round showing who bids first.
  @override
  bool get showRoundOpenerOverlay;

  /// `false` after any bid on face `1` this round (pure / 叫齋).
  @override
  bool get wildcardsActiveThisRound;

  /// Local player's bids this round (for AI bluff reads).
  @override
  List<BidModel> get playerBidsThisRound;

  /// Create a copy of BluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BluffMatchStateImplCopyWith<_$BluffMatchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
