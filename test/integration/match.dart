import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/matches/match_screen.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('MatchScreen muestra título y lista', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MatchScreen(),
      ),
    );

    expect(find.text('Partidos'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
  });
}
