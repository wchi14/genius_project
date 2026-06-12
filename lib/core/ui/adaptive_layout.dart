import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Layout fractions and helpers live here so game UIs stay adaptive without
/// scattering magic numbers. Sizes derive from [MediaQuery] and local
/// [LayoutBuilder] constraints.
abstract final class AdaptiveLayout {
  /// Playing-card width ÷ height (Blind Bluff + shared felt math).
  static const double blindBluffPlayingCardWidthRatio = 0.72;

  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static double shortestSide(BuildContext context) =>
      screenSize(context).shortestSide;

  static double longestSide(BuildContext context) =>
      screenSize(context).longestSide;

  /// Horizontal / vertical padding for full-screen game bodies.
  static EdgeInsets screenPadding(BuildContext context) {
    final s = shortestSide(context);
    final h = s * 0.028;
    final v = s * 0.018;
    return EdgeInsets.symmetric(horizontal: h, vertical: v);
  }

  /// Space between major sections (header vs content, rows of controls).
  static double sectionGap(BuildContext context) =>
      shortestSide(context) * 0.022;

  /// Space between inline items (chips, timer, small rows).
  static double inlineGap(BuildContext context) =>
      shortestSide(context) * 0.014;

  /// After the final hand resolves, hold on the hand-result screen before match summary.
  static const Duration blindBluffMatchSummaryDelay = Duration(seconds: 5);

  /// Dialog margin from screen edges.
  static EdgeInsets dialogInsets(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.symmetric(
      horizontal: s * 0.06,
      vertical: s * 0.05,
    );
  }

