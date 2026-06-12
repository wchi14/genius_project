// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'apex_game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ApexGameState {
  ApexGameMode get mode => throw _privateConstructorUsedError;
  int get currentLevel => throw _privateConstructorUsedError;
  List<EquationTile> get availableTiles => throw _privateConstructorUsedError;
  int get targetNumber => throw _privateConstructorUsedError;
  List<EquationTile> get selectedTiles => throw _privateConstructorUsedError;
  int get currentScore => throw _privateConstructorUsedError;
  int get remainingSeconds => throw _privateConstructorUsedError;
  int get currentWrongTries => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;

  /// One-shot flag for wrong-answer visual feedback (clear via cubit).
  bool get wrongAnswerFlash => throw _privateConstructorUsedError;

  /// Create a copy of ApexGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ApexGameStateCopyWith<ApexGameState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApexGameStateCopyWith<$Res> {
  factory $ApexGameStateCopyWith(
          ApexGameState value, $Res Function(ApexGameState) then) =
      _$ApexGameStateCopyWithImpl<$Res, ApexGameState>;
  @useResult
  $Res call(
      {ApexGameMode mode,
      int currentLevel,
      List<EquationTile> availableTiles,
      int targetNumber,
      List<EquationTile> selectedTiles,
      int currentScore,
      int remainingSeconds,
      int currentWrongTries,
      bool isGameOver,
      bool wrongAnswerFlash});
}

/// @nodoc
class _$ApexGameStateCopyWithImpl<$Res, $Val extends ApexGameState>
    implements $ApexGameStateCopyWith<$Res> {
  _$ApexGameStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ApexGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? currentLevel = null,
    Object? availableTiles = null,
    Object? targetNumber = null,
    Object? selectedTiles = null,
    Object? currentScore = null,
    Object? remainingSeconds = null,
    Object? currentWrongTries = null,
    Object? isGameOver = null,
    Object? wrongAnswerFlash = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ApexGameMode,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      availableTiles: null == availableTiles
          ? _value.availableTiles
          : availableTiles // ignore: cast_nullable_to_non_nullable
              as List<EquationTile>,
      targetNumber: null == targetNumber
          ? _value.targetNumber
          : targetNumber // ignore: cast_nullable_to_non_nullable
              as int,
      selectedTiles: null == selectedTiles
          ? _value.selectedTiles
          : selectedTiles // ignore: cast_nullable_to_non_nullable
              as List<EquationTile>,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentWrongTries: null == currentWrongTries
          ? _value.currentWrongTries
          : currentWrongTries // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      wrongAnswerFlash: null == wrongAnswerFlash
          ? _value.wrongAnswerFlash
          : wrongAnswerFlash // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApexGameStateImplCopyWith<$Res>
    implements $ApexGameStateCopyWith<$Res> {
  factory _$$ApexGameStateImplCopyWith(
          _$ApexGameStateImpl value, $Res Function(_$ApexGameStateImpl) then) =
      __$$ApexGameStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ApexGameMode mode,
      int currentLevel,
      List<EquationTile> availableTiles,
      int targetNumber,
      List<EquationTile> selectedTiles,
      int currentScore,
      int remainingSeconds,
      int currentWrongTries,
      bool isGameOver,
      bool wrongAnswerFlash});
}

