import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// ---------------------------------------------------------------------------
// AudioHapticService
// ---------------------------------------------------------------------------

/// BGM + SFX + haptic singleton for the game hub.
///
/// Call [initialize] once after [WidgetsFlutterBinding.ensureInitialized].
/// Volume is controlled via [bgmVolume] and [sfxVolume] [ValueNotifier]s —
/// bind them directly to UI sliders for real-time adjustment.
///
/// Asset paths live in [SoundAssetPaths]; files belong under `assets/sound/`.
class AudioHapticService {
  AudioHapticService._();

  static final AudioHapticService instance = AudioHapticService._();

  // ---- Players -----------------------------------------------------------

  /// Dedicated looping player for background music.
  final AudioPlayer _bgmPlayer = AudioPlayer();

  /// One dedicated low-latency player per SFX file — true preloading.
  final Map<String, AudioPlayer> _sfxPool = {};

  // ---- Volume state ------------------------------------------------------

  /// Background-music master volume (0.0 – 1.0). Bind to a UI slider.
  final ValueNotifier<double> bgmVolume = ValueNotifier<double>(0.70);

  /// Sound-effect master volume (0.0 – 1.0). Bind to a UI slider.
  final ValueNotifier<double> sfxVolume = ValueNotifier<double>(1.00);

  // ---- Internal state ----------------------------------------------------

  static const int _kFadeSteps = 20;

  /// Duration of the tick-tock SFX clip (5 s).
  /// The alert window is 10 s, so the clip plays twice back-to-back.
  static const Duration _kTickTockClipDuration = Duration(seconds: 5);

  /// Total countdown window that triggers the alert (10 s).
  static const Duration countdownAlertWindow = Duration(seconds: 10);

  bool _initialized = false;
  Timer? _fadeTimer;
  Timer? _countdownTimer;
  Completer<void>? _pendingFadeCompleter;
  String? _lastLobbyTrack;

  // ---- Lifecycle ---------------------------------------------------------

  /// Preloads all SFX into native player pools and wires volume listeners.
  ///
  /// Safe to call multiple times (no-op after first call).
  Future<void> initialize() async {
    if (_initialized) return;

    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.setVolume(bgmVolume.value);

    // FLAC files are not supported by Android SoundPool (lowLatency mode);
    // they use PlayerMode.mediaPlayer instead.
    for (final path in SoundAssetPaths.allSfx) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setPlayerMode(
        path.endsWith('.flac') ? PlayerMode.mediaPlayer : PlayerMode.lowLatency,
      );
      await player.setVolume(sfxVolume.value);
      try {
        await player.setSource(AssetSource(path));
      } on Object catch (e) {
        if (kDebugMode) debugPrint('AudioHapticService: preload skip $path — $e');
      }
      _sfxPool[path] = player;
    }

