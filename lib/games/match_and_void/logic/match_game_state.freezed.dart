// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MatchGameState {
  MatchGameMode get mode => throw _privateConstructorUsedError;
  int get currentBoardIndex => throw _privateConstructorUsedError;
  List<MatchCard> get currentBoard => throw _privateConstructorUsedError;
  List<int> get selectedIndices => throw _privateConstructorUsedError;
  List<List<MatchCard>> get historyLog => throw _privateConstructorUsedError;
  int get currentScore => throw _privateConstructorUsedError;
  int get voidPenaltyLevel => throw _privateConstructorUsedError;
  int get remainingSeconds => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;

  /// One-shot penalty dialog for wrong match / wrong void.
  MatchGameFeedback? get pendingFeedback => throw _privateConstructorUsedError;

  /// True when five wrong voids in a row force-advance the board (show dialog).
  bool get voidStreakAdvanceNotice => throw _privateConstructorUsedError;

  /// Create a copy of MatchGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchGameStateCopyWith<MatchGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchGameStateCopyWith<$Res> {
  factory $MatchGameStateCopyWith(
          MatchGameState value, $Res Function(MatchGameState) then) =
      _$MatchGameStateCopyWithImpl<$Res, MatchGameState>;
  @useResult
  $Res call(
      {MatchGameMode mode,
      int currentBoardIndex,
      List<MatchCard> currentBoard,
      List<int> selectedIndices,
      List<List<MatchCard>> historyLog,
      int currentScore,
      int voidPenaltyLevel,
      int remainingSeconds,
      bool isGameOver,
      MatchGameFeedback? pendingFeedback,
      bool voidStreakAdvanceNotice});
}

/// @nodoc
class _$MatchGameStateCopyWithImpl<$Res, $Val extends MatchGameState>
    implements $MatchGameStateCopyWith<$Res> {
  _$MatchGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatchGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? currentBoardIndex = null,
    Object? currentBoard = null,
    Object? selectedIndices = null,
    Object? historyLog = null,
    Object? currentScore = null,
    Object? voidPenaltyLevel = null,
    Object? remainingSeconds = null,
    Object? isGameOver = null,
    Object? pendingFeedback = freezed,
    Object? voidStreakAdvanceNotice = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as MatchGameMode,
      currentBoardIndex: null == currentBoardIndex
          ? _value.currentBoardIndex
          : currentBoardIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentBoard: null == currentBoard
          ? _value.currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as List<MatchCard>,
      selectedIndices: null == selectedIndices
          ? _value.selectedIndices
          : selectedIndices // ignore: cast_nullable_to_non_nullable
              as List<int>,
      historyLog: null == historyLog
          ? _value.historyLog
          : historyLog // ignore: cast_nullable_to_non_nullable
              as List<List<MatchCard>>,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as int,
      voidPenaltyLevel: null == voidPenaltyLevel
          ? _value.voidPenaltyLevel
          : voidPenaltyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingFeedback: freezed == pendingFeedback
          ? _value.pendingFeedback
          : pendingFeedback // ignore: cast_nullable_to_non_nullable
              as MatchGameFeedback?,
      voidStreakAdvanceNotice: null == voidStreakAdvanceNotice
          ? _value.voidStreakAdvanceNotice
          : voidStreakAdvanceNotice // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchGameStateImplCopyWith<$Res>
    implements $MatchGameStateCopyWith<$Res> {
  factory _$$MatchGameStateImplCopyWith(_$MatchGameStateImpl value,
          $Res Function(_$MatchGameStateImpl) then) =
      __$$MatchGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {MatchGameMode mode,
      int currentBoardIndex,
      List<MatchCard> currentBoard,
      List<int> selectedIndices,
      List<List<MatchCard>> historyLog,
      int currentScore,
      int voidPenaltyLevel,
      int remainingSeconds,
      bool isGameOver,
      MatchGameFeedback? pendingFeedback,
      bool voidStreakAdvanceNotice});
}