/// @nodoc
class __$$ApexGameStateImplCopyWithImpl<$Res>
    extends _$ApexGameStateCopyWithImpl<$Res, _$ApexGameStateImpl>
    implements _$$ApexGameStateImplCopyWith<$Res> {
  __$$ApexGameStateImplCopyWithImpl(
      _$ApexGameStateImpl _value, $Res Function(_$ApexGameStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ApexGameState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? currentLevel = null,
    Object? availableTiles = null,
    Object? targetNumber = null,
    Object? selectedTiles = null,
    Object? currentScore = null,
    Object? remainingSeconds = null,
    Object? currentWrongTries = null,
    Object? isGameOver = null,
    Object? wrongAnswerFlash = null,
  }) {
    return _then(_$ApexGameStateImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as ApexGameMode,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      availableTiles: null == availableTiles
          ? _value._availableTiles
          : availableTiles // ignore: cast_nullable_to_non_nullable
              as List<EquationTile>,
      targetNumber: null == targetNumber
          ? _value.targetNumber
          : targetNumber // ignore: cast_nullable_to_non_nullable
              as int,
      selectedTiles: null == selectedTiles
          ? _value._selectedTiles
          : selectedTiles // ignore: cast_nullable_to_non_nullable
              as List<EquationTile>,
      currentScore: null == currentScore
          ? _value.currentScore
          : currentScore // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      currentWrongTries: null == currentWrongTries
          ? _value.currentWrongTries
          : currentWrongTries // ignore: cast_nullable_to_non_nullable
              as int,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      wrongAnswerFlash: null == wrongAnswerFlash
          ? _value.wrongAnswerFlash
          : wrongAnswerFlash // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ApexGameStateImpl implements _ApexGameState {
  const _$ApexGameStateImpl(
      {required this.mode,
      required this.currentLevel,
      required final List<EquationTile> availableTiles,
      required this.targetNumber,
      required final List<EquationTile> selectedTiles,
      required this.currentScore,
      required this.remainingSeconds,
      required this.currentWrongTries,
      required this.isGameOver,
      this.wrongAnswerFlash = false})
      : _availableTiles = availableTiles,
        _selectedTiles = selectedTiles;

  @override
  final ApexGameMode mode;
  @override
  final int currentLevel;
  final List<EquationTile> _availableTiles;
  @override
  List<EquationTile> get availableTiles {
    if (_availableTiles is EqualUnmodifiableListView) return _availableTiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableTiles);
  }

  @override
  final int targetNumber;
  final List<EquationTile> _selectedTiles;
  @override
  List<EquationTile> get selectedTiles {
    if (_selectedTiles is EqualUnmodifiableListView) return _selectedTiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTiles);
  }

  @override
  final int currentScore;
  @override
  final int remainingSeconds;
  @override
  final int currentWrongTries;
  @override
  final bool isGameOver;

  /// One-shot flag for wrong-answer visual feedback (clear via cubit).
  @override
  @JsonKey()
  final bool wrongAnswerFlash;

  @override
  String toString() {
    return 'ApexGameState(mode: $mode, currentLevel: $currentLevel, availableTiles: $availableTiles, targetNumber: $targetNumber, selectedTiles: $selectedTiles, currentScore: $currentScore, remainingSeconds: $remainingSeconds, currentWrongTries: $currentWrongTries, isGameOver: $isGameOver, wrongAnswerFlash: $wrongAnswerFlash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApexGameStateImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            const DeepCollectionEquality()
                .equals(other._availableTiles, _availableTiles) &&
            (identical(other.targetNumber, targetNumber) ||
                other.targetNumber == targetNumber) &&
            const DeepCollectionEquality()
                .equals(other._selectedTiles, _selectedTiles) &&
            (identical(other.currentScore, currentScore) ||
                other.currentScore == currentScore) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.currentWrongTries, currentWrongTries) ||
                other.currentWrongTries == currentWrongTries) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.wrongAnswerFlash, wrongAnswerFlash) ||
                other.wrongAnswerFlash == wrongAnswerFlash));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      mode,
      currentLevel,
      const DeepCollectionEquality().hash(_availableTiles),
      targetNumber,
      const DeepCollectionEquality().hash(_selectedTiles),
      currentScore,
      remainingSeconds,
      currentWrongTries,
      isGameOver,
      wrongAnswerFlash);

  /// Create a copy of ApexGameState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApexGameStateImplCopyWith<_$ApexGameStateImpl> get copyWith =>
      __$$ApexGameStateImplCopyWithImpl<_$ApexGameStateImpl>(this, _$identity);
}

abstract class _ApexGameState implements ApexGameState {
  const factory _ApexGameState(
      {required final ApexGameMode mode,
      required final int currentLevel,
      required final List<EquationTile> availableTiles,
      required final int targetNumber,
      required final List<EquationTile> selectedTiles,
      required final int currentScore,
      required final int remainingSeconds,
      required final int currentWrongTries,
      required final bool isGameOver,
      final bool wrongAnswerFlash}) = _$ApexGameStateImpl;

  @override
  ApexGameMode get mode;
  @override
  int get currentLevel;
  @override
  List<EquationTile> get availableTiles;
  @override
  int get targetNumber;
  @override
  List<EquationTile> get selectedTiles;
  @override
  int get currentScore;
  @override
  int get remainingSeconds;
  @override
  int get currentWrongTries;
  @override
  bool get isGameOver;

  /// One-shot flag for wrong-answer visual feedback (clear via cubit).
  @override
  bool get wrongAnswerFlash;

  /// Create a copy of ApexGameState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApexGameStateImplCopyWith<_$ApexGameStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
