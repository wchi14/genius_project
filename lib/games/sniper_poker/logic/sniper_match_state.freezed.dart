// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sniper_match_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SniperRiverDeclaration {
  SniperModeSelection get mode => throw _privateConstructorUsedError;
  HandRank get targetRank => throw _privateConstructorUsedError;
  int? get targetValue => throw _privateConstructorUsedError;

  /// Create a copy of SniperRiverDeclaration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SniperRiverDeclarationCopyWith<SniperRiverDeclaration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SniperRiverDeclarationCopyWith<$Res> {
  factory $SniperRiverDeclarationCopyWith(SniperRiverDeclaration value,
          $Res Function(SniperRiverDeclaration) then) =
      _$SniperRiverDeclarationCopyWithImpl<$Res, SniperRiverDeclaration>;
  @useResult
  $Res call({SniperModeSelection mode, HandRank targetRank, int? targetValue});
}

/// @nodoc
class _$SniperRiverDeclarationCopyWithImpl<$Res,
        $Val extends SniperRiverDeclaration>
    implements $SniperRiverDeclarationCopyWith<$Res> {
  _$SniperRiverDeclarationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SniperRiverDeclaration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? targetRank = null,
    Object? targetValue = freezed,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SniperModeSelection,
      targetRank: null == targetRank
          ? _value.targetRank
          : targetRank // ignore: cast_nullable_to_non_nullable
              as HandRank,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SniperRiverDeclarationImplCopyWith<$Res>
    implements $SniperRiverDeclarationCopyWith<$Res> {
  factory _$$SniperRiverDeclarationImplCopyWith(
          _$SniperRiverDeclarationImpl value,
          $Res Function(_$SniperRiverDeclarationImpl) then) =
      __$$SniperRiverDeclarationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SniperModeSelection mode, HandRank targetRank, int? targetValue});
}

