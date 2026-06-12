// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_bluff_match_ui_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlindBluffMatchState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlindBluffMatchStateCopyWith<$Res> {
  factory $BlindBluffMatchStateCopyWith(BlindBluffMatchState value,
          $Res Function(BlindBluffMatchState) then) =
      _$BlindBluffMatchStateCopyWithImpl<$Res, BlindBluffMatchState>;
}

/// @nodoc
class _$BlindBluffMatchStateCopyWithImpl<$Res,
        $Val extends BlindBluffMatchState>
    implements $BlindBluffMatchStateCopyWith<$Res> {
  _$BlindBluffMatchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$BbLoadingImplCopyWith<$Res> {
  factory _$$BbLoadingImplCopyWith(
          _$BbLoadingImpl value, $Res Function(_$BbLoadingImpl) then) =
      __$$BbLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$BbLoadingImplCopyWithImpl<$Res>
    extends _$BlindBluffMatchStateCopyWithImpl<$Res, _$BbLoadingImpl>
    implements _$$BbLoadingImplCopyWith<$Res> {
  __$$BbLoadingImplCopyWithImpl(
      _$BbLoadingImpl _value, $Res Function(_$BbLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$BbLoadingImpl implements _BbLoading {
  const _$BbLoadingImpl();

  @override
  String toString() {
    return 'BlindBluffMatchState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$BbLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _BbLoading implements BlindBluffMatchState {
  const factory _BbLoading() = _$BbLoadingImpl;
}

/// @nodoc
abstract class _$$BbStaredownPhaseImplCopyWith<$Res> {
  factory _$$BbStaredownPhaseImplCopyWith(_$BbStaredownPhaseImpl value,
          $Res Function(_$BbStaredownPhaseImpl) then) =
      __$$BbStaredownPhaseImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      int playerChips,
      int opponentChips,
      int pot,
      int baseAnteFrozenForRound,
      BlindCard opponentCard,
      BlindCard playerCard,
      Set<BlindBluffSkill> playerSkillsRemaining,
      Set<BlindBluffSkill> opponentSkillsRemaining,
      bool playerLockedSkill,
      bool opponentLockedSkill,
      bool awaitingIntroSequence,
      int skillReflectionSecondsRemaining,
      bool awaitingSkillRevealAnimation,
      BlindBluffSkill? revealedPlayerSkill,
      BlindBluffSkill? revealedOpponentSkill,
      int secondsRemaining,
      List<String> actionLog,
      int? anteDoubledFrom,
      int? anteDoubledTo});
}

/// @nodoc
class __$$BbStaredownPhaseImplCopyWithImpl<$Res>
    extends _$BlindBluffMatchStateCopyWithImpl<$Res, _$BbStaredownPhaseImpl>
    implements _$$BbStaredownPhaseImplCopyWith<$Res> {
  __$$BbStaredownPhaseImplCopyWithImpl(_$BbStaredownPhaseImpl _value,
      $Res Function(_$BbStaredownPhaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? playerChips = null,
    Object? opponentChips = null,
    Object? pot = null,
    Object? baseAnteFrozenForRound = null,
    Object? opponentCard = null,
    Object? playerCard = null,
    Object? playerSkillsRemaining = null,
    Object? opponentSkillsRemaining = null,
    Object? playerLockedSkill = null,
    Object? opponentLockedSkill = null,
    Object? awaitingIntroSequence = null,
    Object? skillReflectionSecondsRemaining = null,
    Object? awaitingSkillRevealAnimation = null,
    Object? revealedPlayerSkill = freezed,
    Object? revealedOpponentSkill = freezed,
    Object? secondsRemaining = null,
    Object? actionLog = null,
    Object? anteDoubledFrom = freezed,
    Object? anteDoubledTo = freezed,
  }) {
    return _then(_$BbStaredownPhaseImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      playerChips: null == playerChips
          ? _value.playerChips
          : playerChips // ignore: cast_nullable_to_non_nullable
              as int,
      opponentChips: null == opponentChips
          ? _value.opponentChips
          : opponentChips // ignore: cast_nullable_to_non_nullable
              as int,
      pot: null == pot
          ? _value.pot
          : pot // ignore: cast_nullable_to_non_nullable
              as int,
      baseAnteFrozenForRound: null == baseAnteFrozenForRound
          ? _value.baseAnteFrozenForRound
          : baseAnteFrozenForRound // ignore: cast_nullable_to_non_nullable
              as int,
      opponentCard: null == opponentCard
          ? _value.opponentCard
          : opponentCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      playerCard: null == playerCard
          ? _value.playerCard
          : playerCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      playerSkillsRemaining: null == playerSkillsRemaining
          ? _value._playerSkillsRemaining
          : playerSkillsRemaining // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      opponentSkillsRemaining: null == opponentSkillsRemaining
          ? _value._opponentSkillsRemaining
          : opponentSkillsRemaining // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      playerLockedSkill: null == playerLockedSkill
          ? _value.playerLockedSkill
          : playerLockedSkill // ignore: cast_nullable_to_non_nullable
              as bool,
      opponentLockedSkill: null == opponentLockedSkill
          ? _value.opponentLockedSkill
          : opponentLockedSkill // ignore: cast_nullable_to_non_nullable
              as bool,
      awaitingIntroSequence: null == awaitingIntroSequence
          ? _value.awaitingIntroSequence
          : awaitingIntroSequence // ignore: cast_nullable_to_non_nullable
              as bool,
      skillReflectionSecondsRemaining: null == skillReflectionSecondsRemaining
          ? _value.skillReflectionSecondsRemaining
          : skillReflectionSecondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      awaitingSkillRevealAnimation: null == awaitingSkillRevealAnimation
          ? _value.awaitingSkillRevealAnimation
          : awaitingSkillRevealAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      revealedPlayerSkill: freezed == revealedPlayerSkill
          ? _value.revealedPlayerSkill
          : revealedPlayerSkill // ignore: cast_nullable_to_non_nullable
              as BlindBluffSkill?,
      revealedOpponentSkill: freezed == revealedOpponentSkill
          ? _value.revealedOpponentSkill
          : revealedOpponentSkill // ignore: cast_nullable_to_non_nullable
              as BlindBluffSkill?,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      actionLog: null == actionLog
          ? _value._actionLog
          : actionLog // ignore: cast_nullable_to_non_nullable
              as List<String>,
      anteDoubledFrom: freezed == anteDoubledFrom
          ? _value.anteDoubledFrom
          : anteDoubledFrom // ignore: cast_nullable_to_non_nullable
              as int?,
      anteDoubledTo: freezed == anteDoubledTo
          ? _value.anteDoubledTo
          : anteDoubledTo // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$BbStaredownPhaseImpl implements _BbStaredownPhase {
  const _$BbStaredownPhaseImpl(
      {required this.roundNumber,
      required this.playerChips,
      required this.opponentChips,
      required this.pot,
      required this.baseAnteFrozenForRound,
      required this.opponentCard,
      required this.playerCard,
      required final Set<BlindBluffSkill> playerSkillsRemaining,
      required final Set<BlindBluffSkill> opponentSkillsRemaining,
      required this.playerLockedSkill,
      required this.opponentLockedSkill,
      required this.awaitingIntroSequence,
      required this.skillReflectionSecondsRemaining,
      required this.awaitingSkillRevealAnimation,
      required this.revealedPlayerSkill,
      required this.revealedOpponentSkill,
      required this.secondsRemaining,
      required final List<String> actionLog,
      this.anteDoubledFrom,
      this.anteDoubledTo})
      : _playerSkillsRemaining = playerSkillsRemaining,
        _opponentSkillsRemaining = opponentSkillsRemaining,
        _actionLog = actionLog;

  @override
  final int roundNumber;
  @override
  final int playerChips;
  @override
  final int opponentChips;
  @override
  final int pot;
  @override
  final int baseAnteFrozenForRound;
  @override
  final BlindCard opponentCard;

  /// Human hole card (what you hold; also what seat two “sees”).
  @override
  final BlindCard playerCard;
  final Set<BlindBluffSkill> _playerSkillsRemaining;
  @override
  Set<BlindBluffSkill> get playerSkillsRemaining {
    if (_playerSkillsRemaining is EqualUnmodifiableSetView)
      return _playerSkillsRemaining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_playerSkillsRemaining);
  }

  final Set<BlindBluffSkill> _opponentSkillsRemaining;
  @override
  Set<BlindBluffSkill> get opponentSkillsRemaining {
    if (_opponentSkillsRemaining is EqualUnmodifiableSetView)
      return _opponentSkillsRemaining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_opponentSkillsRemaining);
  }

  @override
  final bool playerLockedSkill;
  @override
  final bool opponentLockedSkill;
  @override
  final bool awaitingIntroSequence;

  /// Countdown for the first skill-phase segment (reflection); skills may be
  /// chosen during this window as well as the follow-up timer.
  @override
  final int skillReflectionSecondsRemaining;

  /// Engine is waiting on [BlindBluffCubit.notifySkillRevealAnimationComplete].
  @override
  final bool awaitingSkillRevealAnimation;
  @override
  final BlindBluffSkill? revealedPlayerSkill;
  @override
  final BlindBluffSkill? revealedOpponentSkill;
  @override
  final int secondsRemaining;
  final List<String> _actionLog;
  @override
  List<String> get actionLog {
    if (_actionLog is EqualUnmodifiableListView) return _actionLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionLog);
  }

  /// Set once when the shoe recycled and ante doubled before this round.
  @override
  final int? anteDoubledFrom;
  @override
  final int? anteDoubledTo;

  @override
  String toString() {
    return 'BlindBluffMatchState.staredownPhase(roundNumber: $roundNumber, playerChips: $playerChips, opponentChips: $opponentChips, pot: $pot, baseAnteFrozenForRound: $baseAnteFrozenForRound, opponentCard: $opponentCard, playerCard: $playerCard, playerSkillsRemaining: $playerSkillsRemaining, opponentSkillsRemaining: $opponentSkillsRemaining, playerLockedSkill: $playerLockedSkill, opponentLockedSkill: $opponentLockedSkill, awaitingIntroSequence: $awaitingIntroSequence, skillReflectionSecondsRemaining: $skillReflectionSecondsRemaining, awaitingSkillRevealAnimation: $awaitingSkillRevealAnimation, revealedPlayerSkill: $revealedPlayerSkill, revealedOpponentSkill: $revealedOpponentSkill, secondsRemaining: $secondsRemaining, actionLog: $actionLog, anteDoubledFrom: $anteDoubledFrom, anteDoubledTo: $anteDoubledTo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BbStaredownPhaseImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.playerChips, playerChips) ||
                other.playerChips == playerChips) &&
            (identical(other.opponentChips, opponentChips) ||
                other.opponentChips == opponentChips) &&
            (identical(other.pot, pot) || other.pot == pot) &&
            (identical(other.baseAnteFrozenForRound, baseAnteFrozenForRound) ||
                other.baseAnteFrozenForRound == baseAnteFrozenForRound) &&
            (identical(other.opponentCard, opponentCard) ||
                other.opponentCard == opponentCard) &&
            (identical(other.playerCard, playerCard) ||
                other.playerCard == playerCard) &&
            const DeepCollectionEquality()
                .equals(other._playerSkillsRemaining, _playerSkillsRemaining) &&
            const DeepCollectionEquality().equals(
                other._opponentSkillsRemaining, _opponentSkillsRemaining) &&
            (identical(other.playerLockedSkill, playerLockedSkill) ||
                other.playerLockedSkill == playerLockedSkill) &&
            (identical(other.opponentLockedSkill, opponentLockedSkill) ||
                other.opponentLockedSkill == opponentLockedSkill) &&
            (identical(other.awaitingIntroSequence, awaitingIntroSequence) ||
                other.awaitingIntroSequence == awaitingIntroSequence) &&
            (identical(other.skillReflectionSecondsRemaining,
                    skillReflectionSecondsRemaining) ||
                other.skillReflectionSecondsRemaining ==
                    skillReflectionSecondsRemaining) &&
            (identical(other.awaitingSkillRevealAnimation,
                    awaitingSkillRevealAnimation) ||
                other.awaitingSkillRevealAnimation ==
                    awaitingSkillRevealAnimation) &&
            (identical(other.revealedPlayerSkill, revealedPlayerSkill) ||
                other.revealedPlayerSkill == revealedPlayerSkill) &&
            (identical(other.revealedOpponentSkill, revealedOpponentSkill) ||
                other.revealedOpponentSkill == revealedOpponentSkill) &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining) &&
            const DeepCollectionEquality()
                .equals(other._actionLog, _actionLog) &&
            (identical(other.anteDoubledFrom, anteDoubledFrom) ||
                other.anteDoubledFrom == anteDoubledFrom) &&
            (identical(other.anteDoubledTo, anteDoubledTo) ||
                other.anteDoubledTo == anteDoubledTo));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        roundNumber,
        playerChips,
        opponentChips,
        pot,
        baseAnteFrozenForRound,
        opponentCard,
        playerCard,
        const DeepCollectionEquality().hash(_playerSkillsRemaining),
        const DeepCollectionEquality().hash(_opponentSkillsRemaining),
        playerLockedSkill,
        opponentLockedSkill,
        awaitingIntroSequence,
        skillReflectionSecondsRemaining,
        awaitingSkillRevealAnimation,
        revealedPlayerSkill,
        revealedOpponentSkill,
        secondsRemaining,
        const DeepCollectionEquality().hash(_actionLog),
        anteDoubledFrom,
        anteDoubledTo
      ]);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BbStaredownPhaseImplCopyWith<_$BbStaredownPhaseImpl> get copyWith =>
      __$$BbStaredownPhaseImplCopyWithImpl<_$BbStaredownPhaseImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) {
    return staredownPhase(
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
        actionLog,
        anteDoubledFrom,
        anteDoubledTo);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) {
    return staredownPhase?.call(
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
        actionLog,
        anteDoubledFrom,
        anteDoubledTo);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) {
    if (staredownPhase != null) {
      return staredownPhase(
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
          actionLog,
          anteDoubledFrom,
          anteDoubledTo);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) {
    return staredownPhase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) {
    return staredownPhase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (staredownPhase != null) {
      return staredownPhase(this);
    }
    return orElse();
  }
}

