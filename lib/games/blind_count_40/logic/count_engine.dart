import '../models/block_model.dart';

/// Result keys for [CountEngine.processGuess].
abstract final class CountGuessResultKeys {
  static const isCorrect = 'isCorrect';
  static const matchingBlocks = 'matchingBlocks';
  static const remainingBlocks = 'remainingBlocks';
}

/// AoE flip logic: one guess can reveal every hidden block with that value.
class CountEngine {
  const CountEngine._();

  /// Scans [opponentHiddenBlocks] for all blocks with [guessedValue].
  ///
  /// When any match exists, returns `isCorrect: true`, the flipped
  /// [CountGuessResultKeys.matchingBlocks], and [CountGuessResultKeys.remainingBlocks]
  /// still hidden. When none match, returns `isCorrect: false` with an empty
  /// match list and the unchanged hidden list.
  static Map<String, dynamic> processGuess(
    List<BlockModel> opponentHiddenBlocks,
    int guessedValue,
  ) {
    if (guessedValue < 1 || guessedValue > 10) {
      throw ArgumentError.value(
        guessedValue,
        'guessedValue',
        'must be between 1 and 10',
      );
    }

    final matching = <BlockModel>[
      for (final block in opponentHiddenBlocks)
        if (block.value == guessedValue) block,
    ];

    if (matching.isEmpty) {
      return {
        CountGuessResultKeys.isCorrect: false,
        CountGuessResultKeys.matchingBlocks: const <BlockModel>[],
        CountGuessResultKeys.remainingBlocks:
            List<BlockModel>.from(opponentHiddenBlocks),
      };
    }

    final remaining = <BlockModel>[
      for (final block in opponentHiddenBlocks)
        if (block.value != guessedValue) block,
    ];

    return {
      CountGuessResultKeys.isCorrect: true,
      CountGuessResultKeys.matchingBlocks: matching,
      CountGuessResultKeys.remainingBlocks: remaining,
    };
  }
}
