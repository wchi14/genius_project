import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Low-latency ASMR-style feedback for game interactions.
///
/// Call [preloadCommonAssets] once during app startup. Audio files live under
/// `assets/audio/` (see [AudioAssetPaths]).
class AudioHapticManager {
  AudioHapticManager._();

  static final AudioHapticManager instance = AudioHapticManager._();

  final AudioPlayer _player = AudioPlayer();
  final Map<String, Source> _preloadedSources = {};
  bool _preloaded = false;

  /// Preloads common short SFX into memory for instant playback.
  Future<void> preloadCommonAssets() async {
    if (_preloaded) {
      return;
    }
    await _player.setReleaseMode(ReleaseMode.stop);
    await _player.setPlayerMode(PlayerMode.lowLatency);

    for (final path in AudioAssetPaths.all) {
      try {
        final source = AssetSource(path);
        await _player.setSource(source);
        _preloadedSources[path] = source;
      } on Object catch (e, st) {
        if (kDebugMode) {
          debugPrint('AudioHapticManager: skip preload $path — $e\n$st');
        }
      }
    }
    _preloaded = true;
  }

  Future<void> dispose() async {
    await _player.dispose();
    _preloadedSources.clear();
    _preloaded = false;
  }

  // ---- Audio ----

  Future<void> playCardFlip() => _playAsset(AudioAssetPaths.cardFlip);

  Future<void> playDiceShake() => _playAsset(AudioAssetPaths.diceShake);

  Future<void> playDealCards() => _playAsset(AudioAssetPaths.dealCards);

  Future<void> playClockTick() => _playAsset(AudioAssetPaths.clockTick);

  Future<void> playHighPressureAlarm() =>
      _playAsset(AudioAssetPaths.highPressureAlarm);

  Future<void> playChipStack() => _playAsset(AudioAssetPaths.chipStack);

  Future<void> playSuccessChime() => _playAsset(AudioAssetPaths.successChime);

  Future<void> _playAsset(String assetPath) async {
    final source = _preloadedSources[assetPath] ?? AssetSource(assetPath);
    try {
      await _player.stop();
      await _player.play(source);
    } on Object catch (e) {
      if (kDebugMode) {
        debugPrint('AudioHapticManager: play failed $assetPath — $e');
      }
    }
  }

  // ---- Haptics ----

  /// Standard UI taps and lightweight selections.
  Future<void> hapticTap() => HapticFeedback.lightImpact();

  /// Successful moves, confirmations, and positive outcomes.
  Future<void> hapticSuccess() => HapticFeedback.mediumImpact();

  /// Dangerous events: sniper hits, penalties, fold losses.
  Future<void> hapticDanger() => HapticFeedback.heavyImpact();

  /// Rapid warning ticks (e.g. final seconds on a turn timer).
  Future<void> hapticWarningTicks({
    int count = 3,
    Duration interval = const Duration(milliseconds: 120),
  }) async {
    for (var i = 0; i < count; i++) {
      await HapticFeedback.heavyImpact();
      if (i < count - 1) {
        await Future<void>.delayed(interval);
      }
    }
  }

  /// Combined audio + haptic for common game beats.
  Future<void> feedbackCardFlip() async {
    unawaited(playCardFlip());
    await hapticTap();
  }

  Future<void> feedbackDiceShake() async {
    unawaited(playDiceShake());
    await hapticTap();
  }

  Future<void> feedbackSuccess() async {
    unawaited(playSuccessChime());
    await hapticSuccess();
  }

  Future<void> feedbackDanger() async {
    unawaited(playHighPressureAlarm());
    await hapticDanger();
  }
}

/// Asset paths relative to the `assets/` folder in [pubspec.yaml].
abstract final class AudioAssetPaths {
  static const cardFlip = 'audio/card_flip.mp3';
  static const diceShake = 'audio/dice_shake.mp3';
  static const dealCards = 'audio/deal_cards.mp3';
  static const clockTick = 'audio/clock_tick.mp3';
  static const highPressureAlarm = 'audio/high_pressure_alarm.mp3';
  static const chipStack = 'audio/chip_stack.mp3';
  static const successChime = 'audio/success_chime.mp3';

  static const List<String> all = [
    cardFlip,
    diceShake,
    dealCards,
    clockTick,
    highPressureAlarm,
    chipStack,
    successChime,
  ];
}