abstract class _BbStaredownPhase implements BlindBluffMatchState {
  const factory _BbStaredownPhase(
      {required final int roundNumber,
      required final int playerChips,
      required final int opponentChips,
      required final int pot,
      required final int baseAnteFrozenForRound,
      required final BlindCard opponentCard,
      required final BlindCard playerCard,
      required final Set<BlindBluffSkill> playerSkillsRemaining,
      required final Set<BlindBluffSkill> opponentSkillsRemaining,
      required final bool playerLockedSkill,
      required final bool opponentLockedSkill,
      required final bool awaitingIntroSequence,
      required final int skillReflectionSecondsRemaining,
      required final bool awaitingSkillRevealAnimation,
      required final BlindBluffSkill? revealedPlayerSkill,
      required final BlindBluffSkill? revealedOpponentSkill,
      required final int secondsRemaining,
      required final List<String> actionLog,
      final int? anteDoubledFrom,
      final int? anteDoubledTo}) = _$BbStaredownPhaseImpl;

  int get roundNumber;
  int get playerChips;
  int get opponentChips;
  int get pot;
  int get baseAnteFrozenForRound;
  BlindCard get opponentCard;

  /// Human hole card (what you hold; also what seat two “sees”).
  BlindCard get playerCard;
  Set<BlindBluffSkill> get playerSkillsRemaining;
  Set<BlindBluffSkill> get opponentSkillsRemaining;
  bool get playerLockedSkill;
  bool get opponentLockedSkill;
  bool get awaitingIntroSequence;

