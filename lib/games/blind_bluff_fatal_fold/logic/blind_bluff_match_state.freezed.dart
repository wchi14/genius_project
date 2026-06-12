// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_bluff_match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlindBluffRoundResolution {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)
        fold,
    required TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)
        showdown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult? Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FoldResolution value) fold,
    required TResult Function(_ShowdownResolution value) showdown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FoldResolution value)? fold,
    TResult? Function(_ShowdownResolution value)? showdown,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FoldResolution value)? fold,
    TResult Function(_ShowdownResolution value)? showdown,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlindBluffRoundResolutionCopyWith<$Res> {
  factory $BlindBluffRoundResolutionCopyWith(BlindBluffRoundResolution value,
          $Res Function(BlindBluffRoundResolution) then) =
      _$BlindBluffRoundResolutionCopyWithImpl<$Res, BlindBluffRoundResolution>;
}

/// @nodoc
class _$BlindBluffRoundResolutionCopyWithImpl<$Res,
        $Val extends BlindBluffRoundResolution>
    implements $BlindBluffRoundResolutionCopyWith<$Res> {
  _$BlindBluffRoundResolutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$FoldResolutionImplCopyWith<$Res> {
  factory _$$FoldResolutionImplCopyWith(_$FoldResolutionImpl value,
          $Res Function(_$FoldResolutionImpl) then) =
      __$$FoldResolutionImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BlindBluffPlayerId potWinner,
      BlindBluffPlayerId foldingPlayer,
      BlindCard foldingPlayersCard,
      BlindCard opponentsVisibleCard,
      int potAwarded,
      bool fatalFoldPenaltyApplied,
      int fatalFoldPenaltyPaid});
}

/// @nodoc
class __$$FoldResolutionImplCopyWithImpl<$Res>
    extends _$BlindBluffRoundResolutionCopyWithImpl<$Res, _$FoldResolutionImpl>
    implements _$$FoldResolutionImplCopyWith<$Res> {
  __$$FoldResolutionImplCopyWithImpl(
      _$FoldResolutionImpl _value, $Res Function(_$FoldResolutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? potWinner = null,
    Object? foldingPlayer = null,
    Object? foldingPlayersCard = null,
    Object? opponentsVisibleCard = null,
    Object? potAwarded = null,
    Object? fatalFoldPenaltyApplied = null,
    Object? fatalFoldPenaltyPaid = null,
  }) {
    return _then(_$FoldResolutionImpl(
      potWinner: null == potWinner
          ? _value.potWinner
          : potWinner // ignore: cast_nullable_to_non_nullable
              as BlindBluffPlayerId,
      foldingPlayer: null == foldingPlayer
          ? _value.foldingPlayer
          : foldingPlayer // ignore: cast_nullable_to_non_nullable
              as BlindBluffPlayerId,
      foldingPlayersCard: null == foldingPlayersCard
          ? _value.foldingPlayersCard
          : foldingPlayersCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      opponentsVisibleCard: null == opponentsVisibleCard
          ? _value.opponentsVisibleCard
          : opponentsVisibleCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      potAwarded: null == potAwarded
          ? _value.potAwarded
          : potAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      fatalFoldPenaltyApplied: null == fatalFoldPenaltyApplied
          ? _value.fatalFoldPenaltyApplied
          : fatalFoldPenaltyApplied // ignore: cast_nullable_to_non_nullable
              as bool,
      fatalFoldPenaltyPaid: null == fatalFoldPenaltyPaid
          ? _value.fatalFoldPenaltyPaid
          : fatalFoldPenaltyPaid // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$FoldResolutionImpl implements _FoldResolution {
  const _$FoldResolutionImpl(
      {required this.potWinner,
      required this.foldingPlayer,
      required this.foldingPlayersCard,
      required this.opponentsVisibleCard,
      required this.potAwarded,
      required this.fatalFoldPenaltyApplied,
      required this.fatalFoldPenaltyPaid});

  @override
  final BlindBluffPlayerId potWinner;
  @override
  final BlindBluffPlayerId foldingPlayer;
  @override
  final BlindCard foldingPlayersCard;
  @override
  final BlindCard opponentsVisibleCard;
  @override
  final int potAwarded;
  @override
  final bool fatalFoldPenaltyApplied;
  @override
  final int fatalFoldPenaltyPaid;

  @override
  String toString() {
    return 'BlindBluffRoundResolution.fold(potWinner: $potWinner, foldingPlayer: $foldingPlayer, foldingPlayersCard: $foldingPlayersCard, opponentsVisibleCard: $opponentsVisibleCard, potAwarded: $potAwarded, fatalFoldPenaltyApplied: $fatalFoldPenaltyApplied, fatalFoldPenaltyPaid: $fatalFoldPenaltyPaid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoldResolutionImpl &&
            (identical(other.potWinner, potWinner) ||
                other.potWinner == potWinner) &&
            (identical(other.foldingPlayer, foldingPlayer) ||
                other.foldingPlayer == foldingPlayer) &&
            (identical(other.foldingPlayersCard, foldingPlayersCard) ||
                other.foldingPlayersCard == foldingPlayersCard) &&
            (identical(other.opponentsVisibleCard, opponentsVisibleCard) ||
                other.opponentsVisibleCard == opponentsVisibleCard) &&
            (identical(other.potAwarded, potAwarded) ||
                other.potAwarded == potAwarded) &&
            (identical(
                    other.fatalFoldPenaltyApplied, fatalFoldPenaltyApplied) ||
                other.fatalFoldPenaltyApplied == fatalFoldPenaltyApplied) &&
            (identical(other.fatalFoldPenaltyPaid, fatalFoldPenaltyPaid) ||
                other.fatalFoldPenaltyPaid == fatalFoldPenaltyPaid));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      potWinner,
      foldingPlayer,
      foldingPlayersCard,
      opponentsVisibleCard,
      potAwarded,
      fatalFoldPenaltyApplied,
      fatalFoldPenaltyPaid);

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FoldResolutionImplCopyWith<_$FoldResolutionImpl> get copyWith =>
      __$$FoldResolutionImplCopyWithImpl<_$FoldResolutionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)
        fold,
    required TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)
        showdown,
  }) {
    return fold(
        potWinner,
        foldingPlayer,
        foldingPlayersCard,
        opponentsVisibleCard,
        potAwarded,
        fatalFoldPenaltyApplied,
        fatalFoldPenaltyPaid);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult? Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
  }) {
    return fold?.call(
        potWinner,
        foldingPlayer,
        foldingPlayersCard,
        opponentsVisibleCard,
        potAwarded,
        fatalFoldPenaltyApplied,
        fatalFoldPenaltyPaid);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
    required TResult orElse(),
  }) {
    if (fold != null) {
      return fold(
          potWinner,
          foldingPlayer,
          foldingPlayersCard,
          opponentsVisibleCard,
          potAwarded,
          fatalFoldPenaltyApplied,
          fatalFoldPenaltyPaid);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FoldResolution value) fold,
    required TResult Function(_ShowdownResolution value) showdown,
  }) {
    return fold(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FoldResolution value)? fold,
    TResult? Function(_ShowdownResolution value)? showdown,
  }) {
    return fold?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FoldResolution value)? fold,
    TResult Function(_ShowdownResolution value)? showdown,
    required TResult orElse(),
  }) {
    if (fold != null) {
      return fold(this);
    }
    return orElse();
  }
}

