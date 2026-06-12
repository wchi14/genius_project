# Agent / Cursor notes — genius_project

Flutter hub app (**Genius Project**) hosting multiple mini-games under `lib/games/<game_id>/`.

**Authoritative conventions for the AI:** `.cursor/rules/` — start with `genius-architecture.mdc` (always applied) and `flutter-dart-style.mdc` when editing `lib/**/*.dart`.

## Games (current)

| `gameId` | Notes |
|----------|--------|
| `matrix_poker_25` | Hub → difficulty → `/play/...` (AI) |
| `blind_bluff_fatal_fold` | `/games/blind_bluff_fatal_fold/play` |
| `match_and_void` | `/games/match_and_void/mode` → arena / countdown |
| `apex_equation` | `/games/apex_equation/mode` → arena / countdown |
| `bluff_cup` | **Blind Cup: Liar's dice** — `/games/bluff_cup/play`; best-of-7 rounds (first to 4), **30s** `p1` turn timer |
| `blind_count_40` | **Blind Count 40** — `/games/blind_count_40/play`; portrait 1v1 PvE, **20s** turn timer, 3 skills (once/match) |
| `sniper_poker` | **Sniper Poker** — `/games/sniper_poker/play`; heads-up PvE, **15s** P1 turn timer, skills → flop bet → river bet → sniper |

Heavy game UI is **deferred** via `lib/core/routing/lazy_game_screens.dart`. Hub screens stay in `lib/core/ui/`.

## Hub & routing

- **Router:** `lib/core/routing/app_router.dart` — `createAppRouter()`; wired from `lib/main.dart` (`GeniusApp` + `MaterialApp.router`).
- **Hub navigation:** use `context.push(...)` on hub screens (no global nav wrapper). Nested game routes live under `/games/...`.
- **Do not** preload all deferred libraries on startup (blocks the UI thread in debug on slow emulators).

**Quick pointers:**

- Hub UI: `lib/core/ui/` (`HubScaffold`, `GameSelectionScreen`, `ModeSelectionScreen`)
- Adaptive sizing: `lib/core/ui/adaptive_layout.dart`
- Package name: `genius_project` (`pubspec.yaml`)

## UI product requirements (hub + games)

### Adaptive design (no hardcoded layout)

- **No magic numbers** for spacing/sizing/breakpoints in UI.
  - Prefer deriving sizes from `MediaQuery`/constraints using `AdaptiveLayout`.
  - If a new spacing/size is needed, **add a helper** in `lib/core/ui/adaptive_layout.dart` and reuse it.
- **Landscape-first**: assume landscape is common; layouts should use horizontal space well.
  - Prefer **grids / multi-column** layouts on wide widths.
  - Avoid tall, single-column stacks of buttons when there is room.

### Visual polish (less “default Flutter”)

- **Typography**: clear hierarchy; not “boring defaults”. Prefer `Theme.of(context).textTheme` or **extent-based `TextStyle`** when tile size is fixed.
- **Buttons**: consistent shape/padding; avoid mismatched styles per screen.
- **Cards/tiles**: use icon + short subtitle + clear CTA; keep copy concise.

### Known issues to prevent regressions

- **Blind Bluff: Fatal Fold overflow**: the bottom rail (skills / betting) must **never be removed** mid-round just to show an intro — reserve the same vertical space from the first frame (skills rail visible but disabled during ante/deal intro). Use a shared **minimum rail height** (`AdaptiveLayout.blindBluffBottomRailMinHeight`) for skills and betting so the felt `Expanded` region does not jump in height between phases.
  - Felt layout: prefer a **Stack** (pot center, opponent top-right, you bottom-left, summary strip) with `FittedBox` / constraint-derived sizes so the felt does not overflow when the rail is present.
- **Hub CTAs**: do not wrap hub action buttons in a **fixed-height** box; labels like “Choose difficulty” must be allowed to use **two lines** when narrow.

### Match & Void

