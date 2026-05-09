// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matrix_poker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MatrixPokerState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatrixPokerStateCopyWith<$Res> {
  factory $MatrixPokerStateCopyWith(
          MatrixPokerState value, $Res Function(MatrixPokerState) then) =
      _$MatrixPokerStateCopyWithImpl<$Res, MatrixPokerState>;
}

/// @nodoc
class _$MatrixPokerStateCopyWithImpl<$Res, $Val extends MatrixPokerState>
    implements $MatrixPokerStateCopyWith<$Res> {
  _$MatrixPokerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'MatrixPokerState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements MatrixPokerState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$BoardFillingImplCopyWith<$Res> {
  factory _$$BoardFillingImplCopyWith(
          _$BoardFillingImpl value, $Res Function(_$BoardFillingImpl) then) =
      __$$BoardFillingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {MatrixGridModel grid,
      int fillRound,
      int dealerValue,
      int remainingSeconds,
      int totalRounds});
}

/// @nodoc
class __$$BoardFillingImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$BoardFillingImpl>
    implements _$$BoardFillingImplCopyWith<$Res> {
  __$$BoardFillingImplCopyWithImpl(
      _$BoardFillingImpl _value, $Res Function(_$BoardFillingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grid = null,
    Object? fillRound = null,
    Object? dealerValue = null,
    Object? remainingSeconds = null,
    Object? totalRounds = null,
  }) {
    return _then(_$BoardFillingImpl(
      grid: null == grid
          ? _value.grid
          : grid // ignore: cast_nullable_to_non_nullable
              as MatrixGridModel,
      fillRound: null == fillRound
          ? _value.fillRound
          : fillRound // ignore: cast_nullable_to_non_nullable
              as int,
      dealerValue: null == dealerValue
          ? _value.dealerValue
          : dealerValue // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      totalRounds: null == totalRounds
          ? _value.totalRounds
          : totalRounds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$BoardFillingImpl implements _BoardFilling {
  const _$BoardFillingImpl(
      {required this.grid,
      required this.fillRound,
      required this.dealerValue,
      required this.remainingSeconds,
      this.totalRounds = 25});

  @override
  final MatrixGridModel grid;
  @override
  final int fillRound;
  @override
  final int dealerValue;
  @override
  final int remainingSeconds;
  @override
  @JsonKey()
  final int totalRounds;

  @override
  String toString() {
    return 'MatrixPokerState.boardFilling(grid: $grid, fillRound: $fillRound, dealerValue: $dealerValue, remainingSeconds: $remainingSeconds, totalRounds: $totalRounds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BoardFillingImpl &&
            (identical(other.grid, grid) || other.grid == grid) &&
            (identical(other.fillRound, fillRound) ||
                other.fillRound == fillRound) &&
            (identical(other.dealerValue, dealerValue) ||
                other.dealerValue == dealerValue) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            (identical(other.totalRounds, totalRounds) ||
                other.totalRounds == totalRounds));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, grid, fillRound, dealerValue, remainingSeconds, totalRounds);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BoardFillingImplCopyWith<_$BoardFillingImpl> get copyWith =>
      __$$BoardFillingImplCopyWithImpl<_$BoardFillingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return boardFilling(
        grid, fillRound, dealerValue, remainingSeconds, totalRounds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return boardFilling?.call(
        grid, fillRound, dealerValue, remainingSeconds, totalRounds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (boardFilling != null) {
      return boardFilling(
          grid, fillRound, dealerValue, remainingSeconds, totalRounds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return boardFilling(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return boardFilling?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (boardFilling != null) {
      return boardFilling(this);
    }
    return orElse();
  }
}

abstract class _BoardFilling implements MatrixPokerState {
  const factory _BoardFilling(
      {required final MatrixGridModel grid,
      required final int fillRound,
      required final int dealerValue,
      required final int remainingSeconds,
      final int totalRounds}) = _$BoardFillingImpl;

  MatrixGridModel get grid;
  int get fillRound;
  int get dealerValue;
  int get remainingSeconds;
  int get totalRounds;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BoardFillingImplCopyWith<_$BoardFillingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DraftingImplCopyWith<$Res> {
  factory _$$DraftingImplCopyWith(
          _$DraftingImpl value, $Res Function(_$DraftingImpl) then) =
      __$$DraftingImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {MatrixGridModel grid, List<Combo> draftedCombos, int remainingSeconds});
}

/// @nodoc
class __$$DraftingImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$DraftingImpl>
    implements _$$DraftingImplCopyWith<$Res> {
  __$$DraftingImplCopyWithImpl(
      _$DraftingImpl _value, $Res Function(_$DraftingImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? grid = null,
    Object? draftedCombos = null,
    Object? remainingSeconds = null,
  }) {
    return _then(_$DraftingImpl(
      grid: null == grid
          ? _value.grid
          : grid // ignore: cast_nullable_to_non_nullable
              as MatrixGridModel,
      draftedCombos: null == draftedCombos
          ? _value._draftedCombos
          : draftedCombos // ignore: cast_nullable_to_non_nullable
              as List<Combo>,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DraftingImpl implements _Drafting {
  const _$DraftingImpl(
      {required this.grid,
      required final List<Combo> draftedCombos,
      required this.remainingSeconds})
      : _draftedCombos = draftedCombos;

  @override
  final MatrixGridModel grid;
  final List<Combo> _draftedCombos;
  @override
  List<Combo> get draftedCombos {
    if (_draftedCombos is EqualUnmodifiableListView) return _draftedCombos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_draftedCombos);
  }

  @override
  final int remainingSeconds;

  @override
  String toString() {
    return 'MatrixPokerState.drafting(grid: $grid, draftedCombos: $draftedCombos, remainingSeconds: $remainingSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftingImpl &&
            (identical(other.grid, grid) || other.grid == grid) &&
            const DeepCollectionEquality()
                .equals(other._draftedCombos, _draftedCombos) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, grid,
      const DeepCollectionEquality().hash(_draftedCombos), remainingSeconds);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftingImplCopyWith<_$DraftingImpl> get copyWith =>
      __$$DraftingImplCopyWithImpl<_$DraftingImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return drafting(grid, draftedCombos, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return drafting?.call(grid, draftedCombos, remainingSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (drafting != null) {
      return drafting(grid, draftedCombos, remainingSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return drafting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return drafting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (drafting != null) {
      return drafting(this);
    }
    return orElse();
  }
}

abstract class _Drafting implements MatrixPokerState {
  const factory _Drafting(
      {required final MatrixGridModel grid,
      required final List<Combo> draftedCombos,
      required final int remainingSeconds}) = _$DraftingImpl;

  MatrixGridModel get grid;
  List<Combo> get draftedCombos;
  int get remainingSeconds;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftingImplCopyWith<_$DraftingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WaitingForOpponentImplCopyWith<$Res> {
  factory _$$WaitingForOpponentImplCopyWith(_$WaitingForOpponentImpl value,
          $Res Function(_$WaitingForOpponentImpl) then) =
      __$$WaitingForOpponentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WaitingForOpponentImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$WaitingForOpponentImpl>
    implements _$$WaitingForOpponentImplCopyWith<$Res> {
  __$$WaitingForOpponentImplCopyWithImpl(_$WaitingForOpponentImpl _value,
      $Res Function(_$WaitingForOpponentImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$WaitingForOpponentImpl implements _WaitingForOpponent {
  const _$WaitingForOpponentImpl();

  @override
  String toString() {
    return 'MatrixPokerState.waitingForOpponent()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WaitingForOpponentImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return waitingForOpponent();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return waitingForOpponent?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (waitingForOpponent != null) {
      return waitingForOpponent();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return waitingForOpponent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return waitingForOpponent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (waitingForOpponent != null) {
      return waitingForOpponent(this);
    }
    return orElse();
  }
}

abstract class _WaitingForOpponent implements MatrixPokerState {
  const factory _WaitingForOpponent() = _$WaitingForOpponentImpl;
}

/// @nodoc
abstract class _$$DuelTurnImplCopyWith<$Res> {
  factory _$$DuelTurnImplCopyWith(
          _$DuelTurnImpl value, $Res Function(_$DuelTurnImpl) then) =
      __$$DuelTurnImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int round,
      int p1Score,
      int p2Score,
      int remainingSeconds,
      List<Combo> p1RemainingCombos});
}

/// @nodoc
class __$$DuelTurnImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$DuelTurnImpl>
    implements _$$DuelTurnImplCopyWith<$Res> {
  __$$DuelTurnImplCopyWithImpl(
      _$DuelTurnImpl _value, $Res Function(_$DuelTurnImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? round = null,
    Object? p1Score = null,
    Object? p2Score = null,
    Object? remainingSeconds = null,
    Object? p1RemainingCombos = null,
  }) {
    return _then(_$DuelTurnImpl(
      round: null == round
          ? _value.round
          : round // ignore: cast_nullable_to_non_nullable
              as int,
      p1Score: null == p1Score
          ? _value.p1Score
          : p1Score // ignore: cast_nullable_to_non_nullable
              as int,
      p2Score: null == p2Score
          ? _value.p2Score
          : p2Score // ignore: cast_nullable_to_non_nullable
              as int,
      remainingSeconds: null == remainingSeconds
          ? _value.remainingSeconds
          : remainingSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      p1RemainingCombos: null == p1RemainingCombos
          ? _value._p1RemainingCombos
          : p1RemainingCombos // ignore: cast_nullable_to_non_nullable
              as List<Combo>,
    ));
  }
}

/// @nodoc

class _$DuelTurnImpl implements _DuelTurn {
  const _$DuelTurnImpl(
      {required this.round,
      required this.p1Score,
      required this.p2Score,
      required this.remainingSeconds,
      required final List<Combo> p1RemainingCombos})
      : _p1RemainingCombos = p1RemainingCombos;

  @override
  final int round;
  @override
  final int p1Score;
  @override
  final int p2Score;
  @override
  final int remainingSeconds;

  /// Snapshot of P1’s twelve combos for UI / AI parity (slot **index** is still
  /// implied by list position `0..11`; consumed slots remain visible via Cubit).
  final List<Combo> _p1RemainingCombos;

  /// Snapshot of P1’s twelve combos for UI / AI parity (slot **index** is still
  /// implied by list position `0..11`; consumed slots remain visible via Cubit).
  @override
  List<Combo> get p1RemainingCombos {
    if (_p1RemainingCombos is EqualUnmodifiableListView)
      return _p1RemainingCombos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p1RemainingCombos);
  }

  @override
  String toString() {
    return 'MatrixPokerState.duelTurn(round: $round, p1Score: $p1Score, p2Score: $p2Score, remainingSeconds: $remainingSeconds, p1RemainingCombos: $p1RemainingCombos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DuelTurnImpl &&
            (identical(other.round, round) || other.round == round) &&
            (identical(other.p1Score, p1Score) || other.p1Score == p1Score) &&
            (identical(other.p2Score, p2Score) || other.p2Score == p2Score) &&
            (identical(other.remainingSeconds, remainingSeconds) ||
                other.remainingSeconds == remainingSeconds) &&
            const DeepCollectionEquality()
                .equals(other._p1RemainingCombos, _p1RemainingCombos));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      round,
      p1Score,
      p2Score,
      remainingSeconds,
      const DeepCollectionEquality().hash(_p1RemainingCombos));

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DuelTurnImplCopyWith<_$DuelTurnImpl> get copyWith =>
      __$$DuelTurnImplCopyWithImpl<_$DuelTurnImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return duelTurn(
        round, p1Score, p2Score, remainingSeconds, p1RemainingCombos);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return duelTurn?.call(
        round, p1Score, p2Score, remainingSeconds, p1RemainingCombos);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (duelTurn != null) {
      return duelTurn(
          round, p1Score, p2Score, remainingSeconds, p1RemainingCombos);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return duelTurn(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return duelTurn?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (duelTurn != null) {
      return duelTurn(this);
    }
    return orElse();
  }
}

abstract class _DuelTurn implements MatrixPokerState {
  const factory _DuelTurn(
      {required final int round,
      required final int p1Score,
      required final int p2Score,
      required final int remainingSeconds,
      required final List<Combo> p1RemainingCombos}) = _$DuelTurnImpl;

  int get round;
  int get p1Score;
  int get p2Score;
  int get remainingSeconds;

  /// Snapshot of P1’s twelve combos for UI / AI parity (slot **index** is still
  /// implied by list position `0..11`; consumed slots remain visible via Cubit).
  List<Combo> get p1RemainingCombos;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DuelTurnImplCopyWith<_$DuelTurnImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RoundResolvedImplCopyWith<$Res> {
  factory _$$RoundResolvedImplCopyWith(
          _$RoundResolvedImpl value, $Res Function(_$RoundResolvedImpl) then) =
      __$$RoundResolvedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {Combo p1Revealed,
      Combo p2Revealed,
      String resultMessage,
      bool isGameOver});
}

/// @nodoc
class __$$RoundResolvedImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$RoundResolvedImpl>
    implements _$$RoundResolvedImplCopyWith<$Res> {
  __$$RoundResolvedImplCopyWithImpl(
      _$RoundResolvedImpl _value, $Res Function(_$RoundResolvedImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? p1Revealed = null,
    Object? p2Revealed = null,
    Object? resultMessage = null,
    Object? isGameOver = null,
  }) {
    return _then(_$RoundResolvedImpl(
      p1Revealed: null == p1Revealed
          ? _value.p1Revealed
          : p1Revealed // ignore: cast_nullable_to_non_nullable
              as Combo,
      p2Revealed: null == p2Revealed
          ? _value.p2Revealed
          : p2Revealed // ignore: cast_nullable_to_non_nullable
              as Combo,
      resultMessage: null == resultMessage
          ? _value.resultMessage
          : resultMessage // ignore: cast_nullable_to_non_nullable
              as String,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RoundResolvedImpl implements _RoundResolved {
  const _$RoundResolvedImpl(
      {required this.p1Revealed,
      required this.p2Revealed,
      required this.resultMessage,
      required this.isGameOver});

  @override
  final Combo p1Revealed;
  @override
  final Combo p2Revealed;
  @override
  final String resultMessage;
  @override
  final bool isGameOver;

  @override
  String toString() {
    return 'MatrixPokerState.roundResolved(p1Revealed: $p1Revealed, p2Revealed: $p2Revealed, resultMessage: $resultMessage, isGameOver: $isGameOver)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoundResolvedImpl &&
            (identical(other.p1Revealed, p1Revealed) ||
                other.p1Revealed == p1Revealed) &&
            (identical(other.p2Revealed, p2Revealed) ||
                other.p2Revealed == p2Revealed) &&
            (identical(other.resultMessage, resultMessage) ||
                other.resultMessage == resultMessage) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, p1Revealed, p2Revealed, resultMessage, isGameOver);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RoundResolvedImplCopyWith<_$RoundResolvedImpl> get copyWith =>
      __$$RoundResolvedImplCopyWithImpl<_$RoundResolvedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return roundResolved(p1Revealed, p2Revealed, resultMessage, isGameOver);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return roundResolved?.call(
        p1Revealed, p2Revealed, resultMessage, isGameOver);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (roundResolved != null) {
      return roundResolved(p1Revealed, p2Revealed, resultMessage, isGameOver);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return roundResolved(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return roundResolved?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (roundResolved != null) {
      return roundResolved(this);
    }
    return orElse();
  }
}

abstract class _RoundResolved implements MatrixPokerState {
  const factory _RoundResolved(
      {required final Combo p1Revealed,
      required final Combo p2Revealed,
      required final String resultMessage,
      required final bool isGameOver}) = _$RoundResolvedImpl;

  Combo get p1Revealed;
  Combo get p2Revealed;
  String get resultMessage;
  bool get isGameOver;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RoundResolvedImplCopyWith<_$RoundResolvedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$GameOverImplCopyWith<$Res> {
  factory _$$GameOverImplCopyWith(
          _$GameOverImpl value, $Res Function(_$GameOverImpl) then) =
      __$$GameOverImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int finalP1Score, int finalP2Score, String winner});
}

/// @nodoc
class __$$GameOverImplCopyWithImpl<$Res>
    extends _$MatrixPokerStateCopyWithImpl<$Res, _$GameOverImpl>
    implements _$$GameOverImplCopyWith<$Res> {
  __$$GameOverImplCopyWithImpl(
      _$GameOverImpl _value, $Res Function(_$GameOverImpl) _then)
      : super(_value, _then);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? finalP1Score = null,
    Object? finalP2Score = null,
    Object? winner = null,
  }) {
    return _then(_$GameOverImpl(
      finalP1Score: null == finalP1Score
          ? _value.finalP1Score
          : finalP1Score // ignore: cast_nullable_to_non_nullable
              as int,
      finalP2Score: null == finalP2Score
          ? _value.finalP2Score
          : finalP2Score // ignore: cast_nullable_to_non_nullable
              as int,
      winner: null == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GameOverImpl implements _GameOver {
  const _$GameOverImpl(
      {required this.finalP1Score,
      required this.finalP2Score,
      required this.winner});

  @override
  final int finalP1Score;
  @override
  final int finalP2Score;
  @override
  final String winner;

  @override
  String toString() {
    return 'MatrixPokerState.gameOver(finalP1Score: $finalP1Score, finalP2Score: $finalP2Score, winner: $winner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GameOverImpl &&
            (identical(other.finalP1Score, finalP1Score) ||
                other.finalP1Score == finalP1Score) &&
            (identical(other.finalP2Score, finalP2Score) ||
                other.finalP2Score == finalP2Score) &&
            (identical(other.winner, winner) || other.winner == winner));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, finalP1Score, finalP2Score, winner);

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GameOverImplCopyWith<_$GameOverImpl> get copyWith =>
      __$$GameOverImplCopyWithImpl<_$GameOverImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(MatrixGridModel grid, int fillRound,
            int dealerValue, int remainingSeconds, int totalRounds)
        boardFilling,
    required TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)
        drafting,
    required TResult Function() waitingForOpponent,
    required TResult Function(int round, int p1Score, int p2Score,
            int remainingSeconds, List<Combo> p1RemainingCombos)
        duelTurn,
    required TResult Function(Combo p1Revealed, Combo p2Revealed,
            String resultMessage, bool isGameOver)
        roundResolved,
    required TResult Function(int finalP1Score, int finalP2Score, String winner)
        gameOver,
  }) {
    return gameOver(finalP1Score, finalP2Score, winner);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult? Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult? Function()? waitingForOpponent,
    TResult? Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult? Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult? Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
  }) {
    return gameOver?.call(finalP1Score, finalP2Score, winner);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(MatrixGridModel grid, int fillRound, int dealerValue,
            int remainingSeconds, int totalRounds)?
        boardFilling,
    TResult Function(MatrixGridModel grid, List<Combo> draftedCombos,
            int remainingSeconds)?
        drafting,
    TResult Function()? waitingForOpponent,
    TResult Function(int round, int p1Score, int p2Score, int remainingSeconds,
            List<Combo> p1RemainingCombos)?
        duelTurn,
    TResult Function(Combo p1Revealed, Combo p2Revealed, String resultMessage,
            bool isGameOver)?
        roundResolved,
    TResult Function(int finalP1Score, int finalP2Score, String winner)?
        gameOver,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(finalP1Score, finalP2Score, winner);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_BoardFilling value) boardFilling,
    required TResult Function(_Drafting value) drafting,
    required TResult Function(_WaitingForOpponent value) waitingForOpponent,
    required TResult Function(_DuelTurn value) duelTurn,
    required TResult Function(_RoundResolved value) roundResolved,
    required TResult Function(_GameOver value) gameOver,
  }) {
    return gameOver(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_BoardFilling value)? boardFilling,
    TResult? Function(_Drafting value)? drafting,
    TResult? Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult? Function(_DuelTurn value)? duelTurn,
    TResult? Function(_RoundResolved value)? roundResolved,
    TResult? Function(_GameOver value)? gameOver,
  }) {
    return gameOver?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_BoardFilling value)? boardFilling,
    TResult Function(_Drafting value)? drafting,
    TResult Function(_WaitingForOpponent value)? waitingForOpponent,
    TResult Function(_DuelTurn value)? duelTurn,
    TResult Function(_RoundResolved value)? roundResolved,
    TResult Function(_GameOver value)? gameOver,
    required TResult orElse(),
  }) {
    if (gameOver != null) {
      return gameOver(this);
    }
    return orElse();
  }
}

abstract class _GameOver implements MatrixPokerState {
  const factory _GameOver(
      {required final int finalP1Score,
      required final int finalP2Score,
      required final String winner}) = _$GameOverImpl;

  int get finalP1Score;
  int get finalP2Score;
  String get winner;

  /// Create a copy of MatrixPokerState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GameOverImplCopyWith<_$GameOverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