abstract class _FoldResolution implements BlindBluffRoundResolution {
  const factory _FoldResolution(
      {required final BlindBluffPlayerId potWinner,
      required final BlindBluffPlayerId foldingPlayer,
      required final BlindCard foldingPlayersCard,
      required final BlindCard opponentsVisibleCard,
      required final int potAwarded,
      required final bool fatalFoldPenaltyApplied,
      required final int fatalFoldPenaltyPaid}) = _$FoldResolutionImpl;

  BlindBluffPlayerId get potWinner;
  BlindBluffPlayerId get foldingPlayer;
  BlindCard get foldingPlayersCard;
  BlindCard get opponentsVisibleCard;
  int get potAwarded;
  bool get fatalFoldPenaltyApplied;
  int get fatalFoldPenaltyPaid;

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FoldResolutionImplCopyWith<_$FoldResolutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ShowdownResolutionImplCopyWith<$Res> {
  factory _$$ShowdownResolutionImplCopyWith(_$ShowdownResolutionImpl value,
          $Res Function(_$ShowdownResolutionImpl) then) =
      __$$ShowdownResolutionImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {ShowdownOutcome outcome,
      BlindCard playerOneCard,
      BlindCard playerTwoCard,
      bool playerOneUsedPlusTwo,
      bool playerTwoUsedPlusTwo,
      int potAwardedToWinner,
      int matchedWagerPerSeat,
      int rolledPotNextRound});
}

/// @nodoc
class __$$ShowdownResolutionImplCopyWithImpl<$Res>
    extends _$BlindBluffRoundResolutionCopyWithImpl<$Res,
        _$ShowdownResolutionImpl>
    implements _$$ShowdownResolutionImplCopyWith<$Res> {
  __$$ShowdownResolutionImplCopyWithImpl(_$ShowdownResolutionImpl _value,
      $Res Function(_$ShowdownResolutionImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? outcome = null,
    Object? playerOneCard = null,
    Object? playerTwoCard = null,
    Object? playerOneUsedPlusTwo = null,
    Object? playerTwoUsedPlusTwo = null,
    Object? potAwardedToWinner = null,
    Object? matchedWagerPerSeat = null,
    Object? rolledPotNextRound = null,
  }) {
    return _then(_$ShowdownResolutionImpl(
      outcome: null == outcome
          ? _value.outcome
          : outcome // ignore: cast_nullable_to_non_nullable
              as ShowdownOutcome,
      playerOneCard: null == playerOneCard
          ? _value.playerOneCard
          : playerOneCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      playerTwoCard: null == playerTwoCard
          ? _value.playerTwoCard
          : playerTwoCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      playerOneUsedPlusTwo: null == playerOneUsedPlusTwo
          ? _value.playerOneUsedPlusTwo
          : playerOneUsedPlusTwo // ignore: cast_nullable_to_non_nullable
              as bool,
      playerTwoUsedPlusTwo: null == playerTwoUsedPlusTwo
          ? _value.playerTwoUsedPlusTwo
          : playerTwoUsedPlusTwo // ignore: cast_nullable_to_non_nullable
              as bool,
      potAwardedToWinner: null == potAwardedToWinner
          ? _value.potAwardedToWinner
          : potAwardedToWinner // ignore: cast_nullable_to_non_nullable
              as int,
      matchedWagerPerSeat: null == matchedWagerPerSeat
          ? _value.matchedWagerPerSeat
          : matchedWagerPerSeat // ignore: cast_nullable_to_non_nullable
              as int,
      rolledPotNextRound: null == rolledPotNextRound
          ? _value.rolledPotNextRound
          : rolledPotNextRound // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ShowdownResolutionImpl implements _ShowdownResolution {
  const _$ShowdownResolutionImpl(
      {required this.outcome,
      required this.playerOneCard,
      required this.playerTwoCard,
      required this.playerOneUsedPlusTwo,
      required this.playerTwoUsedPlusTwo,
      required this.potAwardedToWinner,
      required this.matchedWagerPerSeat,
      required this.rolledPotNextRound});

  @override
  final ShowdownOutcome outcome;
  @override
  final BlindCard playerOneCard;
  @override
  final BlindCard playerTwoCard;
  @override
  final bool playerOneUsedPlusTwo;
  @override
  final bool playerTwoUsedPlusTwo;
  @override
  final int potAwardedToWinner;

  /// Chips each seat matched on this street (min of the two contributions).
  @override
  final int matchedWagerPerSeat;
  @override
  final int rolledPotNextRound;

  @override
  String toString() {
    return 'BlindBluffRoundResolution.showdown(outcome: $outcome, playerOneCard: $playerOneCard, playerTwoCard: $playerTwoCard, playerOneUsedPlusTwo: $playerOneUsedPlusTwo, playerTwoUsedPlusTwo: $playerTwoUsedPlusTwo, potAwardedToWinner: $potAwardedToWinner, matchedWagerPerSeat: $matchedWagerPerSeat, rolledPotNextRound: $rolledPotNextRound)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShowdownResolutionImpl &&
            (identical(other.outcome, outcome) || other.outcome == outcome) &&
            (identical(other.playerOneCard, playerOneCard) ||
                other.playerOneCard == playerOneCard) &&
            (identical(other.playerTwoCard, playerTwoCard) ||
                other.playerTwoCard == playerTwoCard) &&
            (identical(other.playerOneUsedPlusTwo, playerOneUsedPlusTwo) ||
                other.playerOneUsedPlusTwo == playerOneUsedPlusTwo) &&
            (identical(other.playerTwoUsedPlusTwo, playerTwoUsedPlusTwo) ||
                other.playerTwoUsedPlusTwo == playerTwoUsedPlusTwo) &&
            (identical(other.potAwardedToWinner, potAwardedToWinner) ||
                other.potAwardedToWinner == potAwardedToWinner) &&
            (identical(other.matchedWagerPerSeat, matchedWagerPerSeat) ||
                other.matchedWagerPerSeat == matchedWagerPerSeat) &&
            (identical(other.rolledPotNextRound, rolledPotNextRound) ||
                other.rolledPotNextRound == rolledPotNextRound));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      outcome,
      playerOneCard,
      playerTwoCard,
      playerOneUsedPlusTwo,
      playerTwoUsedPlusTwo,
      potAwardedToWinner,
      matchedWagerPerSeat,
      rolledPotNextRound);

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShowdownResolutionImplCopyWith<_$ShowdownResolutionImpl> get copyWith =>
      __$$ShowdownResolutionImplCopyWithImpl<_$ShowdownResolutionImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)
        fold,
    required TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)
        showdown,
  }) {
    return showdown(
        outcome,
        playerOneCard,
        playerTwoCard,
        playerOneUsedPlusTwo,
        playerTwoUsedPlusTwo,
        potAwardedToWinner,
        matchedWagerPerSeat,
        rolledPotNextRound);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult? Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
  }) {
    return showdown?.call(
        outcome,
        playerOneCard,
        playerTwoCard,
        playerOneUsedPlusTwo,
        playerTwoUsedPlusTwo,
        potAwardedToWinner,
        matchedWagerPerSeat,
        rolledPotNextRound);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            BlindBluffPlayerId potWinner,
            BlindBluffPlayerId foldingPlayer,
            BlindCard foldingPlayersCard,
            BlindCard opponentsVisibleCard,
            int potAwarded,
            bool fatalFoldPenaltyApplied,
            int fatalFoldPenaltyPaid)?
        fold,
    TResult Function(
            ShowdownOutcome outcome,
            BlindCard playerOneCard,
            BlindCard playerTwoCard,
            bool playerOneUsedPlusTwo,
            bool playerTwoUsedPlusTwo,
            int potAwardedToWinner,
            int matchedWagerPerSeat,
            int rolledPotNextRound)?
        showdown,
    required TResult orElse(),
  }) {
    if (showdown != null) {
      return showdown(
          outcome,
          playerOneCard,
          playerTwoCard,
          playerOneUsedPlusTwo,
          playerTwoUsedPlusTwo,
          potAwardedToWinner,
          matchedWagerPerSeat,
          rolledPotNextRound);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_FoldResolution value) fold,
    required TResult Function(_ShowdownResolution value) showdown,
  }) {
    return showdown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_FoldResolution value)? fold,
    TResult? Function(_ShowdownResolution value)? showdown,
  }) {
    return showdown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_FoldResolution value)? fold,
    TResult Function(_ShowdownResolution value)? showdown,
    required TResult orElse(),
  }) {
    if (showdown != null) {
      return showdown(this);
    }
    return orElse();
  }
}

