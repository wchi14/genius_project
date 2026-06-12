// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'blind_count_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BlindCountState {
  BlindPlayerId get currentTurn => throw _privateConstructorUsedError;
  List<BlockModel> get p1Blocks => throw _privateConstructorUsedError;
  int get p2BlockCount => throw _privateConstructorUsedError;
  List<BlockModel> get hiddenP2Blocks => throw _privateConstructorUsedError;
  int get p1Score => throw _privateConstructorUsedError;
  int get p2Score => throw _privateConstructorUsedError;
  int get currentTurnComboScore => throw _privateConstructorUsedError;
  int get poolRemaining => throw _privateConstructorUsedError;
  bool get isSumRevealed => throw _privateConstructorUsedError;
  List<String> get p1UsedSkills => throw _privateConstructorUsedError;
  List<String> get p2UsedSkills => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;
  int get turnRemainingSeconds => throw _privateConstructorUsedError;
  String? get activeSkillNotification => throw _privateConstructorUsedError;
  String? get skillResultData => throw _privateConstructorUsedError;
  BlindPlayerId? get skillUsedBy => throw _privateConstructorUsedError;
  int? get skillPeekRemainingSeconds => throw _privateConstructorUsedError;
  BlindCountGuessFeedback? get lastGuessFeedback =>
      throw _privateConstructorUsedError;
  Set<String> get revealedP2BlockIds => throw _privateConstructorUsedError;
  bool get isResolvingGuess => throw _privateConstructorUsedError;
  bool get hasGuessedThisTurn => throw _privateConstructorUsedError;
  bool get hasUsedSkillThisTurn => throw _privateConstructorUsedError;

  /// Create a copy of BlindCountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BlindCountStateCopyWith<BlindCountState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BlindCountStateCopyWith<$Res> {
  factory $BlindCountStateCopyWith(
          BlindCountState value, $Res Function(BlindCountState) then) =
      _$BlindCountStateCopyWithImpl<$Res, BlindCountState>;
  @useResult
  $Res call(
      {BlindPlayerId currentTurn,
      List<BlockModel> p1Blocks,
      int p2BlockCount,
      List<BlockModel> hiddenP2Blocks,
      int p1Score,
      int p2Score,
      int currentTurnComboScore,
      int poolRemaining,
      bool isSumRevealed,
      List<String> p1UsedSkills,
      List<String> p2UsedSkills,
      bool isGameOver,
      int turnRemainingSeconds,
      String? activeSkillNotification,
      String? skillResultData,
      BlindPlayerId? skillUsedBy,
      int? skillPeekRemainingSeconds,
      BlindCountGuessFeedback? lastGuessFeedback,
      Set<String> revealedP2BlockIds,
      bool isResolvingGuess,
      bool hasGuessedThisTurn,
      bool hasUsedSkillThisTurn});
}

