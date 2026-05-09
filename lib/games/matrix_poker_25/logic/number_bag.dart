import 'dart:math';

/// Balanced draws for values **1..10** using a shuffled multiset (bag / deck).
///
/// Default is **3** full sets (30 values). Each [draw] removes one value from the
/// end after a constructor-time [shuffle], so long-run frequencies stay even
/// compared to repeated `Random().nextInt(10)`.
class NumberBag {
  /// Builds [copies] sequences of `1..10`, then shuffles with [random].
  NumberBag(Random random, {int copies = 3})
      : _values = <int>[
          for (var c = 0; c < copies; c++)
            for (var n = 1; n <= 10; n++) n,
        ] {
    _values.shuffle(random);
  }

  final List<int> _values;

  int get remaining => _values.length;

  bool get isEmpty => _values.isEmpty;

  /// Removes and returns the next value (undefined order beyond shuffle).
  ///
  /// Throws [StateError] if the bag is empty.
  int draw() {
    if (_values.isEmpty) {
      throw StateError('NumberBag.draw called on an empty bag');
    }
    return _values.removeLast();
  }
}