abstract class _ShowdownResolution implements BlindBluffRoundResolution {
  const factory _ShowdownResolution(
      {required final ShowdownOutcome outcome,
      required final BlindCard playerOneCard,
      required final BlindCard playerTwoCard,
      required final bool playerOneUsedPlusTwo,
      required final bool playerTwoUsedPlusTwo,
      required final int potAwardedToWinner,
      required final int matchedWagerPerSeat,
      required final int rolledPotNextRound}) = _$ShowdownResolutionImpl;

  ShowdownOutcome get outcome;
  BlindCard get playerOneCard;
  BlindCard get playerTwoCard;
  bool get playerOneUsedPlusTwo;
  bool get playerTwoUsedPlusTwo;
  int get potAwardedToWinner;

  /// Chips each seat matched on this street (min of the two contributions).
  int get matchedWagerPerSeat;
  int get rolledPotNextRound;

  /// Create a copy of BlindBluffRoundResolution
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShowdownResolutionImplCopyWith<_$ShowdownResolutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BlindBluffSnapshot {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlindBluffSnapshotCopyWith<$Res> {
  factory $BlindBluffSnapshotCopyWith(
          BlindBluffSnapshot value, $Res Function(BlindBluffSnapshot) then) =
      _$BlindBluffSnapshotCopyWithImpl<$Res, BlindBluffSnapshot>;
}

/// @nodoc
class _$BlindBluffSnapshotCopyWithImpl<$Res, $Val extends BlindBluffSnapshot>
    implements $BlindBluffSnapshotCopyWith<$Res> {
  _$BlindBluffSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$IdleBetweenRoundsImplCopyWith<$Res> {
  factory _$$IdleBetweenRoundsImplCopyWith(_$IdleBetweenRoundsImpl value,
          $Res Function(_$IdleBetweenRoundsImpl) then) =
      __$$IdleBetweenRoundsImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int completedRounds,
      int playerOneChips,
      int playerTwoChips,
      int baseAnte,
      int rolledPotCarryover,
      Set<BlindBluffSkill> skillsRemainingPlayerOne,
      Set<BlindBluffSkill> skillsRemainingPlayerTwo});
}

/// @nodoc
class __$$IdleBetweenRoundsImplCopyWithImpl<$Res>
    extends _$BlindBluffSnapshotCopyWithImpl<$Res, _$IdleBetweenRoundsImpl>
    implements _$$IdleBetweenRoundsImplCopyWith<$Res> {
  __$$IdleBetweenRoundsImplCopyWithImpl(_$IdleBetweenRoundsImpl _value,
      $Res Function(_$IdleBetweenRoundsImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedRounds = null,
    Object? playerOneChips = null,
    Object? playerTwoChips = null,
    Object? baseAnte = null,
    Object? rolledPotCarryover = null,
    Object? skillsRemainingPlayerOne = null,
    Object? skillsRemainingPlayerTwo = null,
  }) {
    return _then(_$IdleBetweenRoundsImpl(
      completedRounds: null == completedRounds
          ? _value.completedRounds
          : completedRounds // ignore: cast_nullable_to_non_nullable
              as int,
      playerOneChips: null == playerOneChips
          ? _value.playerOneChips
          : playerOneChips // ignore: cast_nullable_to_non_nullable
              as int,
      playerTwoChips: null == playerTwoChips
          ? _value.playerTwoChips
          : playerTwoChips // ignore: cast_nullable_to_non_nullable
              as int,
      baseAnte: null == baseAnte
          ? _value.baseAnte
          : baseAnte // ignore: cast_nullable_to_non_nullable
              as int,
      rolledPotCarryover: null == rolledPotCarryover
          ? _value.rolledPotCarryover
          : rolledPotCarryover // ignore: cast_nullable_to_non_nullable
              as int,
      skillsRemainingPlayerOne: null == skillsRemainingPlayerOne
          ? _value._skillsRemainingPlayerOne
          : skillsRemainingPlayerOne // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      skillsRemainingPlayerTwo: null == skillsRemainingPlayerTwo
          ? _value._skillsRemainingPlayerTwo
          : skillsRemainingPlayerTwo // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
    ));
  }
}

/// @nodoc

class _$IdleBetweenRoundsImpl implements _IdleBetweenRounds {
  const _$IdleBetweenRoundsImpl(
      {required this.completedRounds,
      required this.playerOneChips,
      required this.playerTwoChips,
      required this.baseAnte,
      required this.rolledPotCarryover,
      required final Set<BlindBluffSkill> skillsRemainingPlayerOne,
      required final Set<BlindBluffSkill> skillsRemainingPlayerTwo})
      : _skillsRemainingPlayerOne = skillsRemainingPlayerOne,
        _skillsRemainingPlayerTwo = skillsRemainingPlayerTwo;

  @override
  final int completedRounds;
  @override
  final int playerOneChips;
  @override
  final int playerTwoChips;
  @override
  final int baseAnte;
  @override
  final int rolledPotCarryover;
  final Set<BlindBluffSkill> _skillsRemainingPlayerOne;
  @override
  Set<BlindBluffSkill> get skillsRemainingPlayerOne {
    if (_skillsRemainingPlayerOne is EqualUnmodifiableSetView)
      return _skillsRemainingPlayerOne;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_skillsRemainingPlayerOne);
  }

