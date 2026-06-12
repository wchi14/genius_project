/// A single numbered block in the 40-block shoe (values 1–10, four copies each).
class BlockModel {
  const BlockModel({
    required this.value,
    required this.id,
  }) : assert(value >= 1 && value <= 10, 'value must be between 1 and 10');

  final int value;
  final String id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BlockModel && id == other.id && value == other.value;

  @override
  int get hashCode => Object.hash(id, value);

  @override
  String toString() => 'BlockModel($value, $id)';
}
