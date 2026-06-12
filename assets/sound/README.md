# Sound assets — `assets/sound/`

All files used by `AudioHapticService` / `SoundAssetPaths`.
Place MP3s (preferred) or WAVs directly in this folder.

## BGM tracks (loop)

| File | Used for |
|------|----------|
| `evening.mp3` | Lobby track 1 (random) |
| `starting_out_waltz_vivace.mp3` | Lobby track 2 (random) |
| `too_cool.mp3` | In-game BGM (chill games) |
| `hackbeat.mp3` | In-game BGM (intense games) |

## SFX (preloaded, low-latency pool)

| File | Trigger method |
|------|---------------|
| `game_over.mp3` | `playGameOver()` |
| `error.mp3` | `playError()` |
| `success.mp3` | `playSuccess()` |
| `tick_tock.mp3` | `playTickTock()` |
| `wrong.mp3` | `playWrong()` |
| `game_win.mp3` | `playGameWin()` |
| `sniper_shot.mp3` | `playSniperShot()` |

## Recommended sources (royalty-free)

- **FreeMusicArchive** — search for the exact track names above.
- **OpenGameArt.org** — SFX packs under CC0/CC-BY.
- **Mixkit** — free game SFX (no attribution required).

## pubspec.yaml registration

```yaml
flutter:
  assets:
    - assets/sound/
```

The service degrades gracefully if a file is missing (debug log only).