- Triangle symbols use **viewport inset** (`AdaptiveLayout.matchVoidTriangleViewportInset`, 0.5% vw/vh) so glyphs do not touch the card edge.

### Apex Equation

- **Logic:** `lib/games/apex_equation/logic/` — `BoardGenerator`, `MathEvaluator`, `ApexGameCubit` + freezed `ApexGameState`.
- **Modes:** `countdown` (60s, +time on correct solve by level band) and `arena` (15 levels; 5 wrong tries → auto-skip level without score).
- **Play UI:** `lib/games/apex_equation/ui/apex_game_screen.dart` — landscape **5:4** row: pyramid (10 tiles, 1+2+3+4 rows) | right panel (HUD, target, 3 slots, CONFIRM).
- **Pyramid tiles:** size via `AdaptiveLayout.apexPyramidTileExtent` from **width and height** constraints (4 tiles bottom row); do not grow past fit. Use `EquationTileWidget(emphasizeOperator: true)` on the pyramid for larger operator glyphs and slightly smaller values (same outer tile size).
- **Right panel:** center-aligned in the column; padding via `AdaptiveLayout.apexRightPanelPadding` (shift toward pyramid, not flush to screen edge). HUD chips (score / level / time) use bordered containers (`apexHudChipPadding`, etc.).
- **First selection slot:** operator is ignored in math — show strikethrough / muted operator in UI (`ignoreOperator: true`).

### Blind Count 40

- **Route:** `/games/blind_count_40/play` — portrait 1v1 (local seat = **P1**; opponent = **P2** AI).
- **Logic:** `lib/games/blind_count_40/logic/` — `BlindCountCubit` + freezed `BlindCountState`, `CountEngine`, `BlockPoolManager`.
- **UI:** `lib/games/blind_count_40/ui/blind_count_screen.dart` — top/mid/bottom split; block tiles use `BlindCountBlockTile` + vanish/reveal/spawn animations tracked in `_trackBlockAnimations`.
- **Skills (UI labels):** **Sum**, **Duplicate**, **Add Block** (`BlindCountSkillId.labelSum` / `labelDuplicate` / `labelAddBlock`). Each skill **once per match**; at most **one skill per turn** (`hasUsedSkillThisTurn`).

#### Turn rules

- **Turn start (before first guess):** `[Add block]` or `[Guess number]` — mutually exclusive with guessing.
- **After a correct guess (combo):** `[Stop guessing]` or `[Guess number]` — no add block mid-combo.
- **Correct guess:** removes all opponent blocks matching the guessed value (AoE via `CountEngine.processGuess`); +1 per match; combo accumulates on same turn.
- **All-clear bonus:** **+3** when a correct guess empties the opponent row (`allClearBonus` in cubit).
- **Wrong guess:** ends turn; combo penalty (−1 if combo > 0).
- **Refill:** when a turn **ends** (wrong guess / stop / timeout), refill the **other** seat to **5** blocks if below 5 and pool allows.
- **8-block cap:** cannot add block when opponent already has 8.
- **Pool empty:** show both hand sums in HUD (`p1HandSumWhenPoolEmpty` / `p2HandSumWhenPoolEmpty`); match can end if a seat is cleared with no refill (`isTerminalNoRefill`).

#### Correct-guess animation timing (symmetric removal)

- Overlay hold: `BlindCountCubit.wrongGuessOverlayDelay` (**1500ms**).
- **Keep `isResolvingGuess: true`** until blocks are actually removed — do **not** clear it mid-timer or the next AI action can cancel removal.
- **P1 correct:** after overlay, wait `correctRevealAnimDelay` (**780ms**) for opponent reveal, then remove opponent blocks.
- **P2 correct:** after overlay, remove player blocks **immediately** (vanish animation starts as soon as overlay is gone).
- UI schedules next opponent action only when `!isResolvingGuess` (see `_scheduleOpponentTurn`).

#### PvE AI (`lib/games/blind_count_40/ai/`)