    bgmVolume.addListener(_onBgmVolumeChanged);
    sfxVolume.addListener(_onSfxVolumeChanged);
    _initialized = true;
  }

  Future<void> dispose() async {
    _fadeTimer?.cancel();
    _completePendingFade();
    stopCountdownAlert();
    bgmVolume.removeListener(_onBgmVolumeChanged);
    sfxVolume.removeListener(_onSfxVolumeChanged);
    await _bgmPlayer.dispose();
    for (final p in _sfxPool.values) {
      await p.dispose();
    }
    _sfxPool.clear();
    _initialized = false;
  }

  void _onBgmVolumeChanged() {
    unawaited(_bgmPlayer.setVolume(bgmVolume.value));
  }

  void _onSfxVolumeChanged() {
    for (final p in _sfxPool.values) {
      unawaited(p.setVolume(sfxVolume.value));
    }
  }

  /// Ensures the service is initialized before any playback method is called.
  /// Guards against call-sites that race ahead of [initialize].
  Future<void> _ensureInitialized() async {
    if (!_initialized) await initialize();
  }

  void _completePendingFade() {
    if (_pendingFadeCompleter != null && !_pendingFadeCompleter!.isCompleted) {
      _pendingFadeCompleter!.complete();
    }
  }

  // ---- BGM ---------------------------------------------------------------

  /// Starts looping lobby music, randomly alternating between the two lobby
  /// tracks and avoiding repeating the last played one.
  Future<void> playLobbyBGM() async {
    await _ensureInitialized();
    const tracks = SoundAssetPaths.lobbyTracks;
    final String track;
    if (tracks.length > 1 && _lastLobbyTrack != null) {
      final others = tracks.where((t) => t != _lastLobbyTrack).toList();
      track = others[math.Random().nextInt(others.length)];
    } else {
      track = tracks[math.Random().nextInt(tracks.length)];
    }
    _lastLobbyTrack = track;
    await _playBgm(track);
  }

  /// Fades out the current BGM, then starts an in-game track.
  ///
  /// Pass [gameId] (snake_case folder name) to pick a preferred track;
  /// omit for random selection from [SoundAssetPaths.inGameTracks].
  Future<void> playInGameBGM({String? gameId}) async {
    await _ensureInitialized();
    await stopBGM();
    await _playBgm(SoundAssetPaths.inGameTrackFor(gameId));
  }

  /// Fades out the active BGM over [fadeDuration] (default 1 second).
  ///
  /// Returns a [Future] that resolves when the fade and stop are complete.
  /// If called while a previous fade is in progress, the old fade resolves
  /// immediately and the new one begins.
  Future<void> stopBGM({
    Duration fadeDuration = const Duration(seconds: 1),
  }) {
    _fadeTimer?.cancel();
    _completePendingFade();

    final completer = Completer<void>();
    _pendingFadeCompleter = completer;

    final startVol = bgmVolume.value;
    final stepMs = (fadeDuration.inMilliseconds / _kFadeSteps).round();
    int step = 0;

    _fadeTimer = Timer.periodic(Duration(milliseconds: stepMs), (t) async {
      step++;
      final frac = 1.0 - step / _kFadeSteps;
      await _bgmPlayer.setVolume((startVol * frac).clamp(0.0, 1.0));
      if (step >= _kFadeSteps) {
        t.cancel();
        await _bgmPlayer.stop();
        await _bgmPlayer.setVolume(bgmVolume.value);
        if (!completer.isCompleted) completer.complete();
      }
    });

    return completer.future;
  }

  Future<void> _playBgm(String assetPath) async {
    await _bgmPlayer.setVolume(bgmVolume.value);
    await _bgmPlayer.play(AssetSource(assetPath));
  }

  // ---- SFX ---------------------------------------------------------------

  Future<void> playGameOver() => _playSfx(SoundAssetPaths.sfxGameOver);

  Future<void> playError() => _playSfx(SoundAssetPaths.sfxError);

  Future<void> playSuccess() => _playSfx(SoundAssetPaths.sfxSuccess);

  Future<void> playTickTock() => _playSfx(SoundAssetPaths.sfxTickTock);

  /// Starts the 10-second countdown alert.
  ///
  /// Call this exactly when the turn timer reaches [countdownAlertWindow]
  /// (10 seconds remaining). The 5-second clip plays immediately, then
  /// automatically repeats once after 5 s to cover the full window.
  ///
  /// Set [withHaptics] to `true` to also fire a heavy haptic alarm alongside
  /// the audio (useful for accessibility or tactile-heavy game moments).
  ///
  /// Always pair with [stopCountdownAlert] when the turn ends early so the
  /// second loop does not fire after the player has already acted.
  ///
  /// ```dart
  /// // In a game cubit, when the timer hits 10 s:
  /// AudioHapticService.instance.startCountdownAlert();
  ///
  /// // When player acts or turn times out:
  /// AudioHapticService.instance.stopCountdownAlert();
  /// ```
  Future<void> startCountdownAlert({bool withHaptics = false}) async {
    stopCountdownAlert(); // cancel any previous run first

    // First play — at 10 s remaining.
    await playTickTock();
    if (withHaptics) unawaited(triggerHeavyAlarm());

    // Second play — at 5 s remaining (after the 5-second clip finishes).
    _countdownTimer = Timer(_kTickTockClipDuration, () async {
      await playTickTock();
      if (withHaptics) unawaited(triggerHeavyAlarm());
    });
  }

  /// Cancels the pending second loop and silences the tick-tock player.
  ///
  /// Call on every turn end path: player action, correct guess, wrong guess,
  /// or natural timeout — whichever fires first.
  void stopCountdownAlert() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    // Stop the player immediately so the clip does not bleed into the
    // next turn or the result overlay.
    unawaited(
      _sfxPool[SoundAssetPaths.sfxTickTock]?.stop() ?? Future<void>.value(),
    );
  }

  Future<void> playWrong() => _playSfx(SoundAssetPaths.sfxWrong);

  Future<void> playGameWin() => _playSfx(SoundAssetPaths.sfxGameWin);

  Future<void> playSniperShot() => _playSfx(SoundAssetPaths.sfxSniperShot);

  Future<void> _playSfx(String assetPath) async {
    final player = _sfxPool[assetPath];
    if (player == null) {
      if (kDebugMode) debugPrint('AudioHapticService: no pool entry for $assetPath');
      return;
    }
    try {
      await player.stop();
      await player.play(AssetSource(assetPath));
    } on Object catch (e) {
      if (kDebugMode) debugPrint('AudioHapticService: SFX play failed $assetPath — $e');
    }
  }

  // ---- Haptic tracks -----------------------------------------------------

  /// Short, subtle click for standard buttons and menu selections.
  Future<void> triggerLightTap() => HapticFeedback.lightImpact();

  /// Double rapid buzz — correct answer, level-up, confirmed action.
  Future<void> triggerSuccessBuzz() async {
    await HapticFeedback.mediumImpact();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    await HapticFeedback.mediumImpact();
  }

  /// Continuous repetitive alarm — timeout, penalty, sniper hit.
  ///
  /// [pulses] controls how many heavy impacts fire back-to-back.
  Future<void> triggerHeavyAlarm({
    int pulses = 6,
    Duration interval = const Duration(milliseconds: 150),
  }) async {
    for (var i = 0; i < pulses; i++) {
      await HapticFeedback.heavyImpact();
      if (i < pulses - 1) {
        await Future<void>.delayed(interval);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// SoundAssetPaths
// ---------------------------------------------------------------------------

/// Canonical paths for all sound assets, relative to `assets/`.
///
/// All files live under `assets/sound/`. Register the folder in `pubspec.yaml`:
/// ```yaml
/// flutter:
///   assets:
///     - assets/sound/
/// ```
abstract final class SoundAssetPaths {
  // ---- BGM ----------------------------------------------------------------
  static const bgmEvening = 'sound/Evening.mp3';
  static const bgmStartingOutWaltzVivace = 'sound/Starting Out Waltz Vivace.mp3';
  static const bgmTooCool = 'sound/Too Cool.mp3';
  static const bgmHackbeat = 'sound/Hackbeat.mp3';

  // ---- SFX ----------------------------------------------------------------

  /// Player loses / game over screen.
  static const sfxGameOver = 'sound/76376__deleted_user_877451__game_over.wav';

  /// System error / invalid action message.
  static const sfxError = 'sound/142608__autistic-lucario__error.wav';

  /// Correct answer / win a round.
  static const sfxSuccess = 'sound/242501__gabrielaraujo__powerupsuccess.wav';

  /// Countdown timer running out.
  static const sfxTickTock = 'sound/487725__lilmati__ticking-timer-05-sec.wav';

  /// Wrong answer / incorrect guess.
  static const sfxWrong = 'sound/476177__unadamlar__wrong-choice.wav';

  /// Overall match victory.
  static const sfxGameWin = 'sound/615099__mlaudio__magic_game_win_success.wav';

  /// Sniper Poker — snipe lands successfully (FLAC; uses mediaPlayer mode).
  static const sfxSniperShot =
      'sound/855597__qubodup__barrett-m82a1-sniper-shot-from-wooden-platform-hanging-from-metal-chains-6.flac';

  // ---- Groups -------------------------------------------------------------

  /// Lobby BGM pool — randomly alternated, no immediate repeat.
  static const List<String> lobbyTracks = [
    bgmEvening,
    bgmStartingOutWaltzVivace,
  ];

  /// In-game BGM pool — used when no specific [gameId] mapping exists.
  static const List<String> inGameTracks = [
    bgmTooCool,
    bgmHackbeat,
  ];

  /// All SFX files — pre-loaded into the player pool at startup.
  static const List<String> allSfx = [
    sfxGameOver,
    sfxError,
    sfxSuccess,
    sfxTickTock,
    sfxWrong,
    sfxGameWin,
    sfxSniperShot,
  ];

  /// Returns the preferred in-game track for a known [gameId], falling back
  /// to a random selection from [inGameTracks].
  static String inGameTrackFor(String? gameId) {
    const map = <String, String>{
      'sniper_poker': bgmHackbeat,
      'blind_bluff_fatal_fold': bgmHackbeat,
      'matrix_poker_25': bgmHackbeat,
      'blind_count_40': bgmTooCool,
      'bluff_cup': bgmTooCool,
      'match_and_void': bgmTooCool,
      'apex_equation': bgmTooCool,
    };
    return map[gameId] ?? inGameTracks[math.Random().nextInt(inGameTracks.length)];
  }
}
