import 'package:genius_project/core/models/coordinate.dart';

import 'player_draft_manager.dart';

/// Every distinct valid **four-cell adjacent straight** segment on a 5×5 board
/// (axis-aligned and diagonal, king-step spacing), in canonical reading order.
///
/// Used by AI drafting and simulations; geometry matches [PlayerDraftManager].
List<List<Coordinate>> allValidFourCellLines() {
  bool inBounds(Coordinate c) =>
      c.x >= 0 && c.x <= 4 && c.y >= 0 && c.y <= 4;

  const dirs = <(int, int)>[
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
    (1, 1),
    (1, -1),
    (-1, 1),
    (-1, -1),
  ];

  final seen = <String>{};
  final lines = <List<Coordinate>>[];

  for (var sx = 0; sx < 5; sx++) {
    for (var sy = 0; sy < 5; sy++) {
      for (final d in dirs) {
        final cells = <Coordinate>[
          for (var k = 0; k < 4; k++)
            Coordinate(sx + k * d.$1, sy + k * d.$2),
        ];
        if (!cells.every(inBounds)) continue;
        if (cells.toSet().length != 4) continue;

        final canonical = PlayerDraftManager.readingOrder(cells);
        final key = canonical.map((e) => '${e.x}:${e.y}').join(',');
        if (seen.add(key)) {
          lines.add(canonical);
        }
      }
    }
  }

  return lines;
}