/// @nodoc
class _$BlindCountStateCopyWithImpl<$Res, $Val extends BlindCountState>
    implements $BlindCountStateCopyWith<$Res> {
  _$BlindCountStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BlindCountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTurn = null,
    Object? p1Blocks = null,
    Object? p2BlockCount = null,
    Object? hiddenP2Blocks = null,
    Object? p1Score = null,
    Object? p2Score = null,
    Object? currentTurnComboScore = null,
    Object? poolRemaining = null,
    Object? isSumRevealed = null,
    Object? p1UsedSkills = null,
    Object? p2UsedSkills = null,
    Object? isGameOver = null,
    Object? turnRemainingSeconds = null,
    Object? activeSkillNotification = freezed,
    Object? skillResultData = freezed,
    Object? skillUsedBy = freezed,
    Object? skillPeekRemainingSeconds = freezed,
    Object? lastGuessFeedback = freezed,
    Object? revealedP2BlockIds = null,
    Object? isResolvingGuess = null,
    Object? hasGuessedThisTurn = null,
    Object? hasUsedSkillThisTurn = null,
  }) {
    return _then(_value.copyWith(
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as BlindPlayerId,
      p1Blocks: null == p1Blocks
          ? _value.p1Blocks
          : p1Blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
      p2BlockCount: null == p2BlockCount
          ? _value.p2BlockCount
          : p2BlockCount // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenP2Blocks: null == hiddenP2Blocks
          ? _value.hiddenP2Blocks
          : hiddenP2Blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
      p1Score: null == p1Score
          ? _value.p1Score
          : p1Score // ignore: cast_nullable_to_non_nullable
              as int,
      p2Score: null == p2Score
          ? _value.p2Score
          : p2Score // ignore: cast_nullable_to_non_nullable
              as int,
      currentTurnComboScore: null == currentTurnComboScore
          ? _value.currentTurnComboScore
          : currentTurnComboScore // ignore: cast_nullable_to_non_nullable
              as int,
      poolRemaining: null == poolRemaining
          ? _value.poolRemaining
          : poolRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      isSumRevealed: null == isSumRevealed
          ? _value.isSumRevealed
          : isSumRevealed // ignore: cast_nullable_to_non_nullable
              as bool,
      p1UsedSkills: null == p1UsedSkills
          ? _value.p1UsedSkills
          : p1UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      p2UsedSkills: null == p2UsedSkills
          ? _value.p2UsedSkills
          : p2UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      turnRemainingSeconds: null == turnRemainingSeconds
          ? _value.turnRemainingSeconds
          : turnRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      activeSkillNotification: freezed == activeSkillNotification
          ? _value.activeSkillNotification
          : activeSkillNotification // ignore: cast_nullable_to_non_nullable
              as String?,
      skillResultData: freezed == skillResultData
          ? _value.skillResultData
          : skillResultData // ignore: cast_nullable_to_non_nullable
              as String?,
      skillUsedBy: freezed == skillUsedBy
          ? _value.skillUsedBy
          : skillUsedBy // ignore: cast_nullable_to_non_nullable
              as BlindPlayerId?,
      skillPeekRemainingSeconds: freezed == skillPeekRemainingSeconds
          ? _value.skillPeekRemainingSeconds
          : skillPeekRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      lastGuessFeedback: freezed == lastGuessFeedback
          ? _value.lastGuessFeedback
          : lastGuessFeedback // ignore: cast_nullable_to_non_nullable
              as BlindCountGuessFeedback?,
      revealedP2BlockIds: null == revealedP2BlockIds
          ? _value.revealedP2BlockIds
          : revealedP2BlockIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isResolvingGuess: null == isResolvingGuess
          ? _value.isResolvingGuess
          : isResolvingGuess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGuessedThisTurn: null == hasGuessedThisTurn
          ? _value.hasGuessedThisTurn
          : hasGuessedThisTurn // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUsedSkillThisTurn: null == hasUsedSkillThisTurn
          ? _value.hasUsedSkillThisTurn
          : hasUsedSkillThisTurn // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BlindCountStateImplCopyWith<$Res>
    implements $BlindCountStateCopyWith<$Res> {
  factory _$$BlindCountStateImplCopyWith(_$BlindCountStateImpl value,
          $Res Function(_$BlindCountStateImpl) then) =
      __$$BlindCountStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {BlindPlayerId currentTurn,
      List<BlockModel> p1Blocks,
      int p2BlockCount,
      List<BlockModel> hiddenP2Blocks,
      int p1Score,
      int p2Score,
      int currentTurnComboScore,
      int poolRemaining,
      bool isSumRevealed,
      List<String> p1UsedSkills,
      List<String> p2UsedSkills,
      bool isGameOver,
      int turnRemainingSeconds,
      String? activeSkillNotification,
      String? skillResultData,
      BlindPlayerId? skillUsedBy,
      int? skillPeekRemainingSeconds,
      BlindCountGuessFeedback? lastGuessFeedback,
      Set<String> revealedP2BlockIds,
      bool isResolvingGuess,
      bool hasGuessedThisTurn,
      bool hasUsedSkillThisTurn});
}

/// @nodoc
class __$$BlindCountStateImplCopyWithImpl<$Res>
    extends _$BlindCountStateCopyWithImpl<$Res, _$BlindCountStateImpl>
    implements _$$BlindCountStateImplCopyWith<$Res> {
  __$$BlindCountStateImplCopyWithImpl(
      _$BlindCountStateImpl _value, $Res Function(_$BlindCountStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of BlindCountState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentTurn = null,
    Object? p1Blocks = null,
    Object? p2BlockCount = null,
    Object? hiddenP2Blocks = null,
    Object? p1Score = null,
    Object? p2Score = null,
    Object? currentTurnComboScore = null,
    Object? poolRemaining = null,
    Object? isSumRevealed = null,
    Object? p1UsedSkills = null,
    Object? p2UsedSkills = null,
    Object? isGameOver = null,
    Object? turnRemainingSeconds = null,
    Object? activeSkillNotification = freezed,
    Object? skillResultData = freezed,
    Object? skillUsedBy = freezed,
    Object? skillPeekRemainingSeconds = freezed,
    Object? lastGuessFeedback = freezed,
    Object? revealedP2BlockIds = null,
    Object? isResolvingGuess = null,
    Object? hasGuessedThisTurn = null,
    Object? hasUsedSkillThisTurn = null,
  }) {
    return _then(_$BlindCountStateImpl(
      currentTurn: null == currentTurn
          ? _value.currentTurn
          : currentTurn // ignore: cast_nullable_to_non_nullable
              as BlindPlayerId,
      p1Blocks: null == p1Blocks
          ? _value._p1Blocks
          : p1Blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
      p2BlockCount: null == p2BlockCount
          ? _value.p2BlockCount
          : p2BlockCount // ignore: cast_nullable_to_non_nullable
              as int,
      hiddenP2Blocks: null == hiddenP2Blocks
          ? _value._hiddenP2Blocks
          : hiddenP2Blocks // ignore: cast_nullable_to_non_nullable
              as List<BlockModel>,
      p1Score: null == p1Score
          ? _value.p1Score
          : p1Score // ignore: cast_nullable_to_non_nullable
              as int,
      p2Score: null == p2Score
          ? _value.p2Score
          : p2Score // ignore: cast_nullable_to_non_nullable
              as int,
      currentTurnComboScore: null == currentTurnComboScore
          ? _value.currentTurnComboScore
          : currentTurnComboScore // ignore: cast_nullable_to_non_nullable
              as int,
      poolRemaining: null == poolRemaining
          ? _value.poolRemaining
          : poolRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      isSumRevealed: null == isSumRevealed
          ? _value.isSumRevealed
          : isSumRevealed // ignore: cast_nullable_to_non_nullable
              as bool,
      p1UsedSkills: null == p1UsedSkills
          ? _value._p1UsedSkills
          : p1UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      p2UsedSkills: null == p2UsedSkills
          ? _value._p2UsedSkills
          : p2UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      turnRemainingSeconds: null == turnRemainingSeconds
          ? _value.turnRemainingSeconds
          : turnRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      activeSkillNotification: freezed == activeSkillNotification
          ? _value.activeSkillNotification
          : activeSkillNotification // ignore: cast_nullable_to_non_nullable
              as String?,
      skillResultData: freezed == skillResultData
          ? _value.skillResultData
          : skillResultData // ignore: cast_nullable_to_non_nullable
              as String?,
      skillUsedBy: freezed == skillUsedBy
          ? _value.skillUsedBy
          : skillUsedBy // ignore: cast_nullable_to_non_nullable
              as BlindPlayerId?,
      skillPeekRemainingSeconds: freezed == skillPeekRemainingSeconds
          ? _value.skillPeekRemainingSeconds
          : skillPeekRemainingSeconds // ignore: cast_nullable_to_non_nullable
              as int?,
      lastGuessFeedback: freezed == lastGuessFeedback
          ? _value.lastGuessFeedback
          : lastGuessFeedback // ignore: cast_nullable_to_non_nullable
              as BlindCountGuessFeedback?,
      revealedP2BlockIds: null == revealedP2BlockIds
          ? _value._revealedP2BlockIds
          : revealedP2BlockIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      isResolvingGuess: null == isResolvingGuess
          ? _value.isResolvingGuess
          : isResolvingGuess // ignore: cast_nullable_to_non_nullable
              as bool,
      hasGuessedThisTurn: null == hasGuessedThisTurn
          ? _value.hasGuessedThisTurn
          : hasGuessedThisTurn // ignore: cast_nullable_to_non_nullable
              as bool,
      hasUsedSkillThisTurn: null == hasUsedSkillThisTurn
          ? _value.hasUsedSkillThisTurn
          : hasUsedSkillThisTurn // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$BlindCountStateImpl extends _BlindCountState {
  const _$BlindCountStateImpl(
      {required this.currentTurn,
      required final List<BlockModel> p1Blocks,
      required this.p2BlockCount,
      required final List<BlockModel> hiddenP2Blocks,
      required this.p1Score,
      required this.p2Score,
      required this.currentTurnComboScore,
      required this.poolRemaining,
      required this.isSumRevealed,
      required final List<String> p1UsedSkills,
      final List<String> p2UsedSkills = const <String>[],
      required this.isGameOver,
      required this.turnRemainingSeconds,
      this.activeSkillNotification,
      this.skillResultData,
      this.skillUsedBy,
      this.skillPeekRemainingSeconds,
      this.lastGuessFeedback,
      final Set<String> revealedP2BlockIds = const <String>{},
      this.isResolvingGuess = false,
      this.hasGuessedThisTurn = false,
      this.hasUsedSkillThisTurn = false})
      : _p1Blocks = p1Blocks,
        _hiddenP2Blocks = hiddenP2Blocks,
        _p1UsedSkills = p1UsedSkills,
        _p2UsedSkills = p2UsedSkills,
        _revealedP2BlockIds = revealedP2BlockIds,
        super._();

  @override
  final BlindPlayerId currentTurn;
  final List<BlockModel> _p1Blocks;
  @override
  List<BlockModel> get p1Blocks {
    if (_p1Blocks is EqualUnmodifiableListView) return _p1Blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p1Blocks);
  }

  @override
  final int p2BlockCount;
  final List<BlockModel> _hiddenP2Blocks;
  @override
  List<BlockModel> get hiddenP2Blocks {
    if (_hiddenP2Blocks is EqualUnmodifiableListView) return _hiddenP2Blocks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hiddenP2Blocks);
  }

  @override
  final int p1Score;
  @override
  final int p2Score;
  @override
  final int currentTurnComboScore;
  @override
  final int poolRemaining;
  @override
  final bool isSumRevealed;
  final List<String> _p1UsedSkills;
  @override
  List<String> get p1UsedSkills {
    if (_p1UsedSkills is EqualUnmodifiableListView) return _p1UsedSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p1UsedSkills);
  }

  final List<String> _p2UsedSkills;
  @override
  @JsonKey()
  List<String> get p2UsedSkills {
    if (_p2UsedSkills is EqualUnmodifiableListView) return _p2UsedSkills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p2UsedSkills);
  }

  @override
  final bool isGameOver;
  @override
  final int turnRemainingSeconds;
  @override
  final String? activeSkillNotification;
  @override
  final String? skillResultData;
  @override
  final BlindPlayerId? skillUsedBy;
  @override
  final int? skillPeekRemainingSeconds;
  @override
  final BlindCountGuessFeedback? lastGuessFeedback;
  final Set<String> _revealedP2BlockIds;
  @override
  @JsonKey()
  Set<String> get revealedP2BlockIds {
    if (_revealedP2BlockIds is EqualUnmodifiableSetView)
      return _revealedP2BlockIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_revealedP2BlockIds);
  }

  @override
  @JsonKey()
  final bool isResolvingGuess;
  @override
  @JsonKey()
  final bool hasGuessedThisTurn;
  @override
  @JsonKey()
  final bool hasUsedSkillThisTurn;

  @override
  String toString() {
    return 'BlindCountState(currentTurn: $currentTurn, p1Blocks: $p1Blocks, p2BlockCount: $p2BlockCount, hiddenP2Blocks: $hiddenP2Blocks, p1Score: $p1Score, p2Score: $p2Score, currentTurnComboScore: $currentTurnComboScore, poolRemaining: $poolRemaining, isSumRevealed: $isSumRevealed, p1UsedSkills: $p1UsedSkills, p2UsedSkills: $p2UsedSkills, isGameOver: $isGameOver, turnRemainingSeconds: $turnRemainingSeconds, activeSkillNotification: $activeSkillNotification, skillResultData: $skillResultData, skillUsedBy: $skillUsedBy, skillPeekRemainingSeconds: $skillPeekRemainingSeconds, lastGuessFeedback: $lastGuessFeedback, revealedP2BlockIds: $revealedP2BlockIds, isResolvingGuess: $isResolvingGuess, hasGuessedThisTurn: $hasGuessedThisTurn, hasUsedSkillThisTurn: $hasUsedSkillThisTurn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BlindCountStateImpl &&
            (identical(other.currentTurn, currentTurn) ||
                other.currentTurn == currentTurn) &&
            const DeepCollectionEquality().equals(other._p1Blocks, _p1Blocks) &&
            (identical(other.p2BlockCount, p2BlockCount) ||
                other.p2BlockCount == p2BlockCount) &&
            const DeepCollectionEquality()
                .equals(other._hiddenP2Blocks, _hiddenP2Blocks) &&
            (identical(other.p1Score, p1Score) || other.p1Score == p1Score) &&
            (identical(other.p2Score, p2Score) || other.p2Score == p2Score) &&
            (identical(other.currentTurnComboScore, currentTurnComboScore) ||
                other.currentTurnComboScore == currentTurnComboScore) &&
            (identical(other.poolRemaining, poolRemaining) ||
                other.poolRemaining == poolRemaining) &&
            (identical(other.isSumRevealed, isSumRevealed) ||
                other.isSumRevealed == isSumRevealed) &&
            const DeepCollectionEquality()
                .equals(other._p1UsedSkills, _p1UsedSkills) &&
            const DeepCollectionEquality()
                .equals(other._p2UsedSkills, _p2UsedSkills) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.turnRemainingSeconds, turnRemainingSeconds) ||
                other.turnRemainingSeconds == turnRemainingSeconds) &&
            (identical(
                    other.activeSkillNotification, activeSkillNotification) ||
                other.activeSkillNotification == activeSkillNotification) &&
            (identical(other.skillResultData, skillResultData) ||
                other.skillResultData == skillResultData) &&
            (identical(other.skillUsedBy, skillUsedBy) ||
                other.skillUsedBy == skillUsedBy) &&
            (identical(other.skillPeekRemainingSeconds,
                    skillPeekRemainingSeconds) ||
                other.skillPeekRemainingSeconds == skillPeekRemainingSeconds) &&
            (identical(other.lastGuessFeedback, lastGuessFeedback) ||
                other.lastGuessFeedback == lastGuessFeedback) &&
            const DeepCollectionEquality()
                .equals(other._revealedP2BlockIds, _revealedP2BlockIds) &&
            (identical(other.isResolvingGuess, isResolvingGuess) ||
                other.isResolvingGuess == isResolvingGuess) &&
            (identical(other.hasGuessedThisTurn, hasGuessedThisTurn) ||
                other.hasGuessedThisTurn == hasGuessedThisTurn) &&
            (identical(other.hasUsedSkillThisTurn, hasUsedSkillThisTurn) ||
                other.hasUsedSkillThisTurn == hasUsedSkillThisTurn));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentTurn,
        const DeepCollectionEquality().hash(_p1Blocks),
        p2BlockCount,
        const DeepCollectionEquality().hash(_hiddenP2Blocks),
        p1Score,
        p2Score,
        currentTurnComboScore,
        poolRemaining,
        isSumRevealed,
        const DeepCollectionEquality().hash(_p1UsedSkills),
        const DeepCollectionEquality().hash(_p2UsedSkills),
        isGameOver,
        turnRemainingSeconds,
        activeSkillNotification,
        skillResultData,
        skillUsedBy,
        skillPeekRemainingSeconds,
        lastGuessFeedback,
        const DeepCollectionEquality().hash(_revealedP2BlockIds),
        isResolvingGuess,
        hasGuessedThisTurn,
        hasUsedSkillThisTurn
      ]);

  /// Create a copy of BlindCountState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BlindCountStateImplCopyWith<_$BlindCountStateImpl> get copyWith =>
      __$$BlindCountStateImplCopyWithImpl<_$BlindCountStateImpl>(
          this, _$identity);
}