  /// Countdown for the first skill-phase segment (reflection); skills may be
  /// chosen during this window as well as the follow-up timer.
  int get skillReflectionSecondsRemaining;

  /// Engine is waiting on [BlindBluffCubit.notifySkillRevealAnimationComplete].
  bool get awaitingSkillRevealAnimation;
  BlindBluffSkill? get revealedPlayerSkill;
  BlindBluffSkill? get revealedOpponentSkill;
  int get secondsRemaining;
  List<String> get actionLog;

  /// Set once when the shoe recycled and ante doubled before this round.
  int? get anteDoubledFrom;
  int? get anteDoubledTo;

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BbStaredownPhaseImplCopyWith<_$BbStaredownPhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BbBettingPhaseImplCopyWith<$Res> {
  factory _$$BbBettingPhaseImplCopyWith(_$BbBettingPhaseImpl value,
          $Res Function(_$BbBettingPhaseImpl) then) =
      __$$BbBettingPhaseImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      int playerChips,
      int opponentChips,
      int pot,
      int baseAnteFrozenForRound,
      BlindCard opponentCard,
      BlindCard playerCard,
      BlindBluffBettingPublicView betting,
      int chipsToCallPlayer,
      bool playerHasPenaltyInsurance,
      bool opponentHasPenaltyInsurance,
      int secondsRemaining,
      List<String> actionLog,
      Set<BlindBluffSkill> playerSkillsRemaining,
      Set<BlindBluffSkill> opponentSkillsRemaining,
      int? opponentRaiseNoticeChips,
      bool opponentCheckNotice});
}

