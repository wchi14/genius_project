import 'package:flutter_test/flutter_test.dart';
import 'package:genius_project/core/routing/app_router.dart';
import 'package:genius_project/main.dart';

void main() {
  testWidgets('Browse games opens game selection', (tester) async {
    await tester.pumpWidget(GeniusApp(router: createAppRouter()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse games'));
    await tester.pumpAndSettle();

    expect(find.text('Games'), findsOneWidget);
    expect(find.text('Apex Equation'), findsOneWidget);
  });
}
