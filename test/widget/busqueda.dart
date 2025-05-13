import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/players/players_screen.dart'; // Ajusta el import a tu ruta real

void main() {
  testWidgets('PlayersScreen muestra el botón de búsqueda (IconButton de la lupa)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PlayersScreen(year: '2023'),
      ),
    );

    // Verifica que existe al menos un IconButton con icono de búsqueda (Icons.search)
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}