  final Set<BlindBluffSkill> _skillsRemainingPlayerTwo;
  @override
  Set<BlindBluffSkill> get skillsRemainingPlayerTwo {
    if (_skillsRemainingPlayerTwo is EqualUnmodifiableSetView)
      return _skillsRemainingPlayerTwo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_skillsRemainingPlayerTwo);
  }

  @override
  String toString() {
    return 'BlindBluffSnapshot.idleBetweenRounds(completedRounds: $completedRounds, playerOneChips: $playerOneChips, playerTwoChips: $playerTwoChips, baseAnte: $baseAnte, rolledPotCarryover: $rolledPotCarryover, skillsRemainingPlayerOne: $skillsRemainingPlayerOne, skillsRemainingPlayerTwo: $skillsRemainingPlayerTwo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IdleBetweenRoundsImpl &&
            (identical(other.completedRounds, completedRounds) ||
                other.completedRounds == completedRounds) &&
            (identical(other.playerOneChips, playerOneChips) ||
                other.playerOneChips == playerOneChips) &&
            (identical(other.playerTwoChips, playerTwoChips) ||
                other.playerTwoChips == playerTwoChips) &&
            (identical(other.baseAnte, baseAnte) ||
                other.baseAnte == baseAnte) &&
            (identical(other.rolledPotCarryover, rolledPotCarryover) ||
                other.rolledPotCarryover == rolledPotCarryover) &&
            const DeepCollectionEquality().equals(
                other._skillsRemainingPlayerOne, _skillsRemainingPlayerOne) &&
            const DeepCollectionEquality().equals(
                other._skillsRemainingPlayerTwo, _skillsRemainingPlayerTwo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      completedRounds,
      playerOneChips,
      playerTwoChips,
      baseAnte,
      rolledPotCarryover,
      const DeepCollectionEquality().hash(_skillsRemainingPlayerOne),
      const DeepCollectionEquality().hash(_skillsRemainingPlayerTwo));

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IdleBetweenRoundsImplCopyWith<_$IdleBetweenRoundsImpl> get copyWith =>
      __$$IdleBetweenRoundsImplCopyWithImpl<_$IdleBetweenRoundsImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) {
    return idleBetweenRounds(
        completedRounds,
        playerOneChips,
        playerTwoChips,
        baseAnte,
        rolledPotCarryover,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) {
    return idleBetweenRounds?.call(
        completedRounds,
        playerOneChips,
        playerTwoChips,
        baseAnte,
        rolledPotCarryover,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) {
    if (idleBetweenRounds != null) {
      return idleBetweenRounds(
          completedRounds,
          playerOneChips,
          playerTwoChips,
          baseAnte,
          rolledPotCarryover,
          skillsRemainingPlayerOne,
          skillsRemainingPlayerTwo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) {
    return idleBetweenRounds(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) {
    return idleBetweenRounds?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) {
    if (idleBetweenRounds != null) {
      return idleBetweenRounds(this);
    }
    return orElse();
  }
}

abstract class _IdleBetweenRounds implements BlindBluffSnapshot {
  const factory _IdleBetweenRounds(
          {required final int completedRounds,
          required final int playerOneChips,
          required final int playerTwoChips,
          required final int baseAnte,
          required final int rolledPotCarryover,
          required final Set<BlindBluffSkill> skillsRemainingPlayerOne,
          required final Set<BlindBluffSkill> skillsRemainingPlayerTwo}) =
      _$IdleBetweenRoundsImpl;

  int get completedRounds;
  int get playerOneChips;
  int get playerTwoChips;
  int get baseAnte;
  int get rolledPotCarryover;
  Set<BlindBluffSkill> get skillsRemainingPlayerOne;
  Set<BlindBluffSkill> get skillsRemainingPlayerTwo;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IdleBetweenRoundsImplCopyWith<_$IdleBetweenRoundsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SkillPhaseImplCopyWith<$Res> {
  factory _$$SkillPhaseImplCopyWith(
          _$SkillPhaseImpl value, $Res Function(_$SkillPhaseImpl) then) =
      __$$SkillPhaseImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      int playerOneChips,
      int playerTwoChips,
      int baseAnteFrozenForRound,
      int potAfterAnte,
      BlindCard visibleOpponentCardToPlayerOne,
      BlindCard visibleOpponentCardToPlayerTwo,
      Set<BlindBluffSkill> skillsRemainingPlayerOne,
      Set<BlindBluffSkill> skillsRemainingPlayerTwo,
      bool playerOneLockedChoice,
      bool playerTwoLockedChoice,
      bool awaitingSkillRevealAck,
      BlindBluffSkill? declaredSkillPlayerOne,
      BlindBluffSkill? declaredSkillPlayerTwo});
}

/// @nodoc
class __$$SkillPhaseImplCopyWithImpl<$Res>
    extends _$BlindBluffSnapshotCopyWithImpl<$Res, _$SkillPhaseImpl>
    implements _$$SkillPhaseImplCopyWith<$Res> {
  __$$SkillPhaseImplCopyWithImpl(
      _$SkillPhaseImpl _value, $Res Function(_$SkillPhaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? playerOneChips = null,
    Object? playerTwoChips = null,
    Object? baseAnteFrozenForRound = null,
    Object? potAfterAnte = null,
    Object? visibleOpponentCardToPlayerOne = null,
    Object? visibleOpponentCardToPlayerTwo = null,
    Object? skillsRemainingPlayerOne = null,
    Object? skillsRemainingPlayerTwo = null,
    Object? playerOneLockedChoice = null,
    Object? playerTwoLockedChoice = null,
    Object? awaitingSkillRevealAck = null,
    Object? declaredSkillPlayerOne = freezed,
    Object? declaredSkillPlayerTwo = freezed,
  }) {
    return _then(_$SkillPhaseImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      playerOneChips: null == playerOneChips
          ? _value.playerOneChips
          : playerOneChips // ignore: cast_nullable_to_non_nullable
              as int,
      playerTwoChips: null == playerTwoChips
          ? _value.playerTwoChips
          : playerTwoChips // ignore: cast_nullable_to_non_nullable
              as int,
      baseAnteFrozenForRound: null == baseAnteFrozenForRound
          ? _value.baseAnteFrozenForRound
          : baseAnteFrozenForRound // ignore: cast_nullable_to_non_nullable
              as int,
      potAfterAnte: null == potAfterAnte
          ? _value.potAfterAnte
          : potAfterAnte // ignore: cast_nullable_to_non_nullable
              as int,
      visibleOpponentCardToPlayerOne: null == visibleOpponentCardToPlayerOne
          ? _value.visibleOpponentCardToPlayerOne
          : visibleOpponentCardToPlayerOne // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      visibleOpponentCardToPlayerTwo: null == visibleOpponentCardToPlayerTwo
          ? _value.visibleOpponentCardToPlayerTwo
          : visibleOpponentCardToPlayerTwo // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      skillsRemainingPlayerOne: null == skillsRemainingPlayerOne
          ? _value._skillsRemainingPlayerOne
          : skillsRemainingPlayerOne // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      skillsRemainingPlayerTwo: null == skillsRemainingPlayerTwo
          ? _value._skillsRemainingPlayerTwo
          : skillsRemainingPlayerTwo // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      playerOneLockedChoice: null == playerOneLockedChoice
          ? _value.playerOneLockedChoice
          : playerOneLockedChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      playerTwoLockedChoice: null == playerTwoLockedChoice
          ? _value.playerTwoLockedChoice
          : playerTwoLockedChoice // ignore: cast_nullable_to_non_nullable
              as bool,
      awaitingSkillRevealAck: null == awaitingSkillRevealAck
          ? _value.awaitingSkillRevealAck
          : awaitingSkillRevealAck // ignore: cast_nullable_to_non_nullable
              as bool,
      declaredSkillPlayerOne: freezed == declaredSkillPlayerOne
          ? _value.declaredSkillPlayerOne
          : declaredSkillPlayerOne // ignore: cast_nullable_to_non_nullable
              as BlindBluffSkill?,
      declaredSkillPlayerTwo: freezed == declaredSkillPlayerTwo
          ? _value.declaredSkillPlayerTwo
          : declaredSkillPlayerTwo // ignore: cast_nullable_to_non_nullable
              as BlindBluffSkill?,
    ));
  }
}

/// @nodoc

class _$SkillPhaseImpl implements _SkillPhase {
  const _$SkillPhaseImpl(
      {required this.roundNumber,
      required this.playerOneChips,
      required this.playerTwoChips,
      required this.baseAnteFrozenForRound,
      required this.potAfterAnte,
      required this.visibleOpponentCardToPlayerOne,
      required this.visibleOpponentCardToPlayerTwo,
      required final Set<BlindBluffSkill> skillsRemainingPlayerOne,
      required final Set<BlindBluffSkill> skillsRemainingPlayerTwo,
      required this.playerOneLockedChoice,
      required this.playerTwoLockedChoice,
      required this.awaitingSkillRevealAck,
      required this.declaredSkillPlayerOne,
      required this.declaredSkillPlayerTwo})
      : _skillsRemainingPlayerOne = skillsRemainingPlayerOne,
        _skillsRemainingPlayerTwo = skillsRemainingPlayerTwo;

  @override
  final int roundNumber;
  @override
  final int playerOneChips;
  @override
  final int playerTwoChips;
  @override
  final int baseAnteFrozenForRound;
  @override
  final int potAfterAnte;
  @override
  final BlindCard visibleOpponentCardToPlayerOne;
  @override
  final BlindCard visibleOpponentCardToPlayerTwo;
  final Set<BlindBluffSkill> _skillsRemainingPlayerOne;
  @override
  Set<BlindBluffSkill> get skillsRemainingPlayerOne {
    if (_skillsRemainingPlayerOne is EqualUnmodifiableSetView)
      return _skillsRemainingPlayerOne;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_skillsRemainingPlayerOne);
  }

  final Set<BlindBluffSkill> _skillsRemainingPlayerTwo;
  @override
  Set<BlindBluffSkill> get skillsRemainingPlayerTwo {
    if (_skillsRemainingPlayerTwo is EqualUnmodifiableSetView)
      return _skillsRemainingPlayerTwo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_skillsRemainingPlayerTwo);
  }

  @override
  final bool playerOneLockedChoice;
  @override
  final bool playerTwoLockedChoice;

  /// Both seats locked; UI should play a reveal animation then call
  /// [BlindBluffMatchEngine.acknowledgeSkillReveal].
  @override
  final bool awaitingSkillRevealAck;

  /// Only defined once both seats locked; `null` means skipped skills.
  @override
  final BlindBluffSkill? declaredSkillPlayerOne;
  @override
  final BlindBluffSkill? declaredSkillPlayerTwo;

  @override
  String toString() {
    return 'BlindBluffSnapshot.skillPhase(roundNumber: $roundNumber, playerOneChips: $playerOneChips, playerTwoChips: $playerTwoChips, baseAnteFrozenForRound: $baseAnteFrozenForRound, potAfterAnte: $potAfterAnte, visibleOpponentCardToPlayerOne: $visibleOpponentCardToPlayerOne, visibleOpponentCardToPlayerTwo: $visibleOpponentCardToPlayerTwo, skillsRemainingPlayerOne: $skillsRemainingPlayerOne, skillsRemainingPlayerTwo: $skillsRemainingPlayerTwo, playerOneLockedChoice: $playerOneLockedChoice, playerTwoLockedChoice: $playerTwoLockedChoice, awaitingSkillRevealAck: $awaitingSkillRevealAck, declaredSkillPlayerOne: $declaredSkillPlayerOne, declaredSkillPlayerTwo: $declaredSkillPlayerTwo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SkillPhaseImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.playerOneChips, playerOneChips) ||
                other.playerOneChips == playerOneChips) &&
            (identical(other.playerTwoChips, playerTwoChips) ||
                other.playerTwoChips == playerTwoChips) &&
            (identical(other.baseAnteFrozenForRound, baseAnteFrozenForRound) ||
                other.baseAnteFrozenForRound == baseAnteFrozenForRound) &&
            (identical(other.potAfterAnte, potAfterAnte) ||
                other.potAfterAnte == potAfterAnte) &&
            (identical(other.visibleOpponentCardToPlayerOne,
                    visibleOpponentCardToPlayerOne) ||
                other.visibleOpponentCardToPlayerOne ==
                    visibleOpponentCardToPlayerOne) &&
            (identical(other.visibleOpponentCardToPlayerTwo,
                    visibleOpponentCardToPlayerTwo) ||
                other.visibleOpponentCardToPlayerTwo ==
                    visibleOpponentCardToPlayerTwo) &&
            const DeepCollectionEquality().equals(
                other._skillsRemainingPlayerOne, _skillsRemainingPlayerOne) &&
            const DeepCollectionEquality().equals(
                other._skillsRemainingPlayerTwo, _skillsRemainingPlayerTwo) &&
            (identical(other.playerOneLockedChoice, playerOneLockedChoice) ||
                other.playerOneLockedChoice == playerOneLockedChoice) &&
            (identical(other.playerTwoLockedChoice, playerTwoLockedChoice) ||
                other.playerTwoLockedChoice == playerTwoLockedChoice) &&
            (identical(other.awaitingSkillRevealAck, awaitingSkillRevealAck) ||
                other.awaitingSkillRevealAck == awaitingSkillRevealAck) &&
            (identical(other.declaredSkillPlayerOne, declaredSkillPlayerOne) ||
                other.declaredSkillPlayerOne == declaredSkillPlayerOne) &&
            (identical(other.declaredSkillPlayerTwo, declaredSkillPlayerTwo) ||
                other.declaredSkillPlayerTwo == declaredSkillPlayerTwo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roundNumber,
      playerOneChips,
      playerTwoChips,
      baseAnteFrozenForRound,
      potAfterAnte,
      visibleOpponentCardToPlayerOne,
      visibleOpponentCardToPlayerTwo,
      const DeepCollectionEquality().hash(_skillsRemainingPlayerOne),
      const DeepCollectionEquality().hash(_skillsRemainingPlayerTwo),
      playerOneLockedChoice,
      playerTwoLockedChoice,
      awaitingSkillRevealAck,
      declaredSkillPlayerOne,
      declaredSkillPlayerTwo);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SkillPhaseImplCopyWith<_$SkillPhaseImpl> get copyWith =>
      __$$SkillPhaseImplCopyWithImpl<_$SkillPhaseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) {
    return skillPhase(
        roundNumber,
        playerOneChips,
        playerTwoChips,
        baseAnteFrozenForRound,
        potAfterAnte,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo,
        playerOneLockedChoice,
        playerTwoLockedChoice,
        awaitingSkillRevealAck,
        declaredSkillPlayerOne,
        declaredSkillPlayerTwo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) {
    return skillPhase?.call(
        roundNumber,
        playerOneChips,
        playerTwoChips,
        baseAnteFrozenForRound,
        potAfterAnte,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        skillsRemainingPlayerOne,
        skillsRemainingPlayerTwo,
        playerOneLockedChoice,
        playerTwoLockedChoice,
        awaitingSkillRevealAck,
        declaredSkillPlayerOne,
        declaredSkillPlayerTwo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) {
    if (skillPhase != null) {
      return skillPhase(
          roundNumber,
          playerOneChips,
          playerTwoChips,
          baseAnteFrozenForRound,
          potAfterAnte,
          visibleOpponentCardToPlayerOne,
          visibleOpponentCardToPlayerTwo,
          skillsRemainingPlayerOne,
          skillsRemainingPlayerTwo,
          playerOneLockedChoice,
          playerTwoLockedChoice,
          awaitingSkillRevealAck,
          declaredSkillPlayerOne,
          declaredSkillPlayerTwo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) {
    return skillPhase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) {
    return skillPhase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) {
    if (skillPhase != null) {
      return skillPhase(this);
    }
    return orElse();
  }
}

abstract class _SkillPhase implements BlindBluffSnapshot {
  const factory _SkillPhase(
          {required final int roundNumber,
          required final int playerOneChips,
          required final int playerTwoChips,
          required final int baseAnteFrozenForRound,
          required final int potAfterAnte,
          required final BlindCard visibleOpponentCardToPlayerOne,
          required final BlindCard visibleOpponentCardToPlayerTwo,
          required final Set<BlindBluffSkill> skillsRemainingPlayerOne,
          required final Set<BlindBluffSkill> skillsRemainingPlayerTwo,
          required final bool playerOneLockedChoice,
          required final bool playerTwoLockedChoice,
          required final bool awaitingSkillRevealAck,
          required final BlindBluffSkill? declaredSkillPlayerOne,
          required final BlindBluffSkill? declaredSkillPlayerTwo}) =
      _$SkillPhaseImpl;

  int get roundNumber;
  int get playerOneChips;
  int get playerTwoChips;
  int get baseAnteFrozenForRound;
  int get potAfterAnte;
  BlindCard get visibleOpponentCardToPlayerOne;
  BlindCard get visibleOpponentCardToPlayerTwo;
  Set<BlindBluffSkill> get skillsRemainingPlayerOne;
  Set<BlindBluffSkill> get skillsRemainingPlayerTwo;
  bool get playerOneLockedChoice;
  bool get playerTwoLockedChoice;

  /// Both seats locked; UI should play a reveal animation then call
  /// [BlindBluffMatchEngine.acknowledgeSkillReveal].
  bool get awaitingSkillRevealAck;

  /// Only defined once both seats locked; `null` means skipped skills.
  BlindBluffSkill? get declaredSkillPlayerOne;
  BlindBluffSkill? get declaredSkillPlayerTwo;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SkillPhaseImplCopyWith<_$SkillPhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BettingPhaseImplCopyWith<$Res> {
  factory _$$BettingPhaseImplCopyWith(
          _$BettingPhaseImpl value, $Res Function(_$BettingPhaseImpl) then) =
      __$$BettingPhaseImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      int playerOneChips,
      int playerTwoChips,
      int pot,
      int baseAnteFrozenForRound,
      BlindCard visibleOpponentCardToPlayerOne,
      BlindCard visibleOpponentCardToPlayerTwo,
      BlindBluffBettingPublicView betting});
}

/// @nodoc
class __$$BettingPhaseImplCopyWithImpl<$Res>
    extends _$BlindBluffSnapshotCopyWithImpl<$Res, _$BettingPhaseImpl>
    implements _$$BettingPhaseImplCopyWith<$Res> {
  __$$BettingPhaseImplCopyWithImpl(
      _$BettingPhaseImpl _value, $Res Function(_$BettingPhaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? playerOneChips = null,
    Object? playerTwoChips = null,
    Object? pot = null,
    Object? baseAnteFrozenForRound = null,
    Object? visibleOpponentCardToPlayerOne = null,
    Object? visibleOpponentCardToPlayerTwo = null,
    Object? betting = null,
  }) {
    return _then(_$BettingPhaseImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      playerOneChips: null == playerOneChips
          ? _value.playerOneChips
          : playerOneChips // ignore: cast_nullable_to_non_nullable
              as int,
      playerTwoChips: null == playerTwoChips
          ? _value.playerTwoChips
          : playerTwoChips // ignore: cast_nullable_to_non_nullable
              as int,
      pot: null == pot
          ? _value.pot
          : pot // ignore: cast_nullable_to_non_nullable
              as int,
      baseAnteFrozenForRound: null == baseAnteFrozenForRound
          ? _value.baseAnteFrozenForRound
          : baseAnteFrozenForRound // ignore: cast_nullable_to_non_nullable
              as int,
      visibleOpponentCardToPlayerOne: null == visibleOpponentCardToPlayerOne
          ? _value.visibleOpponentCardToPlayerOne
          : visibleOpponentCardToPlayerOne // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      visibleOpponentCardToPlayerTwo: null == visibleOpponentCardToPlayerTwo
          ? _value.visibleOpponentCardToPlayerTwo
          : visibleOpponentCardToPlayerTwo // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      betting: null == betting
          ? _value.betting
          : betting // ignore: cast_nullable_to_non_nullable
              as BlindBluffBettingPublicView,
    ));
  }
}

/// @nodoc

class _$BettingPhaseImpl implements _BettingPhase {
  const _$BettingPhaseImpl(
      {required this.roundNumber,
      required this.playerOneChips,
      required this.playerTwoChips,
      required this.pot,
      required this.baseAnteFrozenForRound,
      required this.visibleOpponentCardToPlayerOne,
      required this.visibleOpponentCardToPlayerTwo,
      required this.betting});

  @override
  final int roundNumber;
  @override
  final int playerOneChips;
  @override
  final int playerTwoChips;
  @override
  final int pot;
  @override
  final int baseAnteFrozenForRound;
  @override
  final BlindCard visibleOpponentCardToPlayerOne;
  @override
  final BlindCard visibleOpponentCardToPlayerTwo;
  @override
  final BlindBluffBettingPublicView betting;

  @override
  String toString() {
    return 'BlindBluffSnapshot.bettingPhase(roundNumber: $roundNumber, playerOneChips: $playerOneChips, playerTwoChips: $playerTwoChips, pot: $pot, baseAnteFrozenForRound: $baseAnteFrozenForRound, visibleOpponentCardToPlayerOne: $visibleOpponentCardToPlayerOne, visibleOpponentCardToPlayerTwo: $visibleOpponentCardToPlayerTwo, betting: $betting)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BettingPhaseImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.playerOneChips, playerOneChips) ||
                other.playerOneChips == playerOneChips) &&
            (identical(other.playerTwoChips, playerTwoChips) ||
                other.playerTwoChips == playerTwoChips) &&
            (identical(other.pot, pot) || other.pot == pot) &&
            (identical(other.baseAnteFrozenForRound, baseAnteFrozenForRound) ||
                other.baseAnteFrozenForRound == baseAnteFrozenForRound) &&
            (identical(other.visibleOpponentCardToPlayerOne,
                    visibleOpponentCardToPlayerOne) ||
                other.visibleOpponentCardToPlayerOne ==
                    visibleOpponentCardToPlayerOne) &&
            (identical(other.visibleOpponentCardToPlayerTwo,
                    visibleOpponentCardToPlayerTwo) ||
                other.visibleOpponentCardToPlayerTwo ==
                    visibleOpponentCardToPlayerTwo) &&
            (identical(other.betting, betting) || other.betting == betting));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roundNumber,
      playerOneChips,
      playerTwoChips,
      pot,
      baseAnteFrozenForRound,
      visibleOpponentCardToPlayerOne,
      visibleOpponentCardToPlayerTwo,
      betting);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BettingPhaseImplCopyWith<_$BettingPhaseImpl> get copyWith =>
      __$$BettingPhaseImplCopyWithImpl<_$BettingPhaseImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) {
    return bettingPhase(
        roundNumber,
        playerOneChips,
        playerTwoChips,
        pot,
        baseAnteFrozenForRound,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        betting);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) {
    return bettingPhase?.call(
        roundNumber,
        playerOneChips,
        playerTwoChips,
        pot,
        baseAnteFrozenForRound,
        visibleOpponentCardToPlayerOne,
        visibleOpponentCardToPlayerTwo,
        betting);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) {
    if (bettingPhase != null) {
      return bettingPhase(
          roundNumber,
          playerOneChips,
          playerTwoChips,
          pot,
          baseAnteFrozenForRound,
          visibleOpponentCardToPlayerOne,
          visibleOpponentCardToPlayerTwo,
          betting);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) {
    return bettingPhase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) {
    return bettingPhase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) {
    if (bettingPhase != null) {
      return bettingPhase(this);
    }
    return orElse();
  }
}

