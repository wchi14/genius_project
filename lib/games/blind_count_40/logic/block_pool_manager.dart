import 'dart:math';

import '../models/block_model.dart';

/// Owns the 40-block shoe: four copies of each value 1–10, shuffled once at init.
class BlockPoolManager {
  BlockPoolManager({Random? random}) : _rng = random ?? Random() {
    _pool = _buildStandardPool();
    _shuffle(_pool);
  }

  final Random _rng;
  late final List<BlockModel> _pool;

  /// Blocks still available to draw (40 at start; 30 after a typical 5+5 setup).
  int get remainingCount => _pool.length;

  /// Standard composition: values **1–10** × **4** (40 blocks total).
  static List<BlockModel> buildStandardPool() {
    final blocks = <BlockModel>[];
    for (var value = 1; value <= 10; value++) {
      for (var copy = 0; copy < 4; copy++) {
        blocks.add(
          BlockModel(
            value: value,
            id: 'block-$value-$copy',
          ),
        );
      }
    }
    return blocks;
  }

  static List<BlockModel> _buildStandardPool() => buildStandardPool();

  void _shuffle(List<BlockModel> pile) {
    for (var i = pile.length - 1; i > 0; i--) {
      final j = _rng.nextInt(i + 1);
      final tmp = pile[i];
      pile[i] = pile[j];
      pile[j] = tmp;
    }
  }

  /// Removes [count] blocks from the top of the shuffled pool and returns them.
  List<BlockModel> drawBlocks(int count) {
    if (count < 0) {
      throw ArgumentError.value(count, 'count', 'must not be negative');
    }
    if (count > _pool.length) {
      throw StateError(
        'drawBlocks($count) requested but only ${_pool.length} remain.',
      );
    }
    final drawn = _pool.sublist(_pool.length - count);
    _pool.removeRange(_pool.length - count, _pool.length);
    return drawn;
  }
}
