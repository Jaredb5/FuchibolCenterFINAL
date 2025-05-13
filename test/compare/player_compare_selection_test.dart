import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/players/player_compare_selection_screen.dart';

void main() {
  testWidgets('Renderizado básico de PlayerCompareSelectionScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: PlayerCompareSelectionScreen(),
      ),
    ));

    expect(find.byType(PlayerCompareSelectionScreen), findsOneWidget);
  });
}