/// @nodoc
class __$$BbBettingPhaseImplCopyWithImpl<$Res>
    extends _$BlindBluffMatchStateCopyWithImpl<$Res, _$BbBettingPhaseImpl>
    implements _$$BbBettingPhaseImplCopyWith<$Res> {
  __$$BbBettingPhaseImplCopyWithImpl(
      _$BbBettingPhaseImpl _value, $Res Function(_$BbBettingPhaseImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? playerChips = null,
    Object? opponentChips = null,
    Object? pot = null,
    Object? baseAnteFrozenForRound = null,
    Object? opponentCard = null,
    Object? playerCard = null,
    Object? betting = null,
    Object? chipsToCallPlayer = null,
    Object? playerHasPenaltyInsurance = null,
    Object? opponentHasPenaltyInsurance = null,
    Object? secondsRemaining = null,
    Object? actionLog = null,
    Object? playerSkillsRemaining = null,
    Object? opponentSkillsRemaining = null,
    Object? opponentRaiseNoticeChips = freezed,
    Object? opponentCheckNotice = null,
  }) {
    return _then(_$BbBettingPhaseImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      playerChips: null == playerChips
          ? _value.playerChips
          : playerChips // ignore: cast_nullable_to_non_nullable
              as int,
      opponentChips: null == opponentChips
          ? _value.opponentChips
          : opponentChips // ignore: cast_nullable_to_non_nullable
              as int,
      pot: null == pot
          ? _value.pot
          : pot // ignore: cast_nullable_to_non_nullable
              as int,
      baseAnteFrozenForRound: null == baseAnteFrozenForRound
          ? _value.baseAnteFrozenForRound
          : baseAnteFrozenForRound // ignore: cast_nullable_to_non_nullable
              as int,
      opponentCard: null == opponentCard
          ? _value.opponentCard
          : opponentCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      playerCard: null == playerCard
          ? _value.playerCard
          : playerCard // ignore: cast_nullable_to_non_nullable
              as BlindCard,
      betting: null == betting
          ? _value.betting
          : betting // ignore: cast_nullable_to_non_nullable
              as BlindBluffBettingPublicView,
      chipsToCallPlayer: null == chipsToCallPlayer
          ? _value.chipsToCallPlayer
          : chipsToCallPlayer // ignore: cast_nullable_to_non_nullable
              as int,
      playerHasPenaltyInsurance: null == playerHasPenaltyInsurance
          ? _value.playerHasPenaltyInsurance
          : playerHasPenaltyInsurance // ignore: cast_nullable_to_non_nullable
              as bool,
      opponentHasPenaltyInsurance: null == opponentHasPenaltyInsurance
          ? _value.opponentHasPenaltyInsurance
          : opponentHasPenaltyInsurance // ignore: cast_nullable_to_non_nullable
              as bool,
      secondsRemaining: null == secondsRemaining
          ? _value.secondsRemaining
          : secondsRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      actionLog: null == actionLog
          ? _value._actionLog
          : actionLog // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playerSkillsRemaining: null == playerSkillsRemaining
          ? _value._playerSkillsRemaining
          : playerSkillsRemaining // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      opponentSkillsRemaining: null == opponentSkillsRemaining
          ? _value._opponentSkillsRemaining
          : opponentSkillsRemaining // ignore: cast_nullable_to_non_nullable
              as Set<BlindBluffSkill>,
      opponentRaiseNoticeChips: freezed == opponentRaiseNoticeChips
          ? _value.opponentRaiseNoticeChips
          : opponentRaiseNoticeChips // ignore: cast_nullable_to_non_nullable
              as int?,
      opponentCheckNotice: null == opponentCheckNotice
          ? _value.opponentCheckNotice
          : opponentCheckNotice // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BbBettingPhaseImpl implements _BbBettingPhase {
  const _$BbBettingPhaseImpl(
      {required this.roundNumber,
      required this.playerChips,
      required this.opponentChips,
      required this.pot,
      required this.baseAnteFrozenForRound,
      required this.opponentCard,
      required this.playerCard,
      required this.betting,
      required this.chipsToCallPlayer,
      required this.playerHasPenaltyInsurance,
      required this.opponentHasPenaltyInsurance,
      required this.secondsRemaining,
      required final List<String> actionLog,
      required final Set<BlindBluffSkill> playerSkillsRemaining,
      required final Set<BlindBluffSkill> opponentSkillsRemaining,
      this.opponentRaiseNoticeChips,
      required this.opponentCheckNotice})
      : _actionLog = actionLog,
        _playerSkillsRemaining = playerSkillsRemaining,
        _opponentSkillsRemaining = opponentSkillsRemaining;

  @override
  final int roundNumber;
  @override
  final int playerChips;
  @override
  final int opponentChips;
  @override
  final int pot;
  @override
  final int baseAnteFrozenForRound;
  @override
  final BlindCard opponentCard;
  @override
  final BlindCard playerCard;
  @override
  final BlindBluffBettingPublicView betting;
  @override
  final int chipsToCallPlayer;
  @override
  final bool playerHasPenaltyInsurance;
  @override
  final bool opponentHasPenaltyInsurance;
  @override
  final int secondsRemaining;
  final List<String> _actionLog;
  @override
  List<String> get actionLog {
    if (_actionLog is EqualUnmodifiableListView) return _actionLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionLog);
  }

  final Set<BlindBluffSkill> _playerSkillsRemaining;
  @override
  Set<BlindBluffSkill> get playerSkillsRemaining {
    if (_playerSkillsRemaining is EqualUnmodifiableSetView)
      return _playerSkillsRemaining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_playerSkillsRemaining);
  }

  final Set<BlindBluffSkill> _opponentSkillsRemaining;
  @override
  Set<BlindBluffSkill> get opponentSkillsRemaining {
    if (_opponentSkillsRemaining is EqualUnmodifiableSetView)
      return _opponentSkillsRemaining;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_opponentSkillsRemaining);
  }

  /// Chips opponent put in **beyond** matching your wager (shown ~1s in UI once).
  @override
  final int? opponentRaiseNoticeChips;

  /// One-shot: show ~1s banner that opponent checked.
  @override
  final bool opponentCheckNotice;

  @override
  String toString() {
    return 'BlindBluffMatchState.bettingPhase(roundNumber: $roundNumber, playerChips: $playerChips, opponentChips: $opponentChips, pot: $pot, baseAnteFrozenForRound: $baseAnteFrozenForRound, opponentCard: $opponentCard, playerCard: $playerCard, betting: $betting, chipsToCallPlayer: $chipsToCallPlayer, playerHasPenaltyInsurance: $playerHasPenaltyInsurance, opponentHasPenaltyInsurance: $opponentHasPenaltyInsurance, secondsRemaining: $secondsRemaining, actionLog: $actionLog, playerSkillsRemaining: $playerSkillsRemaining, opponentSkillsRemaining: $opponentSkillsRemaining, opponentRaiseNoticeChips: $opponentRaiseNoticeChips, opponentCheckNotice: $opponentCheckNotice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BbBettingPhaseImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.playerChips, playerChips) ||
                other.playerChips == playerChips) &&
            (identical(other.opponentChips, opponentChips) ||
                other.opponentChips == opponentChips) &&
            (identical(other.pot, pot) || other.pot == pot) &&
            (identical(other.baseAnteFrozenForRound, baseAnteFrozenForRound) ||
                other.baseAnteFrozenForRound == baseAnteFrozenForRound) &&
            (identical(other.opponentCard, opponentCard) ||
                other.opponentCard == opponentCard) &&
            (identical(other.playerCard, playerCard) ||
                other.playerCard == playerCard) &&
            (identical(other.betting, betting) || other.betting == betting) &&
            (identical(other.chipsToCallPlayer, chipsToCallPlayer) ||
                other.chipsToCallPlayer == chipsToCallPlayer) &&
            (identical(other.playerHasPenaltyInsurance,
                    playerHasPenaltyInsurance) ||
                other.playerHasPenaltyInsurance == playerHasPenaltyInsurance) &&
            (identical(other.opponentHasPenaltyInsurance,
                    opponentHasPenaltyInsurance) ||
                other.opponentHasPenaltyInsurance ==
                    opponentHasPenaltyInsurance) &&
            (identical(other.secondsRemaining, secondsRemaining) ||
                other.secondsRemaining == secondsRemaining) &&
            const DeepCollectionEquality()
                .equals(other._actionLog, _actionLog) &&
            const DeepCollectionEquality()
                .equals(other._playerSkillsRemaining, _playerSkillsRemaining) &&
            const DeepCollectionEquality().equals(
                other._opponentSkillsRemaining, _opponentSkillsRemaining) &&
            (identical(
                    other.opponentRaiseNoticeChips, opponentRaiseNoticeChips) ||
                other.opponentRaiseNoticeChips == opponentRaiseNoticeChips) &&
            (identical(other.opponentCheckNotice, opponentCheckNotice) ||
                other.opponentCheckNotice == opponentCheckNotice));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roundNumber,
      playerChips,
      opponentChips,
      pot,
      baseAnteFrozenForRound,
      opponentCard,
      playerCard,
      betting,
      chipsToCallPlayer,
      playerHasPenaltyInsurance,
      opponentHasPenaltyInsurance,
      secondsRemaining,
      const DeepCollectionEquality().hash(_actionLog),
      const DeepCollectionEquality().hash(_playerSkillsRemaining),
      const DeepCollectionEquality().hash(_opponentSkillsRemaining),
      opponentRaiseNoticeChips,
      opponentCheckNotice);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BbBettingPhaseImplCopyWith<_$BbBettingPhaseImpl> get copyWith =>
      __$$BbBettingPhaseImplCopyWithImpl<_$BbBettingPhaseImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) {
    return bettingPhase(
        roundNumber,
        playerChips,
        opponentChips,
        pot,
        baseAnteFrozenForRound,
        opponentCard,
        playerCard,
        betting,
        chipsToCallPlayer,
        playerHasPenaltyInsurance,
        opponentHasPenaltyInsurance,
        secondsRemaining,
        actionLog,
        playerSkillsRemaining,
        opponentSkillsRemaining,
        opponentRaiseNoticeChips,
        opponentCheckNotice);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) {
    return bettingPhase?.call(
        roundNumber,
        playerChips,
        opponentChips,
        pot,
        baseAnteFrozenForRound,
        opponentCard,
        playerCard,
        betting,
        chipsToCallPlayer,
        playerHasPenaltyInsurance,
        opponentHasPenaltyInsurance,
        secondsRemaining,
        actionLog,
        playerSkillsRemaining,
        opponentSkillsRemaining,
        opponentRaiseNoticeChips,
        opponentCheckNotice);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) {
    if (bettingPhase != null) {
      return bettingPhase(
          roundNumber,
          playerChips,
          opponentChips,
          pot,
          baseAnteFrozenForRound,
          opponentCard,
          playerCard,
          betting,
          chipsToCallPlayer,
          playerHasPenaltyInsurance,
          opponentHasPenaltyInsurance,
          secondsRemaining,
          actionLog,
          playerSkillsRemaining,
          opponentSkillsRemaining,
          opponentRaiseNoticeChips,
          opponentCheckNotice);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) {
    return bettingPhase(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) {
    return bettingPhase?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (bettingPhase != null) {
      return bettingPhase(this);
    }
    return orElse();
  }
}

abstract class _BbBettingPhase implements BlindBluffMatchState {
  const factory _BbBettingPhase(
      {required final int roundNumber,
      required final int playerChips,
      required final int opponentChips,
      required final int pot,
      required final int baseAnteFrozenForRound,
      required final BlindCard opponentCard,
      required final BlindCard playerCard,
      required final BlindBluffBettingPublicView betting,
      required final int chipsToCallPlayer,
      required final bool playerHasPenaltyInsurance,
      required final bool opponentHasPenaltyInsurance,
      required final int secondsRemaining,
      required final List<String> actionLog,
      required final Set<BlindBluffSkill> playerSkillsRemaining,
      required final Set<BlindBluffSkill> opponentSkillsRemaining,
      final int? opponentRaiseNoticeChips,
      required final bool opponentCheckNotice}) = _$BbBettingPhaseImpl;

  int get roundNumber;
  int get playerChips;
  int get opponentChips;
  int get pot;
  int get baseAnteFrozenForRound;
  BlindCard get opponentCard;
  BlindCard get playerCard;
  BlindBluffBettingPublicView get betting;
  int get chipsToCallPlayer;
  bool get playerHasPenaltyInsurance;
  bool get opponentHasPenaltyInsurance;
  int get secondsRemaining;
  List<String> get actionLog;
  Set<BlindBluffSkill> get playerSkillsRemaining;
  Set<BlindBluffSkill> get opponentSkillsRemaining;

  /// Chips opponent put in **beyond** matching your wager (shown ~1s in UI once).
  int? get opponentRaiseNoticeChips;

  /// One-shot: show ~1s banner that opponent checked.
  bool get opponentCheckNotice;

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BbBettingPhaseImplCopyWith<_$BbBettingPhaseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BbShowdownImplCopyWith<$Res> {
  factory _$$BbShowdownImplCopyWith(
          _$BbShowdownImpl value, $Res Function(_$BbShowdownImpl) then) =
      __$$BbShowdownImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int roundNumber,
      BlindBluffRoundResolution resolution,
      int playerChips,
      int opponentChips,
      List<String> actionLog,
      bool matchCompletePending});

  $BlindBluffRoundResolutionCopyWith<$Res> get resolution;
}