abstract class _BlindCountState extends BlindCountState {
  const factory _BlindCountState(
      {required final BlindPlayerId currentTurn,
      required final List<BlockModel> p1Blocks,
      required final int p2BlockCount,
      required final List<BlockModel> hiddenP2Blocks,
      required final int p1Score,
      required final int p2Score,
      required final int currentTurnComboScore,
      required final int poolRemaining,
      required final bool isSumRevealed,
      required final List<String> p1UsedSkills,
      final List<String> p2UsedSkills,
      required final bool isGameOver,
      required final int turnRemainingSeconds,
      final String? activeSkillNotification,
      final String? skillResultData,
      final BlindPlayerId? skillUsedBy,
      final int? skillPeekRemainingSeconds,
      final BlindCountGuessFeedback? lastGuessFeedback,
      final Set<String> revealedP2BlockIds,
      final bool isResolvingGuess,
      final bool hasGuessedThisTurn,
      final bool hasUsedSkillThisTurn}) = _$BlindCountStateImpl;
  const _BlindCountState._() : super._();

  @override
  BlindPlayerId get currentTurn;
  @override
  List<BlockModel> get p1Blocks;
  @override
  int get p2BlockCount;
  @override
  List<BlockModel> get hiddenP2Blocks;
  @override
  int get p1Score;
  @override
  int get p2Score;
  @override
  int get currentTurnComboScore;
  @override
  int get poolRemaining;
  @override
  bool get isSumRevealed;
  @override
  List<String> get p1UsedSkills;
  @override
  List<String> get p2UsedSkills;
  @override
  bool get isGameOver;
  @override
  int get turnRemainingSeconds;
  @override
  String? get activeSkillNotification;
  @override
  String? get skillResultData;
  @override
  BlindPlayerId? get skillUsedBy;
  @override
  int? get skillPeekRemainingSeconds;
  @override
  BlindCountGuessFeedback? get lastGuessFeedback;
  @override
  Set<String> get revealedP2BlockIds;
  @override
  bool get isResolvingGuess;
  @override
  bool get hasGuessedThisTurn;
  @override
  bool get hasUsedSkillThisTurn;

  /// Create a copy of BlindCountState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BlindCountStateImplCopyWith<_$BlindCountStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
