import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genius_project/games/apex_equation/logic/apex_game_state.dart';
import 'package:genius_project/games/apex_equation/logic/board_generator.dart';
import 'package:genius_project/games/apex_equation/logic/math_evaluator.dart';
import 'package:genius_project/games/apex_equation/models/apex_game_mode.dart';
import 'package:genius_project/games/apex_equation/models/equation_tile.dart';

/// Tile pool + target for one level.
typedef ApexLevelData = ({List<EquationTile> tiles, int target});

/// Produces the next level (defaults to [BoardGenerator.generateLevel]).
typedef ApexLevelGenerator = ApexLevelData Function(Random random);

/// Arena (15 levels) and Countdown (60s) presenter for Apex Equation.
class ApexGameCubit extends Cubit<ApexGameState> {
  ApexGameCubit({
    required ApexGameMode mode,
    Random? random,
    List<EquationTile>? initialTiles,
    int? initialTarget,
    int initialLevel = 1,
    ApexLevelGenerator? levelGenerator,
  })  : _random = random ?? Random(),
        _levelGenerator = levelGenerator ?? _defaultLevelGenerator,
        super(
          _initialState(
            mode,
            random,
            initialTiles,
            initialTarget,
            initialLevel,
          ),
        ) {
    if (mode == ApexGameMode.countdown) {
      _startCountdownTimer();
    } else {
      _startArenaElapsedTimer();
    }
  }

  static const int countdownStartSeconds = 60;
  static const int arenaLevelCount = 15;
  static const int maxWrongTriesBeforeAutoSkip = 5;

  final Random _random;
  final ApexLevelGenerator _levelGenerator;
  Timer? _timer;

  static ApexLevelData _defaultLevelGenerator(Random random) {
    final map = BoardGenerator.generateLevel(random: random);
    return (
      tiles: map[BoardGenerator.levelTilesKey]! as List<EquationTile>,
      target: map[BoardGenerator.levelTargetKey]! as int,
    );
  }

  static ApexGameState _initialState(
    ApexGameMode mode,
    Random? random,
    List<EquationTile>? initialTiles,
    int? initialTarget,
    int initialLevel,
  ) {
    final level = _levelFromBoardOrTarget(
      random: random,
      tiles: initialTiles,
      target: initialTarget,
    );

    return ApexGameState(
      mode: mode,
      currentLevel: initialLevel,
      availableTiles: level.tiles,
      targetNumber: level.target,
      selectedTiles: const [],
      currentScore: 0,
      remainingSeconds:
          mode == ApexGameMode.countdown ? countdownStartSeconds : 0,
      currentWrongTries: 0,
      isGameOver: false,
    );
  }

  static ApexLevelData _levelFromBoardOrTarget({
    Random? random,
    List<EquationTile>? tiles,
    int? target,
  }) {
    if (tiles != null && target != null) {
      return (tiles: tiles, target: target);
    }
    return _defaultLevelGenerator(random ?? Random());
  }

  ApexLevelData _nextLevel() => _levelGenerator(_random);

  /// Countdown time bonus after solving [level] (1-based).
  static int countdownTimeBonusForLevel(int level) {
    if (level <= 5) {
      return 30;
    }
    if (level <= 10) {
      return 25;
    }
    if (level <= 15) {
      return 20;
    }
    return 15;
  }

  void clearWrongAnswerFlash() {
    if (!state.wrongAnswerFlash) {
      return;
    }
    _emit(state.copyWith(wrongAnswerFlash: false));
  }

  void selectTile(EquationTile tile) {
    if (state.isGameOver) {
      return;
    }
    if (!_tileOnBoard(tile)) {
      return;
    }
    if (state.selectedTiles.any((t) => t.id == tile.id)) {
      return;
    }
    if (state.selectedTiles.length >= 3) {
      return;
    }

    _emit(
      state.copyWith(
        selectedTiles: [...state.selectedTiles, tile],
        wrongAnswerFlash: false,
      ),
    );
  }