abstract class _BettingPhase implements BlindBluffSnapshot {
  const factory _BettingPhase(
      {required final int roundNumber,
      required final int playerOneChips,
      required final int playerTwoChips,
      required final int pot,
      required final int baseAnteFrozenForRound,
      required final BlindCard visibleOpponentCardToPlayerOne,
      required final BlindCard visibleOpponentCardToPlayerTwo,
      required final BlindBluffBettingPublicView betting}) = _$BettingPhaseImpl;

  int get roundNumber;
  int get playerOneChips;
  int get playerTwoChips;
  int get pot;
  int get baseAnteFrozenForRound;
  BlindCard get visibleOpponentCardToPlayerOne;
  BlindCard get visibleOpponentCardToPlayerTwo;
  BlindBluffBettingPublicView get betting;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BettingPhaseImplCopyWith<_$BettingPhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoundResolvingImplCopyWith<$Res> {
  factory _$$RoundResolvingImplCopyWith(_$RoundResolvingImpl value,
          $Res Function(_$RoundResolvingImpl) then) =
      __$$RoundResolvingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      BlindBluffRoundResolution resolution,
      int playerOneChipsAfterPot,
      int playerTwoChipsAfterPot});

  $BlindBluffRoundResolutionCopyWith<$Res> get resolution;
}