/// @nodoc
class __$$MatchGameStateImplCopyWithImpl<$Res>
    extends _$MatchGameStateCopyWithImpl<$Res, _$MatchGameStateImpl>
    implements _$$MatchGameStateImplCopyWith<$Res> {
  __$$MatchGameStateImplCopyWithImpl(
      _$MatchGameStateImpl _value, $Res Function(_$MatchGameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatchGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? currentBoardIndex = null,
    Object? currentBoard = null,
    Object? selectedIndices = null,
    Object? historyLog = null,
    Object? currentScore = null,
    Object? voidPenaltyLevel = null,
    Object? remainingSeconds = null,
    Object? isGameOver = null,
    Object? pendingFeedback = freezed,
    Object? voidStreakAdvanceNotice = null,
  }) {
    return _then(_$MatchGameStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as MatchGameMode,
      currentBoardIndex: null == currentBoardIndex
          ? _value.currentBoardIndex
          : currentBoardIndex // ignore: cast_nullable_to_non_nullable
              as int,
      currentBoard: null == currentBoard
          ? _value._currentBoard
          : currentBoard // ignore: cast_nullable_to_non_nullable
              as List<MatchCard>,
      selectedIndices: null == selectedIndices
          ? _value._selectedIndices
          : selectedIndices // ignore: cast_nullable_to_non_nullable
              as List<int>,
      historyLog: null == historyLog
          ? _value._historyLog
          : historyLog // ignore: cast_nullable_to_non_nullable
              as List<List<MatchCard>>,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as int,
      voidPenaltyLevel: null == voidPenaltyLevel
          ? _value.voidPenaltyLevel
          : voidPenaltyLevel // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      pendingFeedback: freezed == pendingFeedback
          ? _value.pendingFeedback
          : pendingFeedback // ignore: cast_nullable_to_non_nullable
              as MatchGameFeedback?,
      voidStreakAdvanceNotice: null == voidStreakAdvanceNotice
          ? _value.voidStreakAdvanceNotice
          : voidStreakAdvanceNotice // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$MatchGameStateImpl implements _MatchGameState {
  const _$MatchGameStateImpl(
      {required this.mode,
      required this.currentBoardIndex,
      required final List<MatchCard> currentBoard,
      required final List<int> selectedIndices,
      required final List<List<MatchCard>> historyLog,
      required this.currentScore,
      required this.voidPenaltyLevel,
      required this.remainingSeconds,
      required this.isGameOver,
      this.pendingFeedback,
      this.voidStreakAdvanceNotice = false})
      : _currentBoard = currentBoard,
        _selectedIndices = selectedIndices,
        _historyLog = historyLog;

  @override
  final MatchGameMode mode;
  @override
  final int currentBoardIndex;
  final List<MatchCard> _currentBoard;
  @override
  List<MatchCard> get currentBoard {
    if (_currentBoard is EqualUnmodifiableListView) return _currentBoard;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentBoard);
  }

  final List<int> _selectedIndices;
  @override
  List<int> get selectedIndices {
    if (_selectedIndices is EqualUnmodifiableListView) return _selectedIndices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedIndices);
  }

  final List<List<MatchCard>> _historyLog;
  @override
  List<List<MatchCard>> get historyLog {
    if (_historyLog is EqualUnmodifiableListView) return _historyLog;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_historyLog);
  }

  @override
  final int currentScore;
  @override
  final int voidPenaltyLevel;
  @override
  final int remainingSeconds;
  @override
  final bool isGameOver;

  /// One-shot penalty dialog for wrong match / wrong void.
  @override
  final MatchGameFeedback? pendingFeedback;

  /// True when five wrong voids in a row force-advance the board (show dialog).
  @override
  @JsonKey()
  final bool voidStreakAdvanceNotice;

  @override
  String toString() {
    return 'MatchGameState(mode: $mode, currentBoardIndex: $currentBoardIndex, currentBoard: $currentBoard, selectedIndices: $selectedIndices, historyLog: $historyLog, currentScore: $currentScore, voidPenaltyLevel: $voidPenaltyLevel, remainingSeconds: $remainingSeconds, isGameOver: $isGameOver, pendingFeedback: $pendingFeedback, voidStreakAdvanceNotice: $voidStreakAdvanceNotice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchGameStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.currentBoardIndex, currentBoardIndex) ||
                other.currentBoardIndex == currentBoardIndex) &&
            const DeepCollectionEquality()
                .equals(other._currentBoard, _currentBoard) &&
            const DeepCollectionEquality()
                .equals(other._selectedIndices, _selectedIndices) &&
            const DeepCollectionEquality()
                .equals(other._historyLog, _historyLog) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.voidPenaltyLevel, voidPenaltyLevel) ||
                other.voidPenaltyLevel == voidPenaltyLevel) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.pendingFeedback, pendingFeedback) ||
                other.pendingFeedback == pendingFeedback) &&
            (identical(
                    other.voidStreakAdvanceNotice, voidStreakAdvanceNotice) ||
                other.voidStreakAdvanceNotice == voidStreakAdvanceNotice));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      currentBoardIndex,
      const DeepCollectionEquality().hash(_currentBoard),
      const DeepCollectionEquality().hash(_selectedIndices),
      const DeepCollectionEquality().hash(_historyLog),
      currentScore,
      voidPenaltyLevel,
      remainingSeconds,
      isGameOver,
      pendingFeedback,
      voidStreakAdvanceNotice);

  /// Create a copy of MatchGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchGameStateImplCopyWith<_$MatchGameStateImpl> get copyWith =>
      __$$MatchGameStateImplCopyWithImpl<_$MatchGameStateImpl>(
          this, _$identity);
}

abstract class _MatchGameState implements MatchGameState {
  const factory _MatchGameState(
      {required final MatchGameMode mode,
      required final int currentBoardIndex,
      required final List<MatchCard> currentBoard,
      required final List<int> selectedIndices,
      required final List<List<MatchCard>> historyLog,
      required final int currentScore,
      required final int voidPenaltyLevel,
      required final int remainingSeconds,
      required final bool isGameOver,
      final MatchGameFeedback? pendingFeedback,
      final bool voidStreakAdvanceNotice}) = _$MatchGameStateImpl;

  @override
  MatchGameMode get mode;
  @override
  int get currentBoardIndex;
  @override
  List<MatchCard> get currentBoard;
  @override
  List<int> get selectedIndices;
  @override
  List<List<MatchCard>> get historyLog;
  @override
  int get currentScore;
  @override
  int get voidPenaltyLevel;
  @override
  int get remainingSeconds;
  @override
  bool get isGameOver;

  /// One-shot penalty dialog for wrong match / wrong void.
  @override
  MatchGameFeedback? get pendingFeedback;

  /// True when five wrong voids in a row force-advance the board (show dialog).
  @override
  bool get voidStreakAdvanceNotice;

  /// Create a copy of MatchGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchGameStateImplCopyWith<_$MatchGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