  void deselectTile(EquationTile tile) {
    if (state.isGameOver) {
      return;
    }
    final next = state.selectedTiles.where((t) => t.id != tile.id).toList();
    if (next.length == state.selectedTiles.length) {
      return;
    }
    _emit(state.copyWith(selectedTiles: next));
  }

  void submitAnswer() {
    if (state.isGameOver || state.selectedTiles.length != 3) {
      return;
    }

    final tiles = state.selectedTiles;
    final result = MathEvaluator.evaluate(tiles[0], tiles[1], tiles[2]);

    if (result != null && result == state.targetNumber) {
      _applyCorrectAnswer();
      return;
    }

    final wrongTries = state.currentWrongTries + 1;
    if (wrongTries >= maxWrongTriesBeforeAutoSkip) {
      _applyAutoSkip();
      return;
    }

    _emit(
      state.copyWith(
        currentWrongTries: wrongTries,
        selectedTiles: const [],
        wrongAnswerFlash: true,
      ),
    );
  }

  void _applyCorrectAnswer() {
    _advanceToNextLevel(awardPoint: true);
  }

  void _applyAutoSkip() {
    _advanceToNextLevel(awardPoint: false);
  }

  void _advanceToNextLevel({required bool awardPoint}) {
    final solvedLevel = state.currentLevel;
    final nextLevel = solvedLevel + 1;
    var score = state.currentScore;
    var seconds = state.remainingSeconds;
    var gameOver = false;

    if (awardPoint) {
      score += 1;
      if (state.mode == ApexGameMode.countdown) {
        seconds += countdownTimeBonusForLevel(solvedLevel);
      }
    }

    if (state.mode == ApexGameMode.arena && nextLevel > arenaLevelCount) {
      gameOver = true;
    }

    final levelData = gameOver
        ? (tiles: state.availableTiles, target: state.targetNumber)
        : _nextLevel();

    _emit(
      state.copyWith(
        currentLevel: _levelAfterAdvance(nextLevel, gameOver),
        availableTiles: levelData.tiles,
        targetNumber: levelData.target,
        selectedTiles: const [],
        currentWrongTries: 0,
        currentScore: score,
        remainingSeconds: seconds,
        isGameOver: gameOver,
        wrongAnswerFlash: false,
      ),
    );

    if (gameOver) {
      _cancelTimer();
    }
  }

  /// Arena HUD stays at level [arenaLevelCount] when the run ends.
  int _levelAfterAdvance(int nextLevel, bool gameOver) {
    if (gameOver && state.mode == ApexGameMode.arena) {
      return arenaLevelCount;
    }
    return nextLevel;
  }

  bool _tileOnBoard(EquationTile tile) {
    return state.availableTiles.any((t) => t.id == tile.id);
  }

  void _startCountdownTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onCountdownTick();
    });
  }

  void _startArenaElapsedTimer() {
    _cancelTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _onArenaElapsedTick();
    });
  }

  void _onCountdownTick() {
    if (state.isGameOver || state.mode != ApexGameMode.countdown) {
      _cancelTimer();
      return;
    }

    final next = state.remainingSeconds - 1;
    if (next <= 0) {
      _emit(
        state.copyWith(
          remainingSeconds: 0,
          isGameOver: true,
          selectedTiles: const [],
        ),
      );
      _cancelTimer();
      return;
    }
    _emit(state.copyWith(remainingSeconds: next));
  }

  void _onArenaElapsedTick() {
    if (state.isGameOver || state.mode != ApexGameMode.arena) {
      return;
    }
    _emit(state.copyWith(remainingSeconds: state.remainingSeconds + 1));
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _emit(ApexGameState next) {
    if (isClosed) {
      return;
    }
    emit(next);
  }

  @override
  Future<void> close() {
    _cancelTimer();
    return super.close();
  }
}