/// @nodoc
class __$$RoundResolvingImplCopyWithImpl<$Res>
    extends _$BlindBluffSnapshotCopyWithImpl<$Res, _$RoundResolvingImpl>
    implements _$$RoundResolvingImplCopyWith<$Res> {
  __$$RoundResolvingImplCopyWithImpl(
      _$RoundResolvingImpl _value, $Res Function(_$RoundResolvingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? resolution = null,
    Object? playerOneChipsAfterPot = null,
    Object? playerTwoChipsAfterPot = null,
  }) {
    return _then(_$RoundResolvingImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as BlindBluffRoundResolution,
      playerOneChipsAfterPot: null == playerOneChipsAfterPot
          ? _value.playerOneChipsAfterPot
          : playerOneChipsAfterPot // ignore: cast_nullable_to_non_nullable
              as int,
      playerTwoChipsAfterPot: null == playerTwoChipsAfterPot
          ? _value.playerTwoChipsAfterPot
          : playerTwoChipsAfterPot // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlindBluffRoundResolutionCopyWith<$Res> get resolution {
    return $BlindBluffRoundResolutionCopyWith<$Res>(_value.resolution, (value) {
      return _then(_value.copyWith(resolution: value));
    });
  }
}

/// @nodoc

class _$RoundResolvingImpl implements _RoundResolving {
  const _$RoundResolvingImpl(
      {required this.roundNumber,
      required this.resolution,
      required this.playerOneChipsAfterPot,
      required this.playerTwoChipsAfterPot});

  @override
  final int roundNumber;
  @override
  final BlindBluffRoundResolution resolution;
  @override
  final int playerOneChipsAfterPot;
  @override
  final int playerTwoChipsAfterPot;

  @override
  String toString() {
    return 'BlindBluffSnapshot.roundResolving(roundNumber: $roundNumber, resolution: $resolution, playerOneChipsAfterPot: $playerOneChipsAfterPot, playerTwoChipsAfterPot: $playerTwoChipsAfterPot)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundResolvingImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.playerOneChipsAfterPot, playerOneChipsAfterPot) ||
                other.playerOneChipsAfterPot == playerOneChipsAfterPot) &&
            (identical(other.playerTwoChipsAfterPot, playerTwoChipsAfterPot) ||
                other.playerTwoChipsAfterPot == playerTwoChipsAfterPot));
  }

  @override
  int get hashCode => Object.hash(runtimeType, roundNumber, resolution,
      playerOneChipsAfterPot, playerTwoChipsAfterPot);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundResolvingImplCopyWith<_$RoundResolvingImpl> get copyWith =>
      __$$RoundResolvingImplCopyWithImpl<_$RoundResolvingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) {
    return roundResolving(roundNumber, resolution, playerOneChipsAfterPot,
        playerTwoChipsAfterPot);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) {
    return roundResolving?.call(roundNumber, resolution, playerOneChipsAfterPot,
        playerTwoChipsAfterPot);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) {
    if (roundResolving != null) {
      return roundResolving(roundNumber, resolution, playerOneChipsAfterPot,
          playerTwoChipsAfterPot);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) {
    return roundResolving(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) {
    return roundResolving?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) {
    if (roundResolving != null) {
      return roundResolving(this);
    }
    return orElse();
  }
}

abstract class _RoundResolving implements BlindBluffSnapshot {
  const factory _RoundResolving(
      {required final int roundNumber,
      required final BlindBluffRoundResolution resolution,
      required final int playerOneChipsAfterPot,
      required final int playerTwoChipsAfterPot}) = _$RoundResolvingImpl;

  int get roundNumber;
  BlindBluffRoundResolution get resolution;
  int get playerOneChipsAfterPot;
  int get playerTwoChipsAfterPot;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundResolvingImplCopyWith<_$RoundResolvingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MatchCompleteImplCopyWith<$Res> {
  factory _$$MatchCompleteImplCopyWith(
          _$MatchCompleteImpl value, $Res Function(_$MatchCompleteImpl) then) =
      __$$MatchCompleteImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BlindBluffPlayerId winner,
      String reason,
      int playerOneChips,
      int playerTwoChips,
      BlindBluffRoundResolution? terminalRoundResolution,
      int? terminalRoundNumber});

  $BlindBluffRoundResolutionCopyWith<$Res>? get terminalRoundResolution;
}