/// @nodoc
class __$$SniperRiverDeclarationImplCopyWithImpl<$Res>
    extends _$SniperRiverDeclarationCopyWithImpl<$Res,
        _$SniperRiverDeclarationImpl>
    implements _$$SniperRiverDeclarationImplCopyWith<$Res> {
  __$$SniperRiverDeclarationImplCopyWithImpl(
      _$SniperRiverDeclarationImpl _value,
      $Res Function(_$SniperRiverDeclarationImpl) _then)
      : super(_value, _then);

  /// Create a copy of SniperRiverDeclaration
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? targetRank = null,
    Object? targetValue = freezed,
  }) {
    return _then(_$SniperRiverDeclarationImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as SniperModeSelection,
      targetRank: null == targetRank
          ? _value.targetRank
          : targetRank // ignore: cast_nullable_to_non_nullable
              as HandRank,
      targetValue: freezed == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$SniperRiverDeclarationImpl implements _SniperRiverDeclaration {
  const _$SniperRiverDeclarationImpl(
      {required this.mode, required this.targetRank, this.targetValue});

  @override
  final SniperModeSelection mode;
  @override
  final HandRank targetRank;
  @override
  final int? targetValue;

  @override
  String toString() {
    return 'SniperRiverDeclaration(mode: $mode, targetRank: $targetRank, targetValue: $targetValue)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SniperRiverDeclarationImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.targetRank, targetRank) ||
                other.targetRank == targetRank) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mode, targetRank, targetValue);

  /// Create a copy of SniperRiverDeclaration
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SniperRiverDeclarationImplCopyWith<_$SniperRiverDeclarationImpl>
      get copyWith => __$$SniperRiverDeclarationImplCopyWithImpl<
          _$SniperRiverDeclarationImpl>(this, _$identity);
}

abstract class _SniperRiverDeclaration implements SniperRiverDeclaration {
  const factory _SniperRiverDeclaration(
      {required final SniperModeSelection mode,
      required final HandRank targetRank,
      final int? targetValue}) = _$SniperRiverDeclarationImpl;

  @override
  SniperModeSelection get mode;
  @override
  HandRank get targetRank;
  @override
  int? get targetValue;

  /// Create a copy of SniperRiverDeclaration
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SniperRiverDeclarationImplCopyWith<_$SniperRiverDeclarationImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SniperShowdownSnapshot {
  SniperPlayerId? get winner => throw _privateConstructorUsedError;
  ParsedHand get p1Hand => throw _privateConstructorUsedError;
  ParsedHand get p2Hand => throw _privateConstructorUsedError;
  bool get jackpotAwarded => throw _privateConstructorUsedError;
  int get potAwarded => throw _privateConstructorUsedError;
  bool get shotgunHedgeApplied => throw _privateConstructorUsedError;
  bool get endedByFold => throw _privateConstructorUsedError;
  SniperPlayerId? get foldedPlayer => throw _privateConstructorUsedError;
  int get p1ChipsEnd => throw _privateConstructorUsedError;
  int get p2ChipsEnd => throw _privateConstructorUsedError;
  int get p1ChipDelta => throw _privateConstructorUsedError;
  int get p2ChipDelta => throw _privateConstructorUsedError;
  String get p1SkillLine => throw _privateConstructorUsedError;
  String get p2SkillLine => throw _privateConstructorUsedError;
  String get p1TargetLine => throw _privateConstructorUsedError;
  String get p2TargetLine => throw _privateConstructorUsedError;

  /// Opponent's sniper successfully hit this seat's hand.
  bool get p1SnipedLabel => throw _privateConstructorUsedError;
  bool get p2SnipedLabel => throw _privateConstructorUsedError;

  /// Shotgun hit the winner's hand but this seat lost the pot.
  bool get p1ShotgunLabel => throw _privateConstructorUsedError;
  bool get p2ShotgunLabel => throw _privateConstructorUsedError;

  /// Create a copy of SniperShowdownSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SniperShowdownSnapshotCopyWith<SniperShowdownSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SniperShowdownSnapshotCopyWith<$Res> {
  factory $SniperShowdownSnapshotCopyWith(SniperShowdownSnapshot value,
          $Res Function(SniperShowdownSnapshot) then) =
      _$SniperShowdownSnapshotCopyWithImpl<$Res, SniperShowdownSnapshot>;
  @useResult
  $Res call(
      {SniperPlayerId? winner,
      ParsedHand p1Hand,
      ParsedHand p2Hand,
      bool jackpotAwarded,
      int potAwarded,
      bool shotgunHedgeApplied,
      bool endedByFold,
      SniperPlayerId? foldedPlayer,
      int p1ChipsEnd,
      int p2ChipsEnd,
      int p1ChipDelta,
      int p2ChipDelta,
      String p1SkillLine,
      String p2SkillLine,
      String p1TargetLine,
      String p2TargetLine,
      bool p1SnipedLabel,
      bool p2SnipedLabel,
      bool p1ShotgunLabel,
      bool p2ShotgunLabel});
}

/// @nodoc
class _$SniperShowdownSnapshotCopyWithImpl<$Res,
        $Val extends SniperShowdownSnapshot>
    implements $SniperShowdownSnapshotCopyWith<$Res> {
  _$SniperShowdownSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SniperShowdownSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = freezed,
    Object? p1Hand = null,
    Object? p2Hand = null,
    Object? jackpotAwarded = null,
    Object? potAwarded = null,
    Object? shotgunHedgeApplied = null,
    Object? endedByFold = null,
    Object? foldedPlayer = freezed,
    Object? p1ChipsEnd = null,
    Object? p2ChipsEnd = null,
    Object? p1ChipDelta = null,
    Object? p2ChipDelta = null,
    Object? p1SkillLine = null,
    Object? p2SkillLine = null,
    Object? p1TargetLine = null,
    Object? p2TargetLine = null,
    Object? p1SnipedLabel = null,
    Object? p2SnipedLabel = null,
    Object? p1ShotgunLabel = null,
    Object? p2ShotgunLabel = null,
  }) {
    return _then(_value.copyWith(
      winner: freezed == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1Hand: null == p1Hand
          ? _value.p1Hand
          : p1Hand // ignore: cast_nullable_to_non_nullable
              as ParsedHand,
      p2Hand: null == p2Hand
          ? _value.p2Hand
          : p2Hand // ignore: cast_nullable_to_non_nullable
              as ParsedHand,
      jackpotAwarded: null == jackpotAwarded
          ? _value.jackpotAwarded
          : jackpotAwarded // ignore: cast_nullable_to_non_nullable
              as bool,
      potAwarded: null == potAwarded
          ? _value.potAwarded
          : potAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      shotgunHedgeApplied: null == shotgunHedgeApplied
          ? _value.shotgunHedgeApplied
          : shotgunHedgeApplied // ignore: cast_nullable_to_non_nullable
              as bool,
      endedByFold: null == endedByFold
          ? _value.endedByFold
          : endedByFold // ignore: cast_nullable_to_non_nullable
              as bool,
      foldedPlayer: freezed == foldedPlayer
          ? _value.foldedPlayer
          : foldedPlayer // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1ChipsEnd: null == p1ChipsEnd
          ? _value.p1ChipsEnd
          : p1ChipsEnd // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipsEnd: null == p2ChipsEnd
          ? _value.p2ChipsEnd
          : p2ChipsEnd // ignore: cast_nullable_to_non_nullable
              as int,
      p1ChipDelta: null == p1ChipDelta
          ? _value.p1ChipDelta
          : p1ChipDelta // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipDelta: null == p2ChipDelta
          ? _value.p2ChipDelta
          : p2ChipDelta // ignore: cast_nullable_to_non_nullable
              as int,
      p1SkillLine: null == p1SkillLine
          ? _value.p1SkillLine
          : p1SkillLine // ignore: cast_nullable_to_non_nullable
              as String,
      p2SkillLine: null == p2SkillLine
          ? _value.p2SkillLine
          : p2SkillLine // ignore: cast_nullable_to_non_nullable
              as String,
      p1TargetLine: null == p1TargetLine
          ? _value.p1TargetLine
          : p1TargetLine // ignore: cast_nullable_to_non_nullable
              as String,
      p2TargetLine: null == p2TargetLine
          ? _value.p2TargetLine
          : p2TargetLine // ignore: cast_nullable_to_non_nullable
              as String,
      p1SnipedLabel: null == p1SnipedLabel
          ? _value.p1SnipedLabel
          : p1SnipedLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SnipedLabel: null == p2SnipedLabel
          ? _value.p2SnipedLabel
          : p2SnipedLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p1ShotgunLabel: null == p1ShotgunLabel
          ? _value.p1ShotgunLabel
          : p1ShotgunLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p2ShotgunLabel: null == p2ShotgunLabel
          ? _value.p2ShotgunLabel
          : p2ShotgunLabel // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SniperShowdownSnapshotImplCopyWith<$Res>
    implements $SniperShowdownSnapshotCopyWith<$Res> {
  factory _$$SniperShowdownSnapshotImplCopyWith(
          _$SniperShowdownSnapshotImpl value,
          $Res Function(_$SniperShowdownSnapshotImpl) then) =
      __$$SniperShowdownSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SniperPlayerId? winner,
      ParsedHand p1Hand,
      ParsedHand p2Hand,
      bool jackpotAwarded,
      int potAwarded,
      bool shotgunHedgeApplied,
      bool endedByFold,
      SniperPlayerId? foldedPlayer,
      int p1ChipsEnd,
      int p2ChipsEnd,
      int p1ChipDelta,
      int p2ChipDelta,
      String p1SkillLine,
      String p2SkillLine,
      String p1TargetLine,
      String p2TargetLine,
      bool p1SnipedLabel,
      bool p2SnipedLabel,
      bool p1ShotgunLabel,
      bool p2ShotgunLabel});
}

/// @nodoc
class __$$SniperShowdownSnapshotImplCopyWithImpl<$Res>
    extends _$SniperShowdownSnapshotCopyWithImpl<$Res,
        _$SniperShowdownSnapshotImpl>
    implements _$$SniperShowdownSnapshotImplCopyWith<$Res> {
  __$$SniperShowdownSnapshotImplCopyWithImpl(
      _$SniperShowdownSnapshotImpl _value,
      $Res Function(_$SniperShowdownSnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of SniperShowdownSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? winner = freezed,
    Object? p1Hand = null,
    Object? p2Hand = null,
    Object? jackpotAwarded = null,
    Object? potAwarded = null,
    Object? shotgunHedgeApplied = null,
    Object? endedByFold = null,
    Object? foldedPlayer = freezed,
    Object? p1ChipsEnd = null,
    Object? p2ChipsEnd = null,
    Object? p1ChipDelta = null,
    Object? p2ChipDelta = null,
    Object? p1SkillLine = null,
    Object? p2SkillLine = null,
    Object? p1TargetLine = null,
    Object? p2TargetLine = null,
    Object? p1SnipedLabel = null,
    Object? p2SnipedLabel = null,
    Object? p1ShotgunLabel = null,
    Object? p2ShotgunLabel = null,
  }) {
    return _then(_$SniperShowdownSnapshotImpl(
      winner: freezed == winner
          ? _value.winner
          : winner // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1Hand: null == p1Hand
          ? _value.p1Hand
          : p1Hand // ignore: cast_nullable_to_non_nullable
              as ParsedHand,
      p2Hand: null == p2Hand
          ? _value.p2Hand
          : p2Hand // ignore: cast_nullable_to_non_nullable
              as ParsedHand,
      jackpotAwarded: null == jackpotAwarded
          ? _value.jackpotAwarded
          : jackpotAwarded // ignore: cast_nullable_to_non_nullable
              as bool,
      potAwarded: null == potAwarded
          ? _value.potAwarded
          : potAwarded // ignore: cast_nullable_to_non_nullable
              as int,
      shotgunHedgeApplied: null == shotgunHedgeApplied
          ? _value.shotgunHedgeApplied
          : shotgunHedgeApplied // ignore: cast_nullable_to_non_nullable
              as bool,
      endedByFold: null == endedByFold
          ? _value.endedByFold
          : endedByFold // ignore: cast_nullable_to_non_nullable
              as bool,
      foldedPlayer: freezed == foldedPlayer
          ? _value.foldedPlayer
          : foldedPlayer // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1ChipsEnd: null == p1ChipsEnd
          ? _value.p1ChipsEnd
          : p1ChipsEnd // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipsEnd: null == p2ChipsEnd
          ? _value.p2ChipsEnd
          : p2ChipsEnd // ignore: cast_nullable_to_non_nullable
              as int,
      p1ChipDelta: null == p1ChipDelta
          ? _value.p1ChipDelta
          : p1ChipDelta // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipDelta: null == p2ChipDelta
          ? _value.p2ChipDelta
          : p2ChipDelta // ignore: cast_nullable_to_non_nullable
              as int,
      p1SkillLine: null == p1SkillLine
          ? _value.p1SkillLine
          : p1SkillLine // ignore: cast_nullable_to_non_nullable
              as String,
      p2SkillLine: null == p2SkillLine
          ? _value.p2SkillLine
          : p2SkillLine // ignore: cast_nullable_to_non_nullable
              as String,
      p1TargetLine: null == p1TargetLine
          ? _value.p1TargetLine
          : p1TargetLine // ignore: cast_nullable_to_non_nullable
              as String,
      p2TargetLine: null == p2TargetLine
          ? _value.p2TargetLine
          : p2TargetLine // ignore: cast_nullable_to_non_nullable
              as String,
      p1SnipedLabel: null == p1SnipedLabel
          ? _value.p1SnipedLabel
          : p1SnipedLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SnipedLabel: null == p2SnipedLabel
          ? _value.p2SnipedLabel
          : p2SnipedLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p1ShotgunLabel: null == p1ShotgunLabel
          ? _value.p1ShotgunLabel
          : p1ShotgunLabel // ignore: cast_nullable_to_non_nullable
              as bool,
      p2ShotgunLabel: null == p2ShotgunLabel
          ? _value.p2ShotgunLabel
          : p2ShotgunLabel // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SniperShowdownSnapshotImpl implements _SniperShowdownSnapshot {
  const _$SniperShowdownSnapshotImpl(
      {this.winner,
      required this.p1Hand,
      required this.p2Hand,
      required this.jackpotAwarded,
      required this.potAwarded,
      required this.shotgunHedgeApplied,
      required this.endedByFold,
      this.foldedPlayer,
      required this.p1ChipsEnd,
      required this.p2ChipsEnd,
      required this.p1ChipDelta,
      required this.p2ChipDelta,
      required this.p1SkillLine,
      required this.p2SkillLine,
      required this.p1TargetLine,
      required this.p2TargetLine,
      this.p1SnipedLabel = false,
      this.p2SnipedLabel = false,
      this.p1ShotgunLabel = false,
      this.p2ShotgunLabel = false});

  @override
  final SniperPlayerId? winner;
  @override
  final ParsedHand p1Hand;
  @override
  final ParsedHand p2Hand;
  @override
  final bool jackpotAwarded;
  @override
  final int potAwarded;
  @override
  final bool shotgunHedgeApplied;
  @override
  final bool endedByFold;
  @override
  final SniperPlayerId? foldedPlayer;
  @override
  final int p1ChipsEnd;
  @override
  final int p2ChipsEnd;
  @override
  final int p1ChipDelta;
  @override
  final int p2ChipDelta;
  @override
  final String p1SkillLine;
  @override
  final String p2SkillLine;
  @override
  final String p1TargetLine;
  @override
  final String p2TargetLine;

  /// Opponent's sniper successfully hit this seat's hand.
  @override
  @JsonKey()
  final bool p1SnipedLabel;
  @override
  @JsonKey()
  final bool p2SnipedLabel;

  /// Shotgun hit the winner's hand but this seat lost the pot.
  @override
  @JsonKey()
  final bool p1ShotgunLabel;
  @override
  @JsonKey()
  final bool p2ShotgunLabel;

  @override
  String toString() {
    return 'SniperShowdownSnapshot(winner: $winner, p1Hand: $p1Hand, p2Hand: $p2Hand, jackpotAwarded: $jackpotAwarded, potAwarded: $potAwarded, shotgunHedgeApplied: $shotgunHedgeApplied, endedByFold: $endedByFold, foldedPlayer: $foldedPlayer, p1ChipsEnd: $p1ChipsEnd, p2ChipsEnd: $p2ChipsEnd, p1ChipDelta: $p1ChipDelta, p2ChipDelta: $p2ChipDelta, p1SkillLine: $p1SkillLine, p2SkillLine: $p2SkillLine, p1TargetLine: $p1TargetLine, p2TargetLine: $p2TargetLine, p1SnipedLabel: $p1SnipedLabel, p2SnipedLabel: $p2SnipedLabel, p1ShotgunLabel: $p1ShotgunLabel, p2ShotgunLabel: $p2ShotgunLabel)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SniperShowdownSnapshotImpl &&
            (identical(other.winner, winner) || other.winner == winner) &&
            (identical(other.p1Hand, p1Hand) || other.p1Hand == p1Hand) &&
            (identical(other.p2Hand, p2Hand) || other.p2Hand == p2Hand) &&
            (identical(other.jackpotAwarded, jackpotAwarded) ||
                other.jackpotAwarded == jackpotAwarded) &&
            (identical(other.potAwarded, potAwarded) ||
                other.potAwarded == potAwarded) &&
            (identical(other.shotgunHedgeApplied, shotgunHedgeApplied) ||
                other.shotgunHedgeApplied == shotgunHedgeApplied) &&
            (identical(other.endedByFold, endedByFold) ||
                other.endedByFold == endedByFold) &&
            (identical(other.foldedPlayer, foldedPlayer) ||
                other.foldedPlayer == foldedPlayer) &&
            (identical(other.p1ChipsEnd, p1ChipsEnd) ||
                other.p1ChipsEnd == p1ChipsEnd) &&
            (identical(other.p2ChipsEnd, p2ChipsEnd) ||
                other.p2ChipsEnd == p2ChipsEnd) &&
            (identical(other.p1ChipDelta, p1ChipDelta) ||
                other.p1ChipDelta == p1ChipDelta) &&
            (identical(other.p2ChipDelta, p2ChipDelta) ||
                other.p2ChipDelta == p2ChipDelta) &&
            (identical(other.p1SkillLine, p1SkillLine) ||
                other.p1SkillLine == p1SkillLine) &&
            (identical(other.p2SkillLine, p2SkillLine) ||
                other.p2SkillLine == p2SkillLine) &&
            (identical(other.p1TargetLine, p1TargetLine) ||
                other.p1TargetLine == p1TargetLine) &&
            (identical(other.p2TargetLine, p2TargetLine) ||
                other.p2TargetLine == p2TargetLine) &&
            (identical(other.p1SnipedLabel, p1SnipedLabel) ||
                other.p1SnipedLabel == p1SnipedLabel) &&
            (identical(other.p2SnipedLabel, p2SnipedLabel) ||
                other.p2SnipedLabel == p2SnipedLabel) &&
            (identical(other.p1ShotgunLabel, p1ShotgunLabel) ||
                other.p1ShotgunLabel == p1ShotgunLabel) &&
            (identical(other.p2ShotgunLabel, p2ShotgunLabel) ||
                other.p2ShotgunLabel == p2ShotgunLabel));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        winner,
        p1Hand,
        p2Hand,
        jackpotAwarded,
        potAwarded,
        shotgunHedgeApplied,
        endedByFold,
        foldedPlayer,
        p1ChipsEnd,
        p2ChipsEnd,
        p1ChipDelta,
        p2ChipDelta,
        p1SkillLine,
        p2SkillLine,
        p1TargetLine,
        p2TargetLine,
        p1SnipedLabel,
        p2SnipedLabel,
        p1ShotgunLabel,
        p2ShotgunLabel
      ]);

  /// Create a copy of SniperShowdownSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SniperShowdownSnapshotImplCopyWith<_$SniperShowdownSnapshotImpl>
      get copyWith => __$$SniperShowdownSnapshotImplCopyWithImpl<
          _$SniperShowdownSnapshotImpl>(this, _$identity);
}

abstract class _SniperShowdownSnapshot implements SniperShowdownSnapshot {
  const factory _SniperShowdownSnapshot(
      {final SniperPlayerId? winner,
      required final ParsedHand p1Hand,
      required final ParsedHand p2Hand,
      required final bool jackpotAwarded,
      required final int potAwarded,
      required final bool shotgunHedgeApplied,
      required final bool endedByFold,
      final SniperPlayerId? foldedPlayer,
      required final int p1ChipsEnd,
      required final int p2ChipsEnd,
      required final int p1ChipDelta,
      required final int p2ChipDelta,
      required final String p1SkillLine,
      required final String p2SkillLine,
      required final String p1TargetLine,
      required final String p2TargetLine,
      final bool p1SnipedLabel,
      final bool p2SnipedLabel,
      final bool p1ShotgunLabel,
      final bool p2ShotgunLabel}) = _$SniperShowdownSnapshotImpl;

  @override
  SniperPlayerId? get winner;
  @override
  ParsedHand get p1Hand;
  @override
  ParsedHand get p2Hand;
  @override
  bool get jackpotAwarded;
  @override
  int get potAwarded;
  @override
  bool get shotgunHedgeApplied;
  @override
  bool get endedByFold;
  @override
  SniperPlayerId? get foldedPlayer;
  @override
  int get p1ChipsEnd;
  @override
  int get p2ChipsEnd;
  @override
  int get p1ChipDelta;
  @override
  int get p2ChipDelta;
  @override
  String get p1SkillLine;
  @override
  String get p2SkillLine;
  @override
  String get p1TargetLine;
  @override
  String get p2TargetLine;

  /// Opponent's sniper successfully hit this seat's hand.
  @override
  bool get p1SnipedLabel;
  @override
  bool get p2SnipedLabel;

  /// Shotgun hit the winner's hand but this seat lost the pot.
  @override
  bool get p1ShotgunLabel;
  @override
  bool get p2ShotgunLabel;

  /// Create a copy of SniperShowdownSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SniperShowdownSnapshotImplCopyWith<_$SniperShowdownSnapshotImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$SniperMatchState {
  int get p1Chips => throw _privateConstructorUsedError;
  int get p2Chips => throw _privateConstructorUsedError;
  int get p1RoundInvestment => throw _privateConstructorUsedError;
  int get p2RoundInvestment => throw _privateConstructorUsedError;
  int get currentAnte => throw _privateConstructorUsedError;
  int get currentRoundCount => throw _privateConstructorUsedError;
  int get currentPot => throw _privateConstructorUsedError;
  int get carryOverPot => throw _privateConstructorUsedError;
  List<SniperCard> get p1HoleCards => throw _privateConstructorUsedError;
  List<SniperCard> get p2HoleCards => throw _privateConstructorUsedError;
  List<SniperCard> get communityCards => throw _privateConstructorUsedError;
  SniperHandPhase get handPhase => throw _privateConstructorUsedError;
  int get p1ShotgunCooldownRounds => throw _privateConstructorUsedError;
  int get p2ShotgunCooldownRounds => throw _privateConstructorUsedError;
  String? get p1ActiveSkill => throw _privateConstructorUsedError;
  String? get p2ActiveSkill => throw _privateConstructorUsedError;
  bool get isGameOver => throw _privateConstructorUsedError;
  SniperRiverDeclaration? get p1RiverDeclaration =>
      throw _privateConstructorUsedError;
  SniperRiverDeclaration? get p2RiverDeclaration =>
      throw _privateConstructorUsedError;
  bool get isShowdown => throw _privateConstructorUsedError;
  SniperShowdownSnapshot? get showdownSnapshot =>
      throw _privateConstructorUsedError;
  String get lastActionLog => throw _privateConstructorUsedError;
  List<String> get p1UsedSkills => throw _privateConstructorUsedError;
  List<String> get p2UsedSkills => throw _privateConstructorUsedError;
  SniperPlayerId? get actingPlayer => throw _privateConstructorUsedError;
  int get p1StreetBet => throw _privateConstructorUsedError;
  int get p2StreetBet => throw _privateConstructorUsedError;
  bool get p1ActedThisStreet => throw _privateConstructorUsedError;
  bool get p2ActedThisStreet => throw _privateConstructorUsedError;
  bool get p1SkillLocked => throw _privateConstructorUsedError;
  bool get p2SkillLocked => throw _privateConstructorUsedError;
  bool get p1SniperLocked => throw _privateConstructorUsedError;
  bool get p2SniperLocked => throw _privateConstructorUsedError;
  SniperPlayerId? get handStarter => throw _privateConstructorUsedError;
  SniperPlayerId? get nextHandStarter => throw _privateConstructorUsedError;
  int get p1ChipsAtHandStart => throw _privateConstructorUsedError;
  int get p2ChipsAtHandStart => throw _privateConstructorUsedError;

  /// Carry-over merged into this hand's pot at deal (not in stacks).
  int get carryInAtHandStart => throw _privateConstructorUsedError;
  int? get p1TurnSecondsRemaining => throw _privateConstructorUsedError;
  bool get showRoundStarterBanner => throw _privateConstructorUsedError;
  String? get opponentActionBanner => throw _privateConstructorUsedError;

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SniperMatchStateCopyWith<SniperMatchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SniperMatchStateCopyWith<$Res> {
  factory $SniperMatchStateCopyWith(
          SniperMatchState value, $Res Function(SniperMatchState) then) =
      _$SniperMatchStateCopyWithImpl<$Res, SniperMatchState>;
  @useResult
  $Res call(
      {int p1Chips,
      int p2Chips,
      int p1RoundInvestment,
      int p2RoundInvestment,
      int currentAnte,
      int currentRoundCount,
      int currentPot,
      int carryOverPot,
      List<SniperCard> p1HoleCards,
      List<SniperCard> p2HoleCards,
      List<SniperCard> communityCards,
      SniperHandPhase handPhase,
      int p1ShotgunCooldownRounds,
      int p2ShotgunCooldownRounds,
      String? p1ActiveSkill,
      String? p2ActiveSkill,
      bool isGameOver,
      SniperRiverDeclaration? p1RiverDeclaration,
      SniperRiverDeclaration? p2RiverDeclaration,
      bool isShowdown,
      SniperShowdownSnapshot? showdownSnapshot,
      String lastActionLog,
      List<String> p1UsedSkills,
      List<String> p2UsedSkills,
      SniperPlayerId? actingPlayer,
      int p1StreetBet,
      int p2StreetBet,
      bool p1ActedThisStreet,
      bool p2ActedThisStreet,
      bool p1SkillLocked,
      bool p2SkillLocked,
      bool p1SniperLocked,
      bool p2SniperLocked,
      SniperPlayerId? handStarter,
      SniperPlayerId? nextHandStarter,
      int p1ChipsAtHandStart,
      int p2ChipsAtHandStart,
      int carryInAtHandStart,
      int? p1TurnSecondsRemaining,
      bool showRoundStarterBanner,
      String? opponentActionBanner});

  $SniperRiverDeclarationCopyWith<$Res>? get p1RiverDeclaration;
  $SniperRiverDeclarationCopyWith<$Res>? get p2RiverDeclaration;
  $SniperShowdownSnapshotCopyWith<$Res>? get showdownSnapshot;
}

/// @nodoc
class _$SniperMatchStateCopyWithImpl<$Res, $Val extends SniperMatchState>
    implements $SniperMatchStateCopyWith<$Res> {
  _$SniperMatchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? p1Chips = null,
    Object? p2Chips = null,
    Object? p1RoundInvestment = null,
    Object? p2RoundInvestment = null,
    Object? currentAnte = null,
    Object? currentRoundCount = null,
    Object? currentPot = null,
    Object? carryOverPot = null,
    Object? p1HoleCards = null,
    Object? p2HoleCards = null,
    Object? communityCards = null,
    Object? handPhase = null,
    Object? p1ShotgunCooldownRounds = null,
    Object? p2ShotgunCooldownRounds = null,
    Object? p1ActiveSkill = freezed,
    Object? p2ActiveSkill = freezed,
    Object? isGameOver = null,
    Object? p1RiverDeclaration = freezed,
    Object? p2RiverDeclaration = freezed,
    Object? isShowdown = null,
    Object? showdownSnapshot = freezed,
    Object? lastActionLog = null,
    Object? p1UsedSkills = null,
    Object? p2UsedSkills = null,
    Object? actingPlayer = freezed,
    Object? p1StreetBet = null,
    Object? p2StreetBet = null,
    Object? p1ActedThisStreet = null,
    Object? p2ActedThisStreet = null,
    Object? p1SkillLocked = null,
    Object? p2SkillLocked = null,
    Object? p1SniperLocked = null,
    Object? p2SniperLocked = null,
    Object? handStarter = freezed,
    Object? nextHandStarter = freezed,
    Object? p1ChipsAtHandStart = null,
    Object? p2ChipsAtHandStart = null,
    Object? carryInAtHandStart = null,
    Object? p1TurnSecondsRemaining = freezed,
    Object? showRoundStarterBanner = null,
    Object? opponentActionBanner = freezed,
  }) {
    return _then(_value.copyWith(
      p1Chips: null == p1Chips
          ? _value.p1Chips
          : p1Chips // ignore: cast_nullable_to_non_nullable
              as int,
      p2Chips: null == p2Chips
          ? _value.p2Chips
          : p2Chips // ignore: cast_nullable_to_non_nullable
              as int,
      p1RoundInvestment: null == p1RoundInvestment
          ? _value.p1RoundInvestment
          : p1RoundInvestment // ignore: cast_nullable_to_non_nullable
              as int,
      p2RoundInvestment: null == p2RoundInvestment
          ? _value.p2RoundInvestment
          : p2RoundInvestment // ignore: cast_nullable_to_non_nullable
              as int,
      currentAnte: null == currentAnte
          ? _value.currentAnte
          : currentAnte // ignore: cast_nullable_to_non_nullable
              as int,
      currentRoundCount: null == currentRoundCount
          ? _value.currentRoundCount
          : currentRoundCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentPot: null == currentPot
          ? _value.currentPot
          : currentPot // ignore: cast_nullable_to_non_nullable
              as int,
      carryOverPot: null == carryOverPot
          ? _value.carryOverPot
          : carryOverPot // ignore: cast_nullable_to_non_nullable
              as int,
      p1HoleCards: null == p1HoleCards
          ? _value.p1HoleCards
          : p1HoleCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      p2HoleCards: null == p2HoleCards
          ? _value.p2HoleCards
          : p2HoleCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      communityCards: null == communityCards
          ? _value.communityCards
          : communityCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      handPhase: null == handPhase
          ? _value.handPhase
          : handPhase // ignore: cast_nullable_to_non_nullable
              as SniperHandPhase,
      p1ShotgunCooldownRounds: null == p1ShotgunCooldownRounds
          ? _value.p1ShotgunCooldownRounds
          : p1ShotgunCooldownRounds // ignore: cast_nullable_to_non_nullable
              as int,
      p2ShotgunCooldownRounds: null == p2ShotgunCooldownRounds
          ? _value.p2ShotgunCooldownRounds
          : p2ShotgunCooldownRounds // ignore: cast_nullable_to_non_nullable
              as int,
      p1ActiveSkill: freezed == p1ActiveSkill
          ? _value.p1ActiveSkill
          : p1ActiveSkill // ignore: cast_nullable_to_non_nullable
              as String?,
      p2ActiveSkill: freezed == p2ActiveSkill
          ? _value.p2ActiveSkill
          : p2ActiveSkill // ignore: cast_nullable_to_non_nullable
              as String?,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      p1RiverDeclaration: freezed == p1RiverDeclaration
          ? _value.p1RiverDeclaration
          : p1RiverDeclaration // ignore: cast_nullable_to_non_nullable
              as SniperRiverDeclaration?,
      p2RiverDeclaration: freezed == p2RiverDeclaration
          ? _value.p2RiverDeclaration
          : p2RiverDeclaration // ignore: cast_nullable_to_non_nullable
              as SniperRiverDeclaration?,
      isShowdown: null == isShowdown
          ? _value.isShowdown
          : isShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      showdownSnapshot: freezed == showdownSnapshot
          ? _value.showdownSnapshot
          : showdownSnapshot // ignore: cast_nullable_to_non_nullable
              as SniperShowdownSnapshot?,
      lastActionLog: null == lastActionLog
          ? _value.lastActionLog
          : lastActionLog // ignore: cast_nullable_to_non_nullable
              as String,
      p1UsedSkills: null == p1UsedSkills
          ? _value.p1UsedSkills
          : p1UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      p2UsedSkills: null == p2UsedSkills
          ? _value.p2UsedSkills
          : p2UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actingPlayer: freezed == actingPlayer
          ? _value.actingPlayer
          : actingPlayer // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1StreetBet: null == p1StreetBet
          ? _value.p1StreetBet
          : p1StreetBet // ignore: cast_nullable_to_non_nullable
              as int,
      p2StreetBet: null == p2StreetBet
          ? _value.p2StreetBet
          : p2StreetBet // ignore: cast_nullable_to_non_nullable
              as int,
      p1ActedThisStreet: null == p1ActedThisStreet
          ? _value.p1ActedThisStreet
          : p1ActedThisStreet // ignore: cast_nullable_to_non_nullable
              as bool,
      p2ActedThisStreet: null == p2ActedThisStreet
          ? _value.p2ActedThisStreet
          : p2ActedThisStreet // ignore: cast_nullable_to_non_nullable
              as bool,
      p1SkillLocked: null == p1SkillLocked
          ? _value.p1SkillLocked
          : p1SkillLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SkillLocked: null == p2SkillLocked
          ? _value.p2SkillLocked
          : p2SkillLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p1SniperLocked: null == p1SniperLocked
          ? _value.p1SniperLocked
          : p1SniperLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SniperLocked: null == p2SniperLocked
          ? _value.p2SniperLocked
          : p2SniperLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      handStarter: freezed == handStarter
          ? _value.handStarter
          : handStarter // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      nextHandStarter: freezed == nextHandStarter
          ? _value.nextHandStarter
          : nextHandStarter // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1ChipsAtHandStart: null == p1ChipsAtHandStart
          ? _value.p1ChipsAtHandStart
          : p1ChipsAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipsAtHandStart: null == p2ChipsAtHandStart
          ? _value.p2ChipsAtHandStart
          : p2ChipsAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      carryInAtHandStart: null == carryInAtHandStart
          ? _value.carryInAtHandStart
          : carryInAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      p1TurnSecondsRemaining: freezed == p1TurnSecondsRemaining
          ? _value.p1TurnSecondsRemaining
          : p1TurnSecondsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      showRoundStarterBanner: null == showRoundStarterBanner
          ? _value.showRoundStarterBanner
          : showRoundStarterBanner // ignore: cast_nullable_to_non_nullable
              as bool,
      opponentActionBanner: freezed == opponentActionBanner
          ? _value.opponentActionBanner
          : opponentActionBanner // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SniperRiverDeclarationCopyWith<$Res>? get p1RiverDeclaration {
    if (_value.p1RiverDeclaration == null) {
      return null;
    }

    return $SniperRiverDeclarationCopyWith<$Res>(_value.p1RiverDeclaration!,
        (value) {
      return _then(_value.copyWith(p1RiverDeclaration: value) as $Val);
    });
  }

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SniperRiverDeclarationCopyWith<$Res>? get p2RiverDeclaration {
    if (_value.p2RiverDeclaration == null) {
      return null;
    }

    return $SniperRiverDeclarationCopyWith<$Res>(_value.p2RiverDeclaration!,
        (value) {
      return _then(_value.copyWith(p2RiverDeclaration: value) as $Val);
    });
  }

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SniperShowdownSnapshotCopyWith<$Res>? get showdownSnapshot {
    if (_value.showdownSnapshot == null) {
      return null;
    }

    return $SniperShowdownSnapshotCopyWith<$Res>(_value.showdownSnapshot!,
        (value) {
      return _then(_value.copyWith(showdownSnapshot: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SniperMatchStateImplCopyWith<$Res>
    implements $SniperMatchStateCopyWith<$Res> {
  factory _$$SniperMatchStateImplCopyWith(_$SniperMatchStateImpl value,
          $Res Function(_$SniperMatchStateImpl) then) =
      __$$SniperMatchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int p1Chips,
      int p2Chips,
      int p1RoundInvestment,
      int p2RoundInvestment,
      int currentAnte,
      int currentRoundCount,
      int currentPot,
      int carryOverPot,
      List<SniperCard> p1HoleCards,
      List<SniperCard> p2HoleCards,
      List<SniperCard> communityCards,
      SniperHandPhase handPhase,
      int p1ShotgunCooldownRounds,
      int p2ShotgunCooldownRounds,
      String? p1ActiveSkill,
      String? p2ActiveSkill,
      bool isGameOver,
      SniperRiverDeclaration? p1RiverDeclaration,
      SniperRiverDeclaration? p2RiverDeclaration,
      bool isShowdown,
      SniperShowdownSnapshot? showdownSnapshot,
      String lastActionLog,
      List<String> p1UsedSkills,
      List<String> p2UsedSkills,
      SniperPlayerId? actingPlayer,
      int p1StreetBet,
      int p2StreetBet,
      bool p1ActedThisStreet,
      bool p2ActedThisStreet,
      bool p1SkillLocked,
      bool p2SkillLocked,
      bool p1SniperLocked,
      bool p2SniperLocked,
      SniperPlayerId? handStarter,
      SniperPlayerId? nextHandStarter,
      int p1ChipsAtHandStart,
      int p2ChipsAtHandStart,
      int carryInAtHandStart,
      int? p1TurnSecondsRemaining,
      bool showRoundStarterBanner,
      String? opponentActionBanner});

  @override
  $SniperRiverDeclarationCopyWith<$Res>? get p1RiverDeclaration;
  @override
  $SniperRiverDeclarationCopyWith<$Res>? get p2RiverDeclaration;
  @override
  $SniperShowdownSnapshotCopyWith<$Res>? get showdownSnapshot;
}

/// @nodoc
class __$$SniperMatchStateImplCopyWithImpl<$Res>
    extends _$SniperMatchStateCopyWithImpl<$Res, _$SniperMatchStateImpl>
    implements _$$SniperMatchStateImplCopyWith<$Res> {
  __$$SniperMatchStateImplCopyWithImpl(_$SniperMatchStateImpl _value,
      $Res Function(_$SniperMatchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? p1Chips = null,
    Object? p2Chips = null,
    Object? p1RoundInvestment = null,
    Object? p2RoundInvestment = null,
    Object? currentAnte = null,
    Object? currentRoundCount = null,
    Object? currentPot = null,
    Object? carryOverPot = null,
    Object? p1HoleCards = null,
    Object? p2HoleCards = null,
    Object? communityCards = null,
    Object? handPhase = null,
    Object? p1ShotgunCooldownRounds = null,
    Object? p2ShotgunCooldownRounds = null,
    Object? p1ActiveSkill = freezed,
    Object? p2ActiveSkill = freezed,
    Object? isGameOver = null,
    Object? p1RiverDeclaration = freezed,
    Object? p2RiverDeclaration = freezed,
    Object? isShowdown = null,
    Object? showdownSnapshot = freezed,
    Object? lastActionLog = null,
    Object? p1UsedSkills = null,
    Object? p2UsedSkills = null,
    Object? actingPlayer = freezed,
    Object? p1StreetBet = null,
    Object? p2StreetBet = null,
    Object? p1ActedThisStreet = null,
    Object? p2ActedThisStreet = null,
    Object? p1SkillLocked = null,
    Object? p2SkillLocked = null,
    Object? p1SniperLocked = null,
    Object? p2SniperLocked = null,
    Object? handStarter = freezed,
    Object? nextHandStarter = freezed,
    Object? p1ChipsAtHandStart = null,
    Object? p2ChipsAtHandStart = null,
    Object? carryInAtHandStart = null,
    Object? p1TurnSecondsRemaining = freezed,
    Object? showRoundStarterBanner = null,
    Object? opponentActionBanner = freezed,
  }) {
    return _then(_$SniperMatchStateImpl(
      p1Chips: null == p1Chips
          ? _value.p1Chips
          : p1Chips // ignore: cast_nullable_to_non_nullable
              as int,
      p2Chips: null == p2Chips
          ? _value.p2Chips
          : p2Chips // ignore: cast_nullable_to_non_nullable
              as int,
      p1RoundInvestment: null == p1RoundInvestment
          ? _value.p1RoundInvestment
          : p1RoundInvestment // ignore: cast_nullable_to_non_nullable
              as int,
      p2RoundInvestment: null == p2RoundInvestment
          ? _value.p2RoundInvestment
          : p2RoundInvestment // ignore: cast_nullable_to_non_nullable
              as int,
      currentAnte: null == currentAnte
          ? _value.currentAnte
          : currentAnte // ignore: cast_nullable_to_non_nullable
              as int,
      currentRoundCount: null == currentRoundCount
          ? _value.currentRoundCount
          : currentRoundCount // ignore: cast_nullable_to_non_nullable
              as int,
      currentPot: null == currentPot
          ? _value.currentPot
          : currentPot // ignore: cast_nullable_to_non_nullable
              as int,
      carryOverPot: null == carryOverPot
          ? _value.carryOverPot
          : carryOverPot // ignore: cast_nullable_to_non_nullable
              as int,
      p1HoleCards: null == p1HoleCards
          ? _value._p1HoleCards
          : p1HoleCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      p2HoleCards: null == p2HoleCards
          ? _value._p2HoleCards
          : p2HoleCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      communityCards: null == communityCards
          ? _value._communityCards
          : communityCards // ignore: cast_nullable_to_non_nullable
              as List<SniperCard>,
      handPhase: null == handPhase
          ? _value.handPhase
          : handPhase // ignore: cast_nullable_to_non_nullable
              as SniperHandPhase,
      p1ShotgunCooldownRounds: null == p1ShotgunCooldownRounds
          ? _value.p1ShotgunCooldownRounds
          : p1ShotgunCooldownRounds // ignore: cast_nullable_to_non_nullable
              as int,
      p2ShotgunCooldownRounds: null == p2ShotgunCooldownRounds
          ? _value.p2ShotgunCooldownRounds
          : p2ShotgunCooldownRounds // ignore: cast_nullable_to_non_nullable
              as int,
      p1ActiveSkill: freezed == p1ActiveSkill
          ? _value.p1ActiveSkill
          : p1ActiveSkill // ignore: cast_nullable_to_non_nullable
              as String?,
      p2ActiveSkill: freezed == p2ActiveSkill
          ? _value.p2ActiveSkill
          : p2ActiveSkill // ignore: cast_nullable_to_non_nullable
              as String?,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      p1RiverDeclaration: freezed == p1RiverDeclaration
          ? _value.p1RiverDeclaration
          : p1RiverDeclaration // ignore: cast_nullable_to_non_nullable
              as SniperRiverDeclaration?,
      p2RiverDeclaration: freezed == p2RiverDeclaration
          ? _value.p2RiverDeclaration
          : p2RiverDeclaration // ignore: cast_nullable_to_non_nullable
              as SniperRiverDeclaration?,
      isShowdown: null == isShowdown
          ? _value.isShowdown
          : isShowdown // ignore: cast_nullable_to_non_nullable
              as bool,
      showdownSnapshot: freezed == showdownSnapshot
          ? _value.showdownSnapshot
          : showdownSnapshot // ignore: cast_nullable_to_non_nullable
              as SniperShowdownSnapshot?,
      lastActionLog: null == lastActionLog
          ? _value.lastActionLog
          : lastActionLog // ignore: cast_nullable_to_non_nullable
              as String,
      p1UsedSkills: null == p1UsedSkills
          ? _value._p1UsedSkills
          : p1UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      p2UsedSkills: null == p2UsedSkills
          ? _value._p2UsedSkills
          : p2UsedSkills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      actingPlayer: freezed == actingPlayer
          ? _value.actingPlayer
          : actingPlayer // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1StreetBet: null == p1StreetBet
          ? _value.p1StreetBet
          : p1StreetBet // ignore: cast_nullable_to_non_nullable
              as int,
      p2StreetBet: null == p2StreetBet
          ? _value.p2StreetBet
          : p2StreetBet // ignore: cast_nullable_to_non_nullable
              as int,
      p1ActedThisStreet: null == p1ActedThisStreet
          ? _value.p1ActedThisStreet
          : p1ActedThisStreet // ignore: cast_nullable_to_non_nullable
              as bool,
      p2ActedThisStreet: null == p2ActedThisStreet
          ? _value.p2ActedThisStreet
          : p2ActedThisStreet // ignore: cast_nullable_to_non_nullable
              as bool,
      p1SkillLocked: null == p1SkillLocked
          ? _value.p1SkillLocked
          : p1SkillLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SkillLocked: null == p2SkillLocked
          ? _value.p2SkillLocked
          : p2SkillLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p1SniperLocked: null == p1SniperLocked
          ? _value.p1SniperLocked
          : p1SniperLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      p2SniperLocked: null == p2SniperLocked
          ? _value.p2SniperLocked
          : p2SniperLocked // ignore: cast_nullable_to_non_nullable
              as bool,
      handStarter: freezed == handStarter
          ? _value.handStarter
          : handStarter // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      nextHandStarter: freezed == nextHandStarter
          ? _value.nextHandStarter
          : nextHandStarter // ignore: cast_nullable_to_non_nullable
              as SniperPlayerId?,
      p1ChipsAtHandStart: null == p1ChipsAtHandStart
          ? _value.p1ChipsAtHandStart
          : p1ChipsAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      p2ChipsAtHandStart: null == p2ChipsAtHandStart
          ? _value.p2ChipsAtHandStart
          : p2ChipsAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      carryInAtHandStart: null == carryInAtHandStart
          ? _value.carryInAtHandStart
          : carryInAtHandStart // ignore: cast_nullable_to_non_nullable
              as int,
      p1TurnSecondsRemaining: freezed == p1TurnSecondsRemaining
          ? _value.p1TurnSecondsRemaining
          : p1TurnSecondsRemaining // ignore: cast_nullable_to_non_nullable
              as int?,
      showRoundStarterBanner: null == showRoundStarterBanner
          ? _value.showRoundStarterBanner
          : showRoundStarterBanner // ignore: cast_nullable_to_non_nullable
              as bool,
      opponentActionBanner: freezed == opponentActionBanner
          ? _value.opponentActionBanner
          : opponentActionBanner // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SniperMatchStateImpl extends _SniperMatchState {
  const _$SniperMatchStateImpl(
      {required this.p1Chips,
      required this.p2Chips,
      required this.p1RoundInvestment,
      required this.p2RoundInvestment,
      required this.currentAnte,
      required this.currentRoundCount,
      required this.currentPot,
      required this.carryOverPot,
      required final List<SniperCard> p1HoleCards,
      required final List<SniperCard> p2HoleCards,
      required final List<SniperCard> communityCards,
      required this.handPhase,
      required this.p1ShotgunCooldownRounds,
      required this.p2ShotgunCooldownRounds,
      this.p1ActiveSkill,
      this.p2ActiveSkill,
      required this.isGameOver,
      this.p1RiverDeclaration,
      this.p2RiverDeclaration,
      this.isShowdown = false,
      this.showdownSnapshot,
      this.lastActionLog = '',
      final List<String> p1UsedSkills = const <String>[],
      final List<String> p2UsedSkills = const <String>[],
      this.actingPlayer,
      this.p1StreetBet = 0,
      this.p2StreetBet = 0,
      this.p1ActedThisStreet = false,
      this.p2ActedThisStreet = false,
      this.p1SkillLocked = false,
      this.p2SkillLocked = false,
      this.p1SniperLocked = false,
      this.p2SniperLocked = false,
      this.handStarter,
      this.nextHandStarter,
      this.p1ChipsAtHandStart = 0,
      this.p2ChipsAtHandStart = 0,
      this.carryInAtHandStart = 0,
      this.p1TurnSecondsRemaining,
      this.showRoundStarterBanner = false,
      this.opponentActionBanner})
      : _p1HoleCards = p1HoleCards,
        _p2HoleCards = p2HoleCards,
        _communityCards = communityCards,
        _p1UsedSkills = p1UsedSkills,
        _p2UsedSkills = p2UsedSkills,
        super._();

  @override
  final int p1Chips;
  @override
  final int p2Chips;
  @override
  final int p1RoundInvestment;
  @override
  final int p2RoundInvestment;
  @override
  final int currentAnte;
  @override
  final int currentRoundCount;
  @override
  final int currentPot;
  @override
  final int carryOverPot;
  final List<SniperCard> _p1HoleCards;
  @override
  List<SniperCard> get p1HoleCards {
    if (_p1HoleCards is EqualUnmodifiableListView) return _p1HoleCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p1HoleCards);
  }

  final List<SniperCard> _p2HoleCards;
  @override
  List<SniperCard> get p2HoleCards {
    if (_p2HoleCards is EqualUnmodifiableListView) return _p2HoleCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_p2HoleCards);
  }

  final List<SniperCard> _communityCards;
  @override
  List<SniperCard> get communityCards {
    if (_communityCards is EqualUnmodifiableListView) return _communityCards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_communityCards);
  }

  @override
  final SniperHandPhase handPhase;
  @override
  final int p1ShotgunCooldownRounds;
  @override
  final int p2ShotgunCooldownRounds;
  @override
  final String? p1ActiveSkill;
  @override
  final String? p2ActiveSkill;
  @override
  final bool isGameOver;
  @override
  final SniperRiverDeclaration? p1RiverDeclaration;
  @override
  final SniperRiverDeclaration? p2RiverDeclaration;
  @override
  @JsonKey()
  final bool isShowdown;
  @override
  final SniperShowdownSnapshot? showdownSnapshot;
  @override
  @JsonKey()
  final String lastActionLog;
  final List<String> _p1UsedSkills;
  @override
  @JsonKey()
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
  final SniperPlayerId? actingPlayer;
  @override
  @JsonKey()
  final int p1StreetBet;
  @override
  @JsonKey()
  final int p2StreetBet;
  @override
  @JsonKey()
  final bool p1ActedThisStreet;
  @override
  @JsonKey()
  final bool p2ActedThisStreet;
  @override
  @JsonKey()
  final bool p1SkillLocked;
  @override
  @JsonKey()
  final bool p2SkillLocked;
  @override
  @JsonKey()
  final bool p1SniperLocked;
  @override
  @JsonKey()
  final bool p2SniperLocked;
  @override
  final SniperPlayerId? handStarter;
  @override
  final SniperPlayerId? nextHandStarter;
  @override
  @JsonKey()
  final int p1ChipsAtHandStart;
  @override
  @JsonKey()
  final int p2ChipsAtHandStart;

  /// Carry-over merged into this hand's pot at deal (not in stacks).
  @override
  @JsonKey()
  final int carryInAtHandStart;
  @override
  final int? p1TurnSecondsRemaining;
  @override
  @JsonKey()
  final bool showRoundStarterBanner;
  @override
  final String? opponentActionBanner;

  @override
  String toString() {
    return 'SniperMatchState(p1Chips: $p1Chips, p2Chips: $p2Chips, p1RoundInvestment: $p1RoundInvestment, p2RoundInvestment: $p2RoundInvestment, currentAnte: $currentAnte, currentRoundCount: $currentRoundCount, currentPot: $currentPot, carryOverPot: $carryOverPot, p1HoleCards: $p1HoleCards, p2HoleCards: $p2HoleCards, communityCards: $communityCards, handPhase: $handPhase, p1ShotgunCooldownRounds: $p1ShotgunCooldownRounds, p2ShotgunCooldownRounds: $p2ShotgunCooldownRounds, p1ActiveSkill: $p1ActiveSkill, p2ActiveSkill: $p2ActiveSkill, isGameOver: $isGameOver, p1RiverDeclaration: $p1RiverDeclaration, p2RiverDeclaration: $p2RiverDeclaration, isShowdown: $isShowdown, showdownSnapshot: $showdownSnapshot, lastActionLog: $lastActionLog, p1UsedSkills: $p1UsedSkills, p2UsedSkills: $p2UsedSkills, actingPlayer: $actingPlayer, p1StreetBet: $p1StreetBet, p2StreetBet: $p2StreetBet, p1ActedThisStreet: $p1ActedThisStreet, p2ActedThisStreet: $p2ActedThisStreet, p1SkillLocked: $p1SkillLocked, p2SkillLocked: $p2SkillLocked, p1SniperLocked: $p1SniperLocked, p2SniperLocked: $p2SniperLocked, handStarter: $handStarter, nextHandStarter: $nextHandStarter, p1ChipsAtHandStart: $p1ChipsAtHandStart, p2ChipsAtHandStart: $p2ChipsAtHandStart, carryInAtHandStart: $carryInAtHandStart, p1TurnSecondsRemaining: $p1TurnSecondsRemaining, showRoundStarterBanner: $showRoundStarterBanner, opponentActionBanner: $opponentActionBanner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SniperMatchStateImpl &&
            (identical(other.p1Chips, p1Chips) || other.p1Chips == p1Chips) &&
            (identical(other.p2Chips, p2Chips) || other.p2Chips == p2Chips) &&
            (identical(other.p1RoundInvestment, p1RoundInvestment) ||
                other.p1RoundInvestment == p1RoundInvestment) &&
            (identical(other.p2RoundInvestment, p2RoundInvestment) ||
                other.p2RoundInvestment == p2RoundInvestment) &&
            (identical(other.currentAnte, currentAnte) ||
                other.currentAnte == currentAnte) &&
            (identical(other.currentRoundCount, currentRoundCount) ||
                other.currentRoundCount == currentRoundCount) &&
            (identical(other.currentPot, currentPot) ||
                other.currentPot == currentPot) &&
            (identical(other.carryOverPot, carryOverPot) ||
                other.carryOverPot == carryOverPot) &&
            const DeepCollectionEquality()
                .equals(other._p1HoleCards, _p1HoleCards) &&
            const DeepCollectionEquality()
                .equals(other._p2HoleCards, _p2HoleCards) &&
            const DeepCollectionEquality()
                .equals(other._communityCards, _communityCards) &&
            (identical(other.handPhase, handPhase) ||
                other.handPhase == handPhase) &&
            (identical(other.p1ShotgunCooldownRounds, p1ShotgunCooldownRounds) ||
                other.p1ShotgunCooldownRounds == p1ShotgunCooldownRounds) &&
            (identical(other.p2ShotgunCooldownRounds, p2ShotgunCooldownRounds) ||
                other.p2ShotgunCooldownRounds == p2ShotgunCooldownRounds) &&
            (identical(other.p1ActiveSkill, p1ActiveSkill) ||
                other.p1ActiveSkill == p1ActiveSkill) &&
            (identical(other.p2ActiveSkill, p2ActiveSkill) ||
                other.p2ActiveSkill == p2ActiveSkill) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.p1RiverDeclaration, p1RiverDeclaration) ||
                other.p1RiverDeclaration == p1RiverDeclaration) &&
            (identical(other.p2RiverDeclaration, p2RiverDeclaration) ||
                other.p2RiverDeclaration == p2RiverDeclaration) &&
            (identical(other.isShowdown, isShowdown) ||
                other.isShowdown == isShowdown) &&
            (identical(other.showdownSnapshot, showdownSnapshot) ||
                other.showdownSnapshot == showdownSnapshot) &&
            (identical(other.lastActionLog, lastActionLog) ||
                other.lastActionLog == lastActionLog) &&
            const DeepCollectionEquality()
                .equals(other._p1UsedSkills, _p1UsedSkills) &&
            const DeepCollectionEquality()
                .equals(other._p2UsedSkills, _p2UsedSkills) &&
            (identical(other.actingPlayer, actingPlayer) ||
                other.actingPlayer == actingPlayer) &&
            (identical(other.p1StreetBet, p1StreetBet) ||
                other.p1StreetBet == p1StreetBet) &&
            (identical(other.p2StreetBet, p2StreetBet) ||
                other.p2StreetBet == p2StreetBet) &&
            (identical(other.p1ActedThisStreet, p1ActedThisStreet) ||
                other.p1ActedThisStreet == p1ActedThisStreet) &&
            (identical(other.p2ActedThisStreet, p2ActedThisStreet) ||
                other.p2ActedThisStreet == p2ActedThisStreet) &&
            (identical(other.p1SkillLocked, p1SkillLocked) ||
                other.p1SkillLocked == p1SkillLocked) &&
            (identical(other.p2SkillLocked, p2SkillLocked) ||
                other.p2SkillLocked == p2SkillLocked) &&
            (identical(other.p1SniperLocked, p1SniperLocked) ||
                other.p1SniperLocked == p1SniperLocked) &&
            (identical(other.p2SniperLocked, p2SniperLocked) ||
                other.p2SniperLocked == p2SniperLocked) &&
            (identical(other.handStarter, handStarter) ||
                other.handStarter == handStarter) &&
            (identical(other.nextHandStarter, nextHandStarter) || other.nextHandStarter == nextHandStarter) &&
            (identical(other.p1ChipsAtHandStart, p1ChipsAtHandStart) || other.p1ChipsAtHandStart == p1ChipsAtHandStart) &&
            (identical(other.p2ChipsAtHandStart, p2ChipsAtHandStart) || other.p2ChipsAtHandStart == p2ChipsAtHandStart) &&
            (identical(other.carryInAtHandStart, carryInAtHandStart) || other.carryInAtHandStart == carryInAtHandStart) &&
            (identical(other.p1TurnSecondsRemaining, p1TurnSecondsRemaining) || other.p1TurnSecondsRemaining == p1TurnSecondsRemaining) &&
            (identical(other.showRoundStarterBanner, showRoundStarterBanner) || other.showRoundStarterBanner == showRoundStarterBanner) &&
            (identical(other.opponentActionBanner, opponentActionBanner) || other.opponentActionBanner == opponentActionBanner));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        p1Chips,
        p2Chips,
        p1RoundInvestment,
        p2RoundInvestment,
        currentAnte,
        currentRoundCount,
        currentPot,
        carryOverPot,
        const DeepCollectionEquality().hash(_p1HoleCards),
        const DeepCollectionEquality().hash(_p2HoleCards),
        const DeepCollectionEquality().hash(_communityCards),
        handPhase,
        p1ShotgunCooldownRounds,
        p2ShotgunCooldownRounds,
        p1ActiveSkill,
        p2ActiveSkill,
        isGameOver,
        p1RiverDeclaration,
        p2RiverDeclaration,
        isShowdown,
        showdownSnapshot,
        lastActionLog,
        const DeepCollectionEquality().hash(_p1UsedSkills),
        const DeepCollectionEquality().hash(_p2UsedSkills),
        actingPlayer,
        p1StreetBet,
        p2StreetBet,
        p1ActedThisStreet,
        p2ActedThisStreet,
        p1SkillLocked,
        p2SkillLocked,
        p1SniperLocked,
        p2SniperLocked,
        handStarter,
        nextHandStarter,
        p1ChipsAtHandStart,
        p2ChipsAtHandStart,
        carryInAtHandStart,
        p1TurnSecondsRemaining,
        showRoundStarterBanner,
        opponentActionBanner
      ]);

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SniperMatchStateImplCopyWith<_$SniperMatchStateImpl> get copyWith =>
      __$$SniperMatchStateImplCopyWithImpl<_$SniperMatchStateImpl>(
          this, _$identity);
}

abstract class _SniperMatchState extends SniperMatchState {
  const factory _SniperMatchState(
      {required final int p1Chips,
      required final int p2Chips,
      required final int p1RoundInvestment,
      required final int p2RoundInvestment,
      required final int currentAnte,
      required final int currentRoundCount,
      required final int currentPot,
      required final int carryOverPot,
      required final List<SniperCard> p1HoleCards,
      required final List<SniperCard> p2HoleCards,
      required final List<SniperCard> communityCards,
      required final SniperHandPhase handPhase,
      required final int p1ShotgunCooldownRounds,
      required final int p2ShotgunCooldownRounds,
      final String? p1ActiveSkill,
      final String? p2ActiveSkill,
      required final bool isGameOver,
      final SniperRiverDeclaration? p1RiverDeclaration,
      final SniperRiverDeclaration? p2RiverDeclaration,
      final bool isShowdown,
      final SniperShowdownSnapshot? showdownSnapshot,
      final String lastActionLog,
      final List<String> p1UsedSkills,
      final List<String> p2UsedSkills,
      final SniperPlayerId? actingPlayer,
      final int p1StreetBet,
      final int p2StreetBet,
      final bool p1ActedThisStreet,
      final bool p2ActedThisStreet,
      final bool p1SkillLocked,
      final bool p2SkillLocked,
      final bool p1SniperLocked,
      final bool p2SniperLocked,
      final SniperPlayerId? handStarter,
      final SniperPlayerId? nextHandStarter,
      final int p1ChipsAtHandStart,
      final int p2ChipsAtHandStart,
      final int carryInAtHandStart,
      final int? p1TurnSecondsRemaining,
      final bool showRoundStarterBanner,
      final String? opponentActionBanner}) = _$SniperMatchStateImpl;
  const _SniperMatchState._() : super._();

  @override
  int get p1Chips;
  @override
  int get p2Chips;
  @override
  int get p1RoundInvestment;
  @override
  int get p2RoundInvestment;
  @override
  int get currentAnte;
  @override
  int get currentRoundCount;
  @override
  int get currentPot;
  @override
  int get carryOverPot;
  @override
  List<SniperCard> get p1HoleCards;
  @override
  List<SniperCard> get p2HoleCards;
  @override
  List<SniperCard> get communityCards;
  @override
  SniperHandPhase get handPhase;
  @override
  int get p1ShotgunCooldownRounds;
  @override
  int get p2ShotgunCooldownRounds;
  @override
  String? get p1ActiveSkill;
  @override
  String? get p2ActiveSkill;
  @override
  bool get isGameOver;
  @override
  SniperRiverDeclaration? get p1RiverDeclaration;
  @override
  SniperRiverDeclaration? get p2RiverDeclaration;
  @override
  bool get isShowdown;
  @override
  SniperShowdownSnapshot? get showdownSnapshot;
  @override
  String get lastActionLog;
  @override
  List<String> get p1UsedSkills;
  @override
  List<String> get p2UsedSkills;
  @override
  SniperPlayerId? get actingPlayer;
  @override
  int get p1StreetBet;
  @override
  int get p2StreetBet;
  @override
  bool get p1ActedThisStreet;
  @override
  bool get p2ActedThisStreet;
  @override
  bool get p1SkillLocked;
  @override
  bool get p2SkillLocked;
  @override
  bool get p1SniperLocked;
  @override
  bool get p2SniperLocked;
  @override
  SniperPlayerId? get handStarter;
  @override
  SniperPlayerId? get nextHandStarter;
  @override
  int get p1ChipsAtHandStart;
  @override
  int get p2ChipsAtHandStart;

  /// Carry-over merged into this hand's pot at deal (not in stacks).
  @override
  int get carryInAtHandStart;
  @override
  int? get p1TurnSecondsRemaining;
  @override
  bool get showRoundStarterBanner;
  @override
  String? get opponentActionBanner;

  /// Create a copy of SniperMatchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SniperMatchStateImplCopyWith<_$SniperMatchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
