# ASMR / SFX assets for [AudioHapticManager]

Place short, low-latency clips here (MP3 or WAV). Expected filenames:

- `card_flip.mp3`
- `dice_shake.mp3`
- `deal_cards.mp3`
- `clock_tick.mp3`
- `high_pressure_alarm.mp3`
- `chip_stack.mp3`
- `success_chime.mp3`

The manager preloads these on startup and degrades gracefully if a file is missing.
