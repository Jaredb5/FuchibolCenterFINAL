import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/teams/team_compare_selection_screen.dart';

void main() {
  testWidgets('Renderizado básico de TeamCompareSelectionScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: TeamCompareSelectionScreen(),
      ),
    ));

    expect(find.byType(TeamCompareSelectionScreen), findsOneWidget);
  });
}