- **`BlindCountOpponentAi`** — instance class holding `config`, `memory`, and `decide()` / `decideFromState()`. Wired from `BlindCountCubit` via optional `opponentAiConfig`.
- **`BlindCountOpponentAiConfig`** — all tunables (memory sizes, §2 weights, §3 thresholds, §4 skill triggers, combo-stop odds). `createMemory()` builds `BlindCountOpponentMemory` with configured FIFO sizes.
- **§1 inputs:** `BlindCountAiInputs` — `ai_hand`, `player_block_count`, `memory_pool`, `player_last_guess`, `playerHandSumRevealed` (endgame). AI must **not** read hidden P1 block values.
- **§2 guessing:** `BlindCountGuessAlgorithm` — base weight 40, deductions, noise; pick **highest** weight (random tie-break). Endgame sum feasibility filter; banned wrong guesses until P1 refill when pool empty.
- **§3 action matrix:** `BlindCountActionMatrix` — Rule 1: cap → guess; Rule 2: top weight ≥ 30 → guess; Rule 3: else 70% bloat / 30% guess.
- **§4 skills:** `BlindCountSkillTrigger` — Sum (≤4 blocks, pool < 15), Duplicate Radar (≥5 blocks + planned guess), Force Bloat (exactly 7 blocks).
- **Memory:** `BlindCountOpponentMemory` — default `memoryPoolSize` **10**; guess buffers 8/6; `bannedUntilPlayerRefill` for known-wrong values when pool empty.

#### Regressions to prevent

- **P2 correct → P1 blocks must vanish** after overlay (not stay on screen); guard `isResolvingGuess` through removal.
- **Blind Bluff bottom-rail height jump** does not apply here, but **do not remove** the action rail mid-round to fit overlays — reserve space from frame 1.
- **Skill peek:** opponent skill shows notification overlay; P1 skill shows secret intel for 3s (`skillPeekSeconds`).

### Sniper Poker

- **Route:** `/games/sniper_poker/play` — landscape heads-up (local seat = **P1**; opponent = **P2** AI). Deferred via `lazy_game_screens.dart`.
- **Logic:** `lib/games/sniper_poker/logic/` — `SniperMatchCubit` + freezed `SniperMatchState`, `PokerEvaluator` (best 4 of 6), `SniperEngine`, `SniperPotSettlement`, `SniperDeck` (40-card shoe, values 1–10 × four suits).
- **AI:** `lib/games/sniper_poker/ai/sniper_opponent_ai.dart` — equity-based betting (1–3 BB raises, shove when short), deck enumeration for sniper targets, avoids self-snipe. Wired from cubit via `_runOpponentIfNeeded()` (UI must **not** drive P2 separately).
- **UI:** `lib/games/sniper_poker/ui/sniper_poker_screen.dart` — felt layout (Blind Bluff–style corners), full-width bottom rail, compact cards (rank + suit top-left), `SniperShowdownOverlay` (5s table recap), `_SniperGameOverOverlay` when busted.

#### Hand flow

1. **Skills** — each skill once per match; starter acts first (~2s banner). Skills: **Kevlar Vest** / **Flashbang** (block opponent sniper on river), **Wide Lens** (sniper ±1 on `primaryValue`).
2. **Flop betting** (`betting1`) — 2 community cards dealt at hand start.
3. **River betting** (`betting2`) — +2 community cards (4 total on board).
4. **Sniper** — declare **sniper** (rank + value 1–10) or **shotgun** (rank only); shotgun cooldown **2 hands** after use. PASS allowed. Starter acts first each phase; **15s** P1 timer resets each P1 turn.
5. **Showdown** — auto after both lock sniper; **5s** overlay then next hand (or game-over overlay if busted).

Turn starter **random hand 1**, then **alternates** each hand (`handStarter` / `nextHandStarter`).

#### Betting / stacks

