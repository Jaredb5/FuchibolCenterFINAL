import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renderiza un ListView con ListTile', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [
              ListTile(title: Text('Jugador 1')),
              ListTile(title: Text('Jugador 2')),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ListTile), findsWidgets);
  });
}
