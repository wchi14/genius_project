/// One die in a player's cup, including the special blind die.
class DiceModel {
  DiceModel({
    required this.id,
    required this.faceValue,
    required this.isBlind,
  })  : assert(faceValue >= 1 && faceValue <= 6, 'faceValue must be 1..6'),
        assert(
          id.isNotEmpty,
          'id must be non-empty',
        );

  /// Stable identity for this die within a cup roll.
  final String id;

  /// Current face showing (`1`..`6`).
  final int faceValue;

  /// Exactly one die per cup has this set to `true` (the blind die).
  final bool isBlind;

  DiceModel copyWith({
    String? id,
    int? faceValue,
    bool? isBlind,
  }) {
    return DiceModel(
      id: id ?? this.id,
      faceValue: faceValue ?? this.faceValue,
      isBlind: isBlind ?? this.isBlind,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          faceValue == other.faceValue &&
          isBlind == other.isBlind;

  @override
  int get hashCode => Object.hash(id, faceValue, isBlind);

  @override
  String toString() =>
      'DiceModel($id: $faceValue${isBlind ? ', blind' : ''})';
}