- Start **50** chips each, ante **1** (doubles every **10** hands). Partial ante: post `min(stack, ante)`; short stack can be all-in at deal.
- Raises: min **1** chip; max = stack minus amount to call (`maxRaiseFor`). Calls pay `min(toCall, stack)`.
- **All-in:** when both seats all-in, **fast-forward** betting (deal river if needed, enter sniper) — do not hang on “Opponent is thinking…”.
- **Pot awards:** `SniperPotSettlement` — short stack only wins matched pot; unmatched chips return to deeper player (side-pot style). Ties refund each investment.
- **Game over:** when either player has **≤ 0 chips** after a hand; show overlay (not silent pop). Cannot start a hand with 0 chips.

#### Sniper / shotgun rules

- Best hand: strongest **4-card** subset from 2 hole + 4 community (`PokerEvaluator.evaluateBestFour`).
- **Sniper hit:** rank match + exact `primaryValue` (±1 if attacker has Wide Lens).
- **Shotgun hit:** rank match only. Loser’s successful shotgun vs winner → **hedge** (`_applyPotAward`): half of loser investment to winner, half to `carryOverPot`.
- **Self-snipe:** if your own sniper declaration matches **your** hand, you are sniped (lose) unless **both** players are sniped (then normal hand comparison).
- **Jackpot +10:** winner has premium hand (four of a kind / straight flush) uncountered, or sniper jackpot path on loser premium hand.

#### Result overlay (`SniperShowdownOverlay`)

- **5s** table: hands, chips with delta, skill/target lines.
- **Chip deltas:** zero-sum except jackpot — account for `carryInAtHandStart` / `carryOverPot` (`_computeDisplayChipDeltas`).
- Labels: **Sniped** (red, victim row when opponent’s sniper hit); **Shotgun** (orange, declarer row when shotgun hit winner’s hand but declarer lost pot).

#### Regressions to prevent

- **Opponent AI:** must act immediately when P2’s turn (`_runOpponentIfNeeded` after phase advance); no duplicate AI triggers from UI listeners.
- **Both all-in:** never leave `actingPlayer == p2` on a betting street with P2 at 0 chips — call `_fastForwardBettingIfBothAllIn`.
- **Bottom rail:** reserve height from frame 1; full-width action buttons; do not remove rail for overlays.
- **Showdown sequence:** on match end, show hand recap **then** game-over overlay (`dismissHandRecap` after 5s hold).

### Assets / logos

- Prefer **iconography/logos** over plain text headers where appropriate.
- If generating images isn’t possible in the current model, provide a plan:
  - Use `flutter_launcher_icons` / `flutter_gen` or a simple `assets/images/` pipeline.
  - Provide SVG/PNG asset names and where to wire them in hub tiles and app bar.

## Tooling / codegen

- After editing `@freezed` types: `dart run build_runner build --delete-conflicting-outputs`
- Analyzer: `flutter analyze`
- Tests: `flutter test` (e.g. `test/apex_equation_test.dart`, `test/apex_game_cubit_test.dart`, `test/hub_navigation_test.dart`, `test/blind_count_*_test.dart`, `test/sniper_pot_settlement_test.dart`, `test/sniper_self_snipe_test.dart`)

## Emulator / debug (Windows + gphone)

- First **debug** launch on `gphone16k` can take 15–30s (JIT); `Skipped N frames` / `Davey!` in log is common.
- **`FlutterRenderer: Width is zero`** on startup is usually **harmless** if the hub eventually paints.
- If hub taps seem dead but the app looks fine: prefer **Cold Boot** on the AVD over **Wipe Data** every session. Wipe fixes corrupted emulator GPU/Quick Boot snapshots, not bad app persistence (this app does not save hub state).
- End a session with **`q`** in `flutter run`, then **`flutter run`** again after native/manifest changes (not hot reload only).
- `MainActivity` uses **TextureView** for some virtgpu emulators (`android/.../MainActivity.kt`).
- For snappier interaction: `flutter run --profile` or a physical device.