/// @nodoc
class __$$MatchCompleteImplCopyWithImpl<$Res>
    extends _$BlindBluffSnapshotCopyWithImpl<$Res, _$MatchCompleteImpl>
    implements _$$MatchCompleteImplCopyWith<$Res> {
  __$$MatchCompleteImplCopyWithImpl(
      _$MatchCompleteImpl _value, $Res Function(_$MatchCompleteImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = null,
    Object? reason = null,
    Object? playerOneChips = null,
    Object? playerTwoChips = null,
    Object? terminalRoundResolution = freezed,
    Object? terminalRoundNumber = freezed,
  }) {
    return _then(_$MatchCompleteImpl(
      winner: null == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as BlindBluffPlayerId,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      playerOneChips: null == playerOneChips
          ? _value.playerOneChips
          : playerOneChips // ignore: cast_nullable_to_non_nullable
              as int,
      playerTwoChips: null == playerTwoChips
          ? _value.playerTwoChips
          : playerTwoChips // ignore: cast_nullable_to_non_nullable
              as int,
      terminalRoundResolution: freezed == terminalRoundResolution
          ? _value.terminalRoundResolution
          : terminalRoundResolution // ignore: cast_nullable_to_non_nullable
              as BlindBluffRoundResolution?,
      terminalRoundNumber: freezed == terminalRoundNumber
          ? _value.terminalRoundNumber
          : terminalRoundNumber // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BlindBluffRoundResolutionCopyWith<$Res>? get terminalRoundResolution {
    if (_value.terminalRoundResolution == null) {
      return null;
    }

    return $BlindBluffRoundResolutionCopyWith<$Res>(
        _value.terminalRoundResolution!, (value) {
      return _then(_value.copyWith(terminalRoundResolution: value));
    });
  }
}

/// @nodoc

class _$MatchCompleteImpl implements _MatchComplete {
  const _$MatchCompleteImpl(
      {required this.winner,
      required this.reason,
      required this.playerOneChips,
      required this.playerTwoChips,
      this.terminalRoundResolution,
      this.terminalRoundNumber});

  @override
  final BlindBluffPlayerId winner;
  @override
  final String reason;
  @override
  final int playerOneChips;
  @override
  final int playerTwoChips;

  /// Set when [BlindBluffMatchEngine.finishRound] closed out the decisive hand.
  @override
  final BlindBluffRoundResolution? terminalRoundResolution;
  @override
  final int? terminalRoundNumber;

  @override
  String toString() {
    return 'BlindBluffSnapshot.matchComplete(winner: $winner, reason: $reason, playerOneChips: $playerOneChips, playerTwoChips: $playerTwoChips, terminalRoundResolution: $terminalRoundResolution, terminalRoundNumber: $terminalRoundNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchCompleteImpl &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.playerOneChips, playerOneChips) ||
                other.playerOneChips == playerOneChips) &&
            (identical(other.playerTwoChips, playerTwoChips) ||
                other.playerTwoChips == playerTwoChips) &&
            (identical(
                    other.terminalRoundResolution, terminalRoundResolution) ||
                other.terminalRoundResolution == terminalRoundResolution) &&
            (identical(other.terminalRoundNumber, terminalRoundNumber) ||
                other.terminalRoundNumber == terminalRoundNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, winner, reason, playerOneChips,
      playerTwoChips, terminalRoundResolution, terminalRoundNumber);

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchCompleteImplCopyWith<_$MatchCompleteImpl> get copyWith =>
      __$$MatchCompleteImplCopyWithImpl<_$MatchCompleteImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)
        idleBetweenRounds,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)
        skillPhase,
    required TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot,
            int playerTwoChipsAfterPot)
        roundResolving,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        matchComplete,
  }) {
    return matchComplete(winner, reason, playerOneChips, playerTwoChips,
        terminalRoundResolution, terminalRoundNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult? Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult? Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
  }) {
    return matchComplete?.call(winner, reason, playerOneChips, playerTwoChips,
        terminalRoundResolution, terminalRoundNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int completedRounds,
            int playerOneChips,
            int playerTwoChips,
            int baseAnte,
            int rolledPotCarryover,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo)?
        idleBetweenRounds,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int baseAnteFrozenForRound,
            int potAfterAnte,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            Set<BlindBluffSkill> skillsRemainingPlayerOne,
            Set<BlindBluffSkill> skillsRemainingPlayerTwo,
            bool playerOneLockedChoice,
            bool playerTwoLockedChoice,
            bool awaitingSkillRevealAck,
            BlindBluffSkill? declaredSkillPlayerOne,
            BlindBluffSkill? declaredSkillPlayerTwo)?
        skillPhase,
    TResult Function(
            int roundNumber,
            int playerOneChips,
            int playerTwoChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard visibleOpponentCardToPlayerOne,
            BlindCard visibleOpponentCardToPlayerTwo,
            BlindBluffBettingPublicView betting)?
        bettingPhase,
    TResult Function(int roundNumber, BlindBluffRoundResolution resolution,
            int playerOneChipsAfterPot, int playerTwoChipsAfterPot)?
        roundResolving,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerOneChips,
            int playerTwoChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        matchComplete,
    required TResult orElse(),
  }) {
    if (matchComplete != null) {
      return matchComplete(winner, reason, playerOneChips, playerTwoChips,
          terminalRoundResolution, terminalRoundNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_IdleBetweenRounds value) idleBetweenRounds,
    required TResult Function(_SkillPhase value) skillPhase,
    required TResult Function(_BettingPhase value) bettingPhase,
    required TResult Function(_RoundResolving value) roundResolving,
    required TResult Function(_MatchComplete value) matchComplete,
  }) {
    return matchComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult? Function(_SkillPhase value)? skillPhase,
    TResult? Function(_BettingPhase value)? bettingPhase,
    TResult? Function(_RoundResolving value)? roundResolving,
    TResult? Function(_MatchComplete value)? matchComplete,
  }) {
    return matchComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_IdleBetweenRounds value)? idleBetweenRounds,
    TResult Function(_SkillPhase value)? skillPhase,
    TResult Function(_BettingPhase value)? bettingPhase,
    TResult Function(_RoundResolving value)? roundResolving,
    TResult Function(_MatchComplete value)? matchComplete,
    required TResult orElse(),
  }) {
    if (matchComplete != null) {
      return matchComplete(this);
    }
    return orElse();
  }
}

abstract class _MatchComplete implements BlindBluffSnapshot {
  const factory _MatchComplete(
      {required final BlindBluffPlayerId winner,
      required final String reason,
      required final int playerOneChips,
      required final int playerTwoChips,
      final BlindBluffRoundResolution? terminalRoundResolution,
      final int? terminalRoundNumber}) = _$MatchCompleteImpl;

  BlindBluffPlayerId get winner;
  String get reason;
  int get playerOneChips;
  int get playerTwoChips;

  /// Set when [BlindBluffMatchEngine.finishRound] closed out the decisive hand.
  BlindBluffRoundResolution? get terminalRoundResolution;
  int? get terminalRoundNumber;

  /// Create a copy of BlindBluffSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchCompleteImplCopyWith<_$MatchCompleteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
