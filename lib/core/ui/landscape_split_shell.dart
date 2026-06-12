import 'package:flutter/material.dart';

import 'package:genius_project/core/ui/adaptive_layout.dart';

/// Universal landscape play shell: game board (left) + controls / log (right).
///
/// Lives in `lib/core/ui/` alongside other shared layout primitives
/// ([AdaptiveLayout], [HubScaffold]). Game screens wrap their play surface as:
///
/// ```dart
/// LandscapeSplitShell(
///   leftPanel: /* board, grid, felt */,
///   rightPanel: /* actions, log, skills */,
/// )
/// ```
///
/// Flex split is aspect-ratio aware:
/// - **&lt; 1.5** (boxy tablet / iPad): **2 : 1** — wider right rail.
/// - **≥ 1.5** (phone / ultrawide): **7 : 3** — board-heavy split.
///
/// Horizontal insets are derived from [MediaQuery.padding] with ultrawide
/// softening so edge buttons stay thumb-reachable without hugging the bezel.
class LandscapeSplitShell extends StatelessWidget {
  const LandscapeSplitShell({
    super.key,
    required this.leftPanel,
    required this.rightPanel,
  });

  /// Game boards, grid matrices, poker tables, pyramids, etc.
  final Widget leftPanel;

  /// Action controls, logs, skill panels, betting rails, etc.
  final Widget rightPanel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final aspectRatio = constraints.maxWidth / constraints.maxHeight;
        final narrow =
            aspectRatio < AdaptiveLayout.landscapeSplitAspectBreakpoint;
        final leftFlex = narrow
            ? AdaptiveLayout.landscapeSplitLeftFlexNarrow
            : AdaptiveLayout.landscapeSplitLeftFlexWide;
        final rightFlex = narrow
            ? AdaptiveLayout.landscapeSplitRightFlexNarrow
            : AdaptiveLayout.landscapeSplitRightFlexWide;
        final gap = AdaptiveLayout.landscapeSplitGap(context, constraints);
        final horizontalInsets =
            AdaptiveLayout.landscapeSplitHorizontalInsets(context);

        return SafeArea(
          left: false,
          right: false,
          child: Padding(
            padding: horizontalInsets,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(flex: leftFlex, child: leftPanel),
                SizedBox(width: gap),
                Expanded(flex: rightFlex, child: rightPanel),
              ],
            ),
          ),
        );
      },
    );
  }
}