  /// Inner padding for dialog / card panels.
  static EdgeInsets panelPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.all(s * 0.045);
  }

  /// True when a vertical region is short relative to the device (e.g. felt
  /// strip above bottom rail in landscape).
  static bool tightVerticalRegion(double regionHeight, BuildContext context) {
    final ref = shortestSide(context);
    if (ref <= 0) {
      return true;
    }
    return regionHeight < ref * 0.34;
  }

  /// Felt inner padding from local max height.
  static double feltInnerPadding(double regionMaxHeight) =>
      math.max(regionMaxHeight * 0.018, 0);

  /// Card height inside a seat row from that row's layout box.
  static double feltCardHeight(double rowMaxHeight) => rowMaxHeight * 0.48;

  /// Avatar radius inside a seat row.
  static double feltAvatarRadius(double rowMaxHeight, double rowMaxWidth) =>
      math.min(rowMaxHeight * 0.22, rowMaxWidth * 0.08);

  /// Avatar radius for felt corner seats: keeps label + chips + avatar within
  /// [cornerBlockMaxWidth] beside a corner card column.
  static double feltCornerAvatarRadius({
    required double cornerBlockMaxWidth,
    required double cardHeight,
    required double stackHeight,
  }) {
    final cardW = cardHeight * blindBluffPlayingCardWidthRatio;
    final rowBudget = math.max(0.0, cornerBlockMaxWidth - cardW);
    final fromLayout = feltAvatarRadius(
      math.max(cardHeight * 1.2, stackHeight * 0.08),
      math.max(rowBudget * 0.55, cornerBlockMaxWidth * 0.18),
    );
    final cap = cornerBlockMaxWidth * 0.13;
    return math.min(fromLayout, cap).clamp(
      cornerBlockMaxWidth * 0.028,
      cornerBlockMaxWidth * 0.11,
    );
  }

  /// Whether pot widget should use compact typography.
  static bool potCompact(double potRegionMaxHeight, double potRegionMaxWidth) =>
      potRegionMaxHeight < potRegionMaxWidth * 0.28;

  /// Padding from [Stack] edges inside the Fatal Fold felt (after header row).
  static double feltStackEdge(double stackWidth, double stackHeight) =>
      math.max(math.min(stackWidth, stackHeight) * 0.018, 0);

  /// Max size of a corner seat block (fraction of shorter stack side).
  static double feltCornerBlockMax(double stackWidth, double stackHeight) {
    final s = math.min(stackWidth, stackHeight);
    return s * 0.5;
  }

  /// Playing card height for corner-mounted seats (uses stack size only).
  static double feltCornerCardHeight({
    required double stackWidth,
    required double stackHeight,
    required bool tightVerticalRegion,
  }) {
    final layoutMin = math.min(stackWidth, stackHeight);
    final hFrac = tightVerticalRegion ? 0.18 : 0.24;
    const wFrac = 0.15;
    final fromStack = math.min(stackHeight * hFrac, stackWidth * wFrac);
    final floor = layoutMin * (tightVerticalRegion ? 0.11 : 0.095);
    return math.max(floor, fromStack);
  }

  /// Minimum height for Fatal Fold bottom rail (skills or betting) so the felt
  /// [Expanded] height does not jump between phases.
  static double blindBluffBottomRailMinHeight(BuildContext context) =>
      shortestSide(context) * 0.26;

  // --- Blind Bluff: Fatal Fold felt (fractions live here, not in widgets) ---

  /// Horizontal inset for the felt [Container] margin (clamped vs region height).
  static double blindBluffFeltHorizontalInset(
    BuildContext context,
    double regionMaxHeight,
  ) {
    final base = shortestSide(context) * 0.022;
    return math.min(base, regionMaxHeight * 0.06);
  }

  /// Top margin for the felt [Container] is [horizontalInset] × this factor.
  static double blindBluffFeltTopMarginFactor(bool tightVerticalRegion) =>
      tightVerticalRegion ? 0.18 : 0.35;

  /// Inner vertical padding inside the felt [ClipRRect] (clamps [feltInnerPadding]).
  static double blindBluffFeltInnerPaddingY(
    double baseFeltInnerPadding,
    double regionMaxHeight,
  ) =>
      math.min(baseFeltInnerPadding, regionMaxHeight * 0.05);

  /// Gap under felt header before the green [Stack].
  static double blindBluffFeltHeaderStackGap(
    BuildContext context,
    bool tightVerticalRegion,
  ) =>
      sectionGap(context) * (tightVerticalRegion ? 0.18 : 0.35) * 0.45;

  /// Max height for a bottom corner seat column (fraction of stack height).
  static double blindBluffFeltCornerColumnMaxHeight(
    double stackHeight,
    bool tightVerticalRegion,
  ) =>
      stackHeight * (tightVerticalRegion ? 0.52 : 0.58);

  /// Max height for the top-centered rival up-card column in the stack.
  static double blindBluffFeltOpponentTopColumnMaxHeight(
    double stackHeight,
    bool tightVerticalRegion,
  ) =>
      stackHeight * (tightVerticalRegion ? 0.52 : 0.6);

  /// Estimated line height for the “Opponent card” caption above the up-card.
  static double blindBluffFeltOpponentCaptionHeight(double labelFontSize) =>
      labelFontSize * 1.28;

  /// Space between “Opponent card” caption and the card.
  static double blindBluffFeltOpponentCaptionCardGap(BuildContext context) =>
      inlineGap(context) * 0.4;

  /// Space below rival up-card before the centered pot band begins.
  static double blindBluffFeltCardPotGap(BuildContext context) =>
      inlineGap(context) * 0.22;

  /// Top inset for the pot band: below rival caption + card in the stack.
  static double blindBluffFeltPotBandTop({
    required BuildContext context,
    required double stackEdge,
    required double opponentCaptionHeight,
    required double cardHeight,
  }) {
    return stackEdge +
        opponentCaptionHeight +
        blindBluffFeltOpponentCaptionCardGap(context) +
        cardHeight +
        blindBluffFeltCardPotGap(context);
  }

  /// Bottom inset for the pot band: reserves seat block (label + chips + inline
  /// spent-skill glyphs on the same row as chips).
  static double blindBluffFeltPotBandBottom({
    required BuildContext context,
    required double stackEdge,
    required double avatarRadius,
  }) {
    final ig = inlineGap(context);
    final body = Theme.of(context).textTheme.labelLarge?.fontSize ?? 14.0;
    final labelLine = body * 1.35;
    final chipRow = avatarRadius * 1.35 + ig * 0.5;
    return stackEdge +
        labelLine +
        blindBluffFeltSeatLabelChipGap(context) +
        math.max(chipRow, ig * 2.2) +
        ig * 0.25;
  }

  /// Horizontal gap between pot row icons and labels.
  static double blindBluffFeltPotRowElementGap(BuildContext context) =>
      shortestSide(context) * 0.012;

  /// Corner radius for up-cards / hole cards on the felt.
  static double blindBluffPlayingCardBorderRadius(double cardHeight) =>
      cardHeight * 0.1;

  static double blindBluffPlayingCardShadowBlur(BuildContext context) =>
      shortestSide(context) * 0.02;

  static Offset blindBluffPlayingCardShadowOffset(BuildContext context) {
    final s = shortestSide(context) * 0.012;
    return Offset(s, s * 1.33);
  }

  static double blindBluffPlayingCardRankFontSize(
    double cardHeight,
    BuildContext context,
  ) =>
      (cardHeight * 0.38).clamp(
        shortestSide(context) * 0.04,
        shortestSide(context) * 0.085,
      );

  static double blindBluffPlayingCardJokerLogoSize(double cardHeight) =>
      cardHeight * 0.52;

  /// Minimum vertical space kept for the pot band between top/bottom reserves.
  static double blindBluffFeltPotBandMidMinHeight(BuildContext context) =>
      inlineGap(context) * 4.5;

  /// Max width for the centered pot block.
  static double blindBluffFeltPotBlockMaxWidth({
    required double stackWidth,
    required double stackEdge,
    required double cornerBlockMax,
  }) {
    final wFrac = stackWidth * 0.42;
    final clearance = stackWidth - 2 * stackEdge - cornerBlockMax * 0.35;
    return math.min(wFrac, clearance);
  }

  static double blindBluffFeltHeaderTimerGap(BuildContext context) =>
      inlineGap(context) * 0.45;

  /// Round-pill border radius for the R# chip in the felt header.
  static double blindBluffFeltRoundPillRadius(BuildContext context) =>
      inlineGap(context) * 1.45;

  /// Shadow blur under the felt panel (scales with device).
  static double blindBluffFeltPanelShadowBlur(BuildContext context) =>
      shortestSide(context) * 0.035;

  /// Shadow offset under the felt panel.
  static Offset blindBluffFeltPanelShadowOffset(BuildContext context) {
    final s = shortestSide(context) * 0.012;
    return Offset(s, s * 1.6);
  }

  /// Border width for the felt outer frame.
  static double blindBluffFeltFrameBorderWidth(BuildContext context) =>
      math.max(shortestSide(context) * 0.0035, 1.5);

  /// Inner clip radius tracks outer radius minus border.
  static double blindBluffFeltInnerClipRadius(
    BuildContext context,
    double outerRadius,
  ) =>
      math.max(outerRadius - blindBluffFeltFrameBorderWidth(context), 0);

  /// Outer rounded rect radius for the felt [Container].
  static double blindBluffFeltOuterRadius(BuildContext context) =>
      inlineGap(context) * 1.55;

  /// Gap between seat label and chip+skill row.
  static double blindBluffFeltSeatLabelChipGap(BuildContext context) =>
      inlineGap(context) * 0.15;

  /// Gap between chip stack and inline skill icons.
  static double blindBluffFeltSeatChipSkillGap(BuildContext context) =>
      inlineGap(context) * 0.45;

  /// Inline spent-skill icon size factor (multiplies [inlineGap]).
  static double blindBluffFeltSeatSkillIconSize(
    BuildContext context,
    bool tightVerticalRegion,
  ) =>
      inlineGap(context) * (tightVerticalRegion ? 1.05 : 1.22);

  /// Padding inside each spent-skill glyph.
  static double blindBluffFeltSeatSkillGlyphPadding(BuildContext context) =>
      inlineGap(context) * 0.32;

  /// Spacing between inline skill glyphs.
  static double blindBluffFeltSeatSkillSpacing(BuildContext context) =>
      inlineGap(context) * 0.35;

  /// Extra vertical gap when spent skills wrap to a second line (non-inline).
  static double blindBluffFeltSeatSkillRunSpacing(BuildContext context) =>
      inlineGap(context) * 0.28;

  /// Drafting / grid corner label size from available layout.
  static double gridLabelExtent(double layoutShortestExtent) =>
      layoutShortestExtent * 0.075;

  /// Matrix grid cell gutter from shortest layout side in the grid area.
  static double matrixCellGutter(double gridShortestExtent) =>
      math.max(gridShortestExtent * 0.012, 0);

  /// Showdown playing card height from parent constraints.
  static double showdownCardHeight(double maxWidth, double maxHeight) =>
      math.min(maxWidth * 0.22, maxHeight * 0.35);

  /// Duel grid + list side-by-side when width allows.
  static bool duelWideLayout(double layoutMaxWidth, BuildContext context) {
    final s = shortestSide(context);
    if (s <= 0) {
      return false;
    }
    return layoutMaxWidth >= s * 1.35;
  }

  /// Body text scale for dense summaries (respects text scale).
  static double summaryFontSize(
    BuildContext context, {
    required bool compact,
  }) {
    final raw = Theme.of(context).textTheme.bodySmall?.fontSize ??
        Theme.of(context).textTheme.bodyMedium?.fontSize ??
        12.0;
    final factor = compact ? 0.9 : 1.0;
    return MediaQuery.textScalerOf(context).scale(raw * factor);
  }

  // -------------------- Hub (non-game) layout --------------------

  /// Constrained max width for hub screens (mode/game/difficulty selection).
  static double hubMaxWidth(BuildContext context) {
    final s = shortestSide(context);
    // Phone landscape wants a tighter column; tablets can go wider.
    return s >= 900 ? 920 : 760;
  }

  /// Outer padding for hub screens.
  static EdgeInsets hubPadding(BuildContext context) {
    final s = shortestSide(context);
    final h = (s * 0.035).clamp(16.0, 26.0);
    final v = (s * 0.03).clamp(14.0, 24.0);
    return EdgeInsets.fromLTRB(h, v, h, h);
  }

  /// Spacing between major blocks on hub screens.
  static double hubSectionGap(BuildContext context) =>
      (shortestSide(context) * 0.03).clamp(12.0, 18.0);

  /// Spacing between inline elements on hub screens.
  static double hubInlineGap(BuildContext context) =>
      (shortestSide(context) * 0.02).clamp(10.0, 14.0);

  /// Inner padding for hub cards/tiles.
  static EdgeInsets hubCardPadding(BuildContext context) {
    final s = shortestSide(context);
    final a = (s * 0.03).clamp(14.0, 18.0);
    return EdgeInsets.all(a);
  }

  /// True when hub should use multi-column layout.
  static bool hubWideLayout(double maxWidth, BuildContext context) {
    final s = shortestSide(context);
    return maxWidth >= math.max(560, s * 0.85);
  }

  /// Standard hub icon tile size.
  static double hubIconExtent(BuildContext context) =>
      (shortestSide(context) * 0.07).clamp(36.0, 44.0);

  /// Standard small radius for hub icon containers.
  static double hubIconRadius(BuildContext context) =>
      (hubIconExtent(context) * 0.3).clamp(10.0, 14.0);

  /// Standard button height for hub tiles.
  static double hubButtonHeight(BuildContext context) =>
      (shortestSide(context) * 0.08).clamp(38.0, 44.0);

  // -------------------- Match & Void (landscape play) --------------------

  /// Inset around the full play surface (grid + log).
  static EdgeInsets matchVoidPlayInsets(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.fromLTRB(
      s * 0.02,
      s * 0.012,
      s * 0.02,
      s * 0.018,
    );
  }

  /// Gap between the 3×3 grid and action buttons / log divider.
  static double matchVoidPanelGap(BuildContext context) =>
      shortestSide(context) * 0.018;

  /// Corner radius for card tiles and history panel.
  static double matchVoidCardRadius(BuildContext context) =>
      shortestSide(context) * 0.028;

  /// HUD bar height (mode, timer, score).
  static double matchVoidHudHeight(BuildContext context) =>
      shortestSide(context) * 0.09;

  /// Selection ring width on [MatchCardWidget].
  static double matchVoidSelectionBorder(BuildContext context) =>
      shortestSide(context) * 0.008;

  /// Scale when a card is selected.
  static double matchVoidSelectedScale(BuildContext context) =>
      1.0 + shortestSide(context) * 0.00045;

  /// Mini history card size (width = height).
  static double matchVoidHistoryCardExtent(BuildContext context) =>
      shortestSide(context) * 0.11;

  /// Inner padding for triangle symbols (0.5% of viewport width / height).
  static EdgeInsets matchVoidTriangleViewportInset(BuildContext context) {
    final size = screenSize(context);
    return EdgeInsets.symmetric(
      horizontal: size.width * 0.005,
      vertical: size.height * 0.005,
    );
  }

  /// VOID label size inside the action button.
  static double matchVoidVoidButtonTitleSize(BuildContext context) =>
      shortestSide(context) * 0.028;

  /// Penalty subtitle under VOID on the action button.
  static double matchVoidVoidButtonSubtitleSize(BuildContext context) =>
      shortestSide(context) * 0.02;

  /// Warning color for VOID penalty level (0 = calm … 4+ = hot).
  static Color matchVoidVoidPenaltyColor(int level) {
    if (level <= 0) {
      return const Color(0xFFFFFFFF);
    }
    if (level == 1) {
      return const Color(0xFFFFEB3B);
    }
    if (level <= 3) {
      return const Color(0xFFFF9800);
    }
    return const Color(0xFFFF5252);
  }

  // -------------------- Apex Equation (landscape play) --------------------

  static EdgeInsets apexPlayInsets(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.fromLTRB(
      s * 0.02,
      s * 0.012,
      s * 0.02,
      s * 0.018,
    );
  }

  static double apexPanelGap(BuildContext context) =>
      shortestSide(context) * 0.02;

  /// Horizontal padding for the right column (shifts content toward pyramid).
  static EdgeInsets apexRightPanelPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.fromLTRB(s * 0.035, 0, s * 0.018, 0);
  }

  static double apexPyramidRowGap(BuildContext context) =>
      shortestSide(context) * 0.02;

  static double apexTileGap(BuildContext context) =>
      shortestSide(context) * 0.024;

  /// Pyramid tile size that fits [regionWidth] × [regionHeight] (4×4 layout).
  static double apexPyramidTileExtent({
    required double regionWidth,
    required double regionHeight,
    required double tileGap,
    required double rowGap,
  }) {
    const tilesPerBottomRow = 4;
    const pyramidRows = 4;
    final byWidth =
        (regionWidth - tileGap * (tilesPerBottomRow - 1)) / tilesPerBottomRow;
    final byHeight =
        (regionHeight - rowGap * (pyramidRows - 1)) / pyramidRows;
    final fit = math.min(byWidth, byHeight);
    return fit * 0.94;
  }

  /// Inner padding inside a pyramid / slot tile from its side length.
  static EdgeInsets apexTileInnerPadding(double tileExtent) =>
      EdgeInsets.all(tileExtent * 0.1);

  static double apexTileBorderWidth(double tileExtent, {required bool selected}) =>
      tileExtent * (selected ? 0.022 : 0.012);

  /// Operator glyph size inside a tile ([emphasize] for pyramid readability).
  static double apexTileOperatorFontSize(
    double tileExtent, {
    bool emphasize = false,
  }) =>
      tileExtent * (emphasize ? 0.28 : 0.22);

  /// Value digit size inside a tile (slightly smaller when [emphasize] operator).
  static double apexTileValueFontSize(
    double tileExtent, {
    bool emphasize = false,
  }) =>
      tileExtent * (emphasize ? 0.3 : 0.34);

  static double apexTileSymbolGap(double tileExtent) => tileExtent * 0.035;

  static double apexTargetBoxExtent(BuildContext context) =>
      shortestSide(context) * 0.2;

  static double apexSelectionSlotExtent(BuildContext context) =>
      shortestSide(context) * 0.16;

  static double apexTileRadius(BuildContext context) =>
      shortestSide(context) * 0.024;

  static double apexConfirmButtonHeight(BuildContext context) =>
      (shortestSide(context) * 0.09).clamp(40.0, 52.0);

  static EdgeInsets apexHudChipPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.symmetric(horizontal: s * 0.02, vertical: s * 0.012);
  }

  static double apexHudChipBorderWidth(BuildContext context) =>
      shortestSide(context) * 0.0025;

  /// Blind Cup: Liar's dice play surface outer padding.
  static EdgeInsets bluffCupPlayInsets(BuildContext context) =>
      screenPadding(context);

  /// Gap between dice in a cup row.
  static double bluffCupDiceGap(BuildContext context) => inlineGap(context);

  /// Square die chip in the player / opponent rows.
  static double bluffCupDieExtent(BuildContext context) =>
      shortestSide(context) * 0.11;

  /// Slightly smaller dice on the post-round result table.
  static double bluffCupResultDieScale() => 0.78;

  /// Caps [bluffCupDieExtent] so [diceCount] dice + gaps fit [rowMaxWidth] and
  /// each die fits [rowMaxHeight] (avoids Row / Column overflow on small devices).
  static double bluffCupDieExtentForRow({
    required BuildContext context,
    required double rowMaxWidth,
    required double rowMaxHeight,
    int diceCount = 6,
  }) {
    final gap = bluffCupDiceGap(context);
    final base = bluffCupDieExtent(context);
    if (rowMaxWidth <= 0 || rowMaxHeight <= 0) {
      return math.min(base, shortestSide(context) * 0.07);
    }
    final perDieWidth =
        (rowMaxWidth - gap * (diceCount - 1)) / math.max(1, diceCount);
    final lo = shortestSide(context) * 0.042;
    return math.max(
      lo,
      math.min(base, math.min(perDieWidth, rowMaxHeight)),
    );
  }

  /// Result-table die size (smaller than in-play dice).
  static double bluffCupResultDieExtentForRow({
    required BuildContext context,
    required double rowMaxWidth,
    required double rowMaxHeight,
    int diceCount = 6,
  }) {
    return bluffCupDieExtentForRow(
          context: context,
          rowMaxWidth: rowMaxWidth,
          rowMaxHeight: rowMaxHeight,
          diceCount: diceCount,
        ) *
        bluffCupResultDieScale();
  }

  static double bluffCupDieRadius(BuildContext context) =>
      shortestSide(context) * 0.018;

  /// Share of the **inner** play-area height for the opponent’s green felt strip.
  static double bluffCupPlayAreaOpponentZoneFraction() => 0.38;

  /// Share of the inner play-area height for the current-bid panel.
  static double bluffCupPlayAreaBidZoneFraction() => 0.32;

  /// Corner radius for the opponent’s green felt **rectangle** (nearly square).
  static double bluffCupOpponentFeltRadius(BuildContext context) =>
      shortestSide(context) * 0.01;

  static double bluffCupFeltBorderWidth(BuildContext context) =>
      shortestSide(context) * 0.004;

  static double bluffCupRailRadius(BuildContext context) =>
      shortestSide(context) * 0.022;

  static double bluffCupChipIconSize(BuildContext context) =>
      shortestSide(context) * 0.04;

  static double bluffCupShowdownIconSize(BuildContext context) =>
      shortestSide(context) * 0.14;

  /// Compact icon on the match game-over overlay.
  static double bluffCupGameOverIconSize(BuildContext context) =>
      shortestSide(context) * 0.085;

  /// How long the post-round dice reveal overlay stays before the next hand.
  static Duration bluffCupRoundRevealDuration() =>
      const Duration(seconds: 5);

  /// Extra overlay after the 4th round win before starting a new match.
  static Duration bluffCupMatchGameOverDuration() =>
      const Duration(seconds: 5);

  /// Round-start banner: who bids first this round.
  static Duration bluffCupRoundOpenerDuration() =>
      const Duration(seconds: 2);

  /// Round-indicator dots (best-of-seven track) in Blind Cup.
  static double bluffCupRoundDotExtent(BuildContext context) =>
      shortestSide(context) * 0.028;

  static double bluffCupRoundDotGap(BuildContext context) =>
      inlineGap(context) * 0.55;

  /// Raise-bid sheet height as a fraction of screen height (unchanged when shifting up).
  static double bluffCupRaiseBidPanelScreenHeightFraction() => 0.58;

  /// Space reserved at the bottom so the raise-bid sheet clears the player rail.
  static double bluffCupRaiseBidBottomClearance(BuildContext context) {
    final pad = panelPadding(context);
    final die = bluffCupDieExtent(context);
    final gap = sectionGap(context);
    final railBody = pad.top * 0.65 * 2 + die;
    return railBody + gap;
  }

  // --- Blind Count 40 (portrait 1v1 column) ---

  static int blindCountTopSectionFlex() => 3;

  static int blindCountMidSectionFlex() => 2;

  static int blindCountBottomSectionFlex() => 4;

  static double blindCountBlockGap(BuildContext context) => inlineGap(context);

  /// Square block size for a horizontal row of [blockCount] tiles.
  static double blindCountBlockExtent(
    BuildContext context, {
    required double rowMaxWidth,
    required int blockCount,
  }) {
    final gap = blindCountBlockGap(context);
    final count = math.max(blockCount, 1);
    final available = math.max(rowMaxWidth - gap * (count - 1), 0);
    final per = available / count;
    final cap = shortestSide(context) * 0.13;
    final floor = shortestSide(context) * 0.065;
    return per.clamp(floor, cap);
  }

  static double blindCountMainTimerFontSize(BuildContext context) =>
      shortestSide(context) * 0.13;

  static double blindCountSkillPeekTimerFontSize(BuildContext context) =>
      shortestSide(context) * 0.09;

  static double blindCountCapFlashBorderWidth(BuildContext context) =>
      shortestSide(context) * 0.01;

  static double blindCountPanelRadius(BuildContext context) =>
      shortestSide(context) * 0.022;

  static const int blindCountGuessGridColumns = 5;

  static double blindCountGuessGridGap(BuildContext context) => inlineGap(context);

  /// Square cell size for [blindCountGuessGridColumns] buttons in one row.
  static double blindCountGuessGridCellExtentForWidth(
    BuildContext context,
    double rowWidth,
  ) {
    final gap = blindCountGuessGridGap(context);
    const columns = blindCountGuessGridColumns;
    final available = rowWidth - gap * (columns - 1);
    final per = available / columns;
    final cap = shortestSide(context) * 0.16;
    final floor = shortestSide(context) * 0.1;
    return per.clamp(floor, cap);
  }

  static double blindCountGuessGridFontSize(double cellExtent) => cellExtent * 0.42;

  // --- Sniper Poker (landscape — mirrors Blind Bluff felt + bottom rail) ---

  /// Minimum bottom rail height (same reserve as Fatal Fold so felt does not jump).
  static double sniperBottomRailMinHeight(BuildContext context) =>
      blindBluffBottomRailMinHeight(context);

  static double sniperPanelRadius(BuildContext context) =>
      blindBluffFeltOuterRadius(context);

  static double sniperCardGap(BuildContext context) => inlineGap(context);

  /// Sniper card width ÷ height ([SniperCardWidget] uses 0.62 × 0.88 of extent).
  static const double sniperPlayingCardWidthRatio = 0.62 * 0.88;

  /// Card height that fits [cardCount] cards in a row without overflowing.
  /// No minimum floor — parent [FittedBox] / [SizedBox] must supply tight bounds.
  static double sniperCardHeightForRow({
    required BuildContext context,
    required double rowMaxWidth,
    required double rowMaxHeight,
    required int cardCount,
    double extraWidthSlots = 0,
  }) {
    if (cardCount <= 0 || rowMaxWidth <= 0 || rowMaxHeight <= 0) return 0;
    final gap = sniperCardGap(context);
    final slots = cardCount + extraWidthSlots;
    final gaps = slots > 1 ? gap * (slots - 1) : 0.0;
    final fromWidth =
        (rowMaxWidth - gaps) / (slots * sniperPlayingCardWidthRatio);
    return math.min(fromWidth, rowMaxHeight);
  }

  /// Community row — biased larger than corner hole cards when space allows.
  static double sniperCommunityCardHeight({
    required BuildContext context,
    required double rowMaxWidth,
    required double rowMaxHeight,
  }) {
    if (rowMaxHeight <= 0 || rowMaxWidth <= 0) return 0;
    final base = sniperCardHeightForRow(
      context: context,
      rowMaxWidth: rowMaxWidth,
      rowMaxHeight: rowMaxHeight,
      cardCount: 4,
    );
    final boosted = base * 1.35;
    return math.min(boosted, rowMaxHeight * 0.92);
  }

  /// Hole cards at felt corners — matches Fatal Fold corner scale.
  static double sniperFeltHoleCardHeight({
    required double stackWidth,
    required double stackHeight,
    required bool tightVerticalRegion,
  }) {
    return feltCornerCardHeight(
      stackWidth: stackWidth,
      stackHeight: stackHeight,
      tightVerticalRegion: tightVerticalRegion,
    ) *
        (tightVerticalRegion ? 0.82 : 0.9);
  }

  /// Community row on the felt center band.
  static double sniperFeltCommunityCardHeight({
    required double stackWidth,
    required double stackHeight,
    required bool tightVerticalRegion,
  }) {
    return sniperFeltHoleCardHeight(
      stackWidth: stackWidth,
      stackHeight: stackHeight,
      tightVerticalRegion: tightVerticalRegion,
    ) *
        0.95;
  }

  static double sniperPotFontSize(BuildContext context) =>
      longestSide(context) * 0.024;

  static double sniperLogFontSize(BuildContext context) =>
      longestSide(context) * 0.02;

  static double sniperSkillIconSize(BuildContext context) =>
      shortestSide(context) * 0.038;

  static double sniperShowdownIconSize(BuildContext context) =>
      longestSide(context) * 0.08;

  static double sniperJackpotFontSize(BuildContext context) =>
      longestSide(context) * 0.032;

  // -------------------- Landscape split shell --------------------

  /// Width ÷ height below which the right panel uses a wider flex share.
  static const double landscapeSplitAspectBreakpoint = 1.5;

  static const int landscapeSplitLeftFlexWide = 7;
  static const int landscapeSplitRightFlexWide = 3;
  static const int landscapeSplitLeftFlexNarrow = 2;
  static const int landscapeSplitRightFlexNarrow = 1;

  static double landscapeSplitGap(BuildContext context, BoxConstraints constraints) {
    final ref = math.min(constraints.maxWidth, constraints.maxHeight);
    return ref * 0.012;
  }

  /// Horizontal edge inset for [LandscapeSplitShell].
  ///
  /// Reads [MediaQuery.padding] but softens left/right on ultrawide notch-phones
  /// (22:9) where full SafeArea horizontal padding can push edge CTAs too far
  /// inward. Vertical safe-area is still handled by [SafeArea] on the shell.
  static EdgeInsets landscapeSplitHorizontalInsets(BuildContext context) {
    final media = MediaQuery.of(context);
    final padding = media.padding;
    final aspectRatio = media.size.width / media.size.height;
    final ref = shortestSide(context);

    final minClearance = ref * 0.014;
    final maxClearance = ref * 0.04;

    final horizontalScale = aspectRatio >= 2.15
        ? 0.5
        : aspectRatio >= 1.85
            ? 0.65
            : aspectRatio >= 1.5
                ? 0.85
                : 1.0;

    double edgeInset(double systemInset) {
      if (systemInset <= 0) {
        return minClearance;
      }
      return (systemInset * horizontalScale).clamp(minClearance, maxClearance);
    }

    return EdgeInsets.only(
      left: edgeInset(padding.left),
      right: edgeInset(padding.right),
    );
  }

  // -------------------- Progression lobby --------------------

  static EdgeInsets lobbyScreenPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.fromLTRB(
      s * 0.028,
      s * 0.018,
      s * 0.028,
      s * 0.022,
    );
  }

  static double lobbySectionGap(BuildContext context) =>
      shortestSide(context) * 0.022;

  static double lobbyInlineGap(BuildContext context) =>
      shortestSide(context) * 0.014;

  static EdgeInsets lobbyListPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.symmetric(horizontal: s * 0.012, vertical: s * 0.008);
  }

  static double lobbyCardGap(BuildContext context) =>
      shortestSide(context) * 0.022;

  static double lobbyGameCardWidth(BuildContext context, BoxConstraints region) {
    final h = region.maxHeight;
    final w = region.maxWidth;
    final fromHeight = h * 0.72;
    final fromWidth = w * 0.28;
    return math.min(fromHeight * 0.78, math.max(fromWidth, h * 0.42));
  }

  static EdgeInsets lobbyCardPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.all(s * 0.028);
  }

  static double lobbyGameCardRadius(BuildContext context) =>
      shortestSide(context) * 0.028;

  static double lobbyGameCardIconExtent(BuildContext context) =>
      shortestSide(context) * 0.11;

  static double lobbyLockIconSize(BuildContext context) =>
      shortestSide(context) * 0.065;

  static double lobbyCardShadowBlur(BuildContext context) =>
      shortestSide(context) * 0.018;

  static double lobbyCardShadowOffset(BuildContext context) =>
      shortestSide(context) * 0.006;

  static EdgeInsets lobbyHudChipPadding(BuildContext context) {
    final s = shortestSide(context);
    return EdgeInsets.symmetric(horizontal: s * 0.022, vertical: s * 0.014);
  }

  static double lobbyHudChipRadius(BuildContext context) =>
      shortestSide(context) * 0.022;

  static double lobbyHudIconSize(BuildContext context) =>
      shortestSide(context) * 0.038;

  static double lobbyXpBarHeight(BuildContext context) =>
      shortestSide(context) * 0.012;

  static double lobbyHudCompactBreakpoint(BuildContext context) =>
      longestSide(context) * 0.52;
}
