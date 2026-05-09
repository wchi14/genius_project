import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:genius_project/games/matrix_poker_25/ui/matrix_poker_screen.dart';

void main() {
  testWidgets('Matrix Poker reaches Phase 1 board filling', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: MatrixPokerScreen()),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Phase 1'), findsOneWidget);
    expect(find.text('Dealer'), findsOneWidget);
  });
}
