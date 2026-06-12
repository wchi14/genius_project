import 'dart:collection';

import 'package:genius_project/games/blind_count_40/ai/blind_count_opponent_ai_config.dart';
import 'package:genius_project/games/blind_count_40/models/block_model.dart';

/// Where a remembered block left play (observable to the AI seat).
enum BlindCountDiscardSource {
  /// Revealed/discarded from the human player's hand (AI guessed right).
  playerHand,

  /// Revealed/discarded from the AI's own hand (human guessed right).
  ownHand,
}

/// One block in [BlindCountOpponentMemory.memoryPool] (newest last).
class BlindCountMemoryPoolBlock {
  const BlindCountMemoryPoolBlock({
    required this.value,
    required this.source,
    this.blockId,
  });

  final int value;
  final BlindCountDiscardSource source;

  /// May be absent if the AI only recalls the value.
  final String? blockId;
}

/// A guess announced at the table (player or AI).
class BlindCountGuessMemory {
  const BlindCountGuessMemory({
    required this.value,
    required this.wasCorrect,
    required this.matchCount,
    required this.byPlayer,
  });

  final int value;
  final bool wasCorrect;
  final int matchCount;

  /// `true` when the human (P1) guessed; `false` when the AI guessed.
  final bool byPlayer;
}

/// Imperfect recall: sliding [memoryPool] + separate guess buffers.
class BlindCountOpponentMemory {
  BlindCountOpponentMemory({
    this.memoryPoolSize = 10,
    this.maxPlayerGuesses = 8,
    this.maxOwnGuesses = 6,
  });

  factory BlindCountOpponentMemory.fromConfig(BlindCountOpponentAiConfig config) =>
      BlindCountOpponentMemory(
        memoryPoolSize: config.memoryPoolSize,
        maxPlayerGuesses: config.maxPlayerGuessMemory,
        maxOwnGuesses: config.maxOwnGuessMemory,
      );

  /// Spec: `memory_pool` max length (older blocks are forgotten).
  final int memoryPoolSize;
  final int maxPlayerGuesses;
  final int maxOwnGuesses;

  final Queue<BlindCountMemoryPoolBlock> _memoryPool = Queue();
  final Queue<BlindCountGuessMemory> _playerGuesses = Queue();
  final Queue<BlindCountGuessMemory> _ownGuesses = Queue();

  /// Values the AI should not re-guess until the human row gains a new block.
  final Set<int> _bannedUntilPlayerRefill = <int>{};

  Set<int> get bannedUntilPlayerRefill => Set.unmodifiable(_bannedUntilPlayerRefill);

  void banUntilPlayerRefill(int value) {
    if (value < 1 || value > 10) return;
    _bannedUntilPlayerRefill.add(value);
  }

  void clearBansOnPlayerRefill() {
    _bannedUntilPlayerRefill.clear();
  }

  /// `memory_pool` — last [memoryPoolSize] blocks revealed/discarded (FIFO).
  UnmodifiableListView<BlindCountMemoryPoolBlock> get memoryPool =>
      UnmodifiableListView(_memoryPool);

  @Deprecated('Use memoryPool')
  UnmodifiableListView<BlindCountMemoryPoolBlock> get recentDiscards =>
      memoryPool;

  UnmodifiableListView<BlindCountGuessMemory> get recentPlayerGuesses =>
      UnmodifiableListView(_playerGuesses);

  /// `player_last_guess` — the human's most recent guess (1–10), if any.
  int? get playerLastGuess =>
      _playerGuesses.isEmpty ? null : _playerGuesses.last.value;

  UnmodifiableListView<BlindCountGuessMemory> get recentOwnGuesses =>
      UnmodifiableListView(_ownGuesses);

  void recordDiscardsFromPlayerHand(Iterable<int> values) {
    _pushValues(values, BlindCountDiscardSource.playerHand);
  }

  void recordDiscardsFromOwnHand(Iterable<int> values) {
    _pushValues(values, BlindCountDiscardSource.ownHand);
  }

  void recordRevealedFromPlayerHand(Iterable<BlockModel> blocks) {
    _pushBlocks(blocks, BlindCountDiscardSource.playerHand);
  }

  void recordRevealedFromOwnHand(Iterable<BlockModel> blocks) {
    _pushBlocks(blocks, BlindCountDiscardSource.ownHand);
  }

  void _pushBlocks(Iterable<BlockModel> blocks, BlindCountDiscardSource source) {
    for (final block in blocks) {
      _pushEntry(
        BlindCountMemoryPoolBlock(
          value: block.value,
          source: source,
          blockId: block.id,
        ),
      );
    }
  }

  void _pushValues(Iterable<int> values, BlindCountDiscardSource source) {
    for (final value in values) {
      _pushEntry(
        BlindCountMemoryPoolBlock(value: value, source: source),
      );
    }
  }

  void _pushEntry(BlindCountMemoryPoolBlock entry) {
    _memoryPool.addLast(entry);
    while (_memoryPool.length > memoryPoolSize) {
      _memoryPool.removeFirst();
    }
  }

  void recordPlayerGuess({
    required int value,
    required bool wasCorrect,
    required int matchCount,
  }) {
    _playerGuesses.addLast(
      BlindCountGuessMemory(
        value: value,
        wasCorrect: wasCorrect,
        matchCount: matchCount,
        byPlayer: true,
      ),
    );
    while (_playerGuesses.length > maxPlayerGuesses) {
      _playerGuesses.removeFirst();
    }
  }

  void recordOwnGuess({
    required int value,
    required bool wasCorrect,
    required int matchCount,
  }) {
    _ownGuesses.addLast(
      BlindCountGuessMemory(
        value: value,
        wasCorrect: wasCorrect,
        matchCount: matchCount,
        byPlayer: false,
      ),
    );
    while (_ownGuesses.length > maxOwnGuesses) {
      _ownGuesses.removeFirst();
    }
  }
}