/// @nodoc
class __$$BbShowdownImplCopyWithImpl<$Res>
    extends _$BlindBluffMatchStateCopyWithImpl<$Res, _$BbShowdownImpl>
    implements _$$BbShowdownImplCopyWith<$Res> {
  __$$BbShowdownImplCopyWithImpl(
      _$BbShowdownImpl _value, $Res Function(_$BbShowdownImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? roundNumber = null,
    Object? resolution = null,
    Object? playerChips = null,
    Object? opponentChips = null,
    Object? actionLog = null,
    Object? matchCompletePending = null,
  }) {
    return _then(_$BbShowdownImpl(
      roundNumber: null == roundNumber
          ? _value.roundNumber
          : roundNumber // ignore: cast_nullable_to_non_nullable
              as int,
      resolution: null == resolution
          ? _value.resolution
          : resolution // ignore: cast_nullable_to_non_nullable
              as BlindBluffRoundResolution,
      playerChips: null == playerChips
          ? _value.playerChips
          : playerChips // ignore: cast_nullable_to_non_nullable
              as int,
      opponentChips: null == opponentChips
          ? _value.opponentChips
          : opponentChips // ignore: cast_nullable_to_non_nullable
              as int,
      actionLog: null == actionLog
          ? _value._actionLog
          : actionLog // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchCompletePending: null == matchCompletePending
          ? _value.matchCompletePending
          : matchCompletePending // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of BlindBluffMatchState
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

class _$BbShowdownImpl implements _BbShowdown {
  const _$BbShowdownImpl(
      {required this.roundNumber,
      required this.resolution,
      required this.playerChips,
      required this.opponentChips,
      required final List<String> actionLog,
      required this.matchCompletePending})
      : _actionLog = actionLog;

  @override
  final int roundNumber;
  @override
  final BlindBluffRoundResolution resolution;
  @override
  final int playerChips;
  @override
  final int opponentChips;
  final List<String> _actionLog;
  @override
  List<String> get actionLog {
    if (_actionLog is EqualUnmodifiableListView) return _actionLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionLog);
  }

  /// True when stacks already reflect match end — UI shows hand, then summary.
  @override
  final bool matchCompletePending;

  @override
  String toString() {
    return 'BlindBluffMatchState.showdown(roundNumber: $roundNumber, resolution: $resolution, playerChips: $playerChips, opponentChips: $opponentChips, actionLog: $actionLog, matchCompletePending: $matchCompletePending)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BbShowdownImpl &&
            (identical(other.roundNumber, roundNumber) ||
                other.roundNumber == roundNumber) &&
            (identical(other.resolution, resolution) ||
                other.resolution == resolution) &&
            (identical(other.playerChips, playerChips) ||
                other.playerChips == playerChips) &&
            (identical(other.opponentChips, opponentChips) ||
                other.opponentChips == opponentChips) &&
            const DeepCollectionEquality()
                .equals(other._actionLog, _actionLog) &&
            (identical(other.matchCompletePending, matchCompletePending) ||
                other.matchCompletePending == matchCompletePending));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      roundNumber,
      resolution,
      playerChips,
      opponentChips,
      const DeepCollectionEquality().hash(_actionLog),
      matchCompletePending);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BbShowdownImplCopyWith<_$BbShowdownImpl> get copyWith =>
      __$$BbShowdownImplCopyWithImpl<_$BbShowdownImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) {
    return showdown(roundNumber, resolution, playerChips, opponentChips,
        actionLog, matchCompletePending);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) {
    return showdown?.call(roundNumber, resolution, playerChips, opponentChips,
        actionLog, matchCompletePending);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) {
    if (showdown != null) {
      return showdown(roundNumber, resolution, playerChips, opponentChips,
          actionLog, matchCompletePending);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) {
    return showdown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) {
    return showdown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (showdown != null) {
      return showdown(this);
    }
    return orElse();
  }
}

abstract class _BbShowdown implements BlindBluffMatchState {
  const factory _BbShowdown(
      {required final int roundNumber,
      required final BlindBluffRoundResolution resolution,
      required final int playerChips,
      required final int opponentChips,
      required final List<String> actionLog,
      required final bool matchCompletePending}) = _$BbShowdownImpl;

  int get roundNumber;
  BlindBluffRoundResolution get resolution;
  int get playerChips;
  int get opponentChips;
  List<String> get actionLog;

  /// True when stacks already reflect match end — UI shows hand, then summary.
  bool get matchCompletePending;

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BbShowdownImplCopyWith<_$BbShowdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BbGameOverImplCopyWith<$Res> {
  factory _$$BbGameOverImplCopyWith(
          _$BbGameOverImpl value, $Res Function(_$BbGameOverImpl) then) =
      __$$BbGameOverImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {BlindBluffPlayerId winner,
      String reason,
      int playerChips,
      int opponentChips,
      BlindBluffRoundResolution? terminalRoundResolution,
      int? terminalRoundNumber});

  $BlindBluffRoundResolutionCopyWith<$Res>? get terminalRoundResolution;
}

/// @nodoc
class __$$BbGameOverImplCopyWithImpl<$Res>
    extends _$BlindBluffMatchStateCopyWithImpl<$Res, _$BbGameOverImpl>
    implements _$$BbGameOverImplCopyWith<$Res> {
  __$$BbGameOverImplCopyWithImpl(
      _$BbGameOverImpl _value, $Res Function(_$BbGameOverImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = null,
    Object? reason = null,
    Object? playerChips = null,
    Object? opponentChips = null,
    Object? terminalRoundResolution = freezed,
    Object? terminalRoundNumber = freezed,
  }) {
    return _then(_$BbGameOverImpl(
      winner: null == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as BlindBluffPlayerId,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
      playerChips: null == playerChips
          ? _value.playerChips
          : playerChips // ignore: cast_nullable_to_non_nullable
              as int,
      opponentChips: null == opponentChips
          ? _value.opponentChips
          : opponentChips // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of BlindBluffMatchState
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

class _$BbGameOverImpl implements _BbGameOver {
  const _$BbGameOverImpl(
      {required this.winner,
      required this.reason,
      required this.playerChips,
      required this.opponentChips,
      this.terminalRoundResolution,
      this.terminalRoundNumber});

  @override
  final BlindBluffPlayerId winner;
  @override
  final String reason;
  @override
  final int playerChips;
  @override
  final int opponentChips;
  @override
  final BlindBluffRoundResolution? terminalRoundResolution;
  @override
  final int? terminalRoundNumber;

  @override
  String toString() {
    return 'BlindBluffMatchState.gameOver(winner: $winner, reason: $reason, playerChips: $playerChips, opponentChips: $opponentChips, terminalRoundResolution: $terminalRoundResolution, terminalRoundNumber: $terminalRoundNumber)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BbGameOverImpl &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.playerChips, playerChips) ||
                other.playerChips == playerChips) &&
            (identical(other.opponentChips, opponentChips) ||
                other.opponentChips == opponentChips) &&
            (identical(
                    other.terminalRoundResolution, terminalRoundResolution) ||
                other.terminalRoundResolution == terminalRoundResolution) &&
            (identical(other.terminalRoundNumber, terminalRoundNumber) ||
                other.terminalRoundNumber == terminalRoundNumber));
  }

  @override
  int get hashCode => Object.hash(runtimeType, winner, reason, playerChips,
      opponentChips, terminalRoundResolution, terminalRoundNumber);

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BbGameOverImplCopyWith<_$BbGameOverImpl> get copyWith =>
      __$$BbGameOverImplCopyWithImpl<_$BbGameOverImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() loading,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)
        staredownPhase,
    required TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)
        bettingPhase,
    required TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)
        showdown,
    required TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)
        gameOver,
  }) {
    return gameOver(winner, reason, playerChips, opponentChips,
        terminalRoundResolution, terminalRoundNumber);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? loading,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult? Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult? Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult? Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
  }) {
    return gameOver?.call(winner, reason, playerChips, opponentChips,
        terminalRoundResolution, terminalRoundNumber);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? loading,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            bool playerLockedSkill,
            bool opponentLockedSkill,
            bool awaitingIntroSequence,
            int skillReflectionSecondsRemaining,
            bool awaitingSkillRevealAnimation,
            BlindBluffSkill? revealedPlayerSkill,
            BlindBluffSkill? revealedOpponentSkill,
            int secondsRemaining,
            List<String> actionLog,
            int? anteDoubledFrom,
            int? anteDoubledTo)?
        staredownPhase,
    TResult Function(
            int roundNumber,
            int playerChips,
            int opponentChips,
            int pot,
            int baseAnteFrozenForRound,
            BlindCard opponentCard,
            BlindCard playerCard,
            BlindBluffBettingPublicView betting,
            int chipsToCallPlayer,
            bool playerHasPenaltyInsurance,
            bool opponentHasPenaltyInsurance,
            int secondsRemaining,
            List<String> actionLog,
            Set<BlindBluffSkill> playerSkillsRemaining,
            Set<BlindBluffSkill> opponentSkillsRemaining,
            int? opponentRaiseNoticeChips,
            bool opponentCheckNotice)?
        bettingPhase,
    TResult Function(
            int roundNumber,
            BlindBluffRoundResolution resolution,
            int playerChips,
            int opponentChips,
            List<String> actionLog,
            bool matchCompletePending)?
        showdown,
    TResult Function(
            BlindBluffPlayerId winner,
            String reason,
            int playerChips,
            int opponentChips,
            BlindBluffRoundResolution? terminalRoundResolution,
            int? terminalRoundNumber)?
        gameOver,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(winner, reason, playerChips, opponentChips,
          terminalRoundResolution, terminalRoundNumber);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BbLoading value) loading,
    required TResult Function(_BbStaredownPhase value) staredownPhase,
    required TResult Function(_BbBettingPhase value) bettingPhase,
    required TResult Function(_BbShowdown value) showdown,
    required TResult Function(_BbGameOver value) gameOver,
  }) {
    return gameOver(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BbLoading value)? loading,
    TResult? Function(_BbStaredownPhase value)? staredownPhase,
    TResult? Function(_BbBettingPhase value)? bettingPhase,
    TResult? Function(_BbShowdown value)? showdown,
    TResult? Function(_BbGameOver value)? gameOver,
  }) {
    return gameOver?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BbLoading value)? loading,
    TResult Function(_BbStaredownPhase value)? staredownPhase,
    TResult Function(_BbBettingPhase value)? bettingPhase,
    TResult Function(_BbShowdown value)? showdown,
    TResult Function(_BbGameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(this);
    }
    return orElse();
  }
}

abstract class _BbGameOver implements BlindBluffMatchState {
  const factory _BbGameOver(
      {required final BlindBluffPlayerId winner,
      required final String reason,
      required final int playerChips,
      required final int opponentChips,
      final BlindBluffRoundResolution? terminalRoundResolution,
      final int? terminalRoundNumber}) = _$BbGameOverImpl;

  BlindBluffPlayerId get winner;
  String get reason;
  int get playerChips;
  int get opponentChips;
  BlindBluffRoundResolution? get terminalRoundResolution;
  int? get terminalRoundNumber;

  /// Create a copy of BlindBluffMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BbGameOverImplCopyWith<_$BbGameOverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
