import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/teams/tournament_screen.dart';

void main() {
  testWidgets('Renderiza correctamente TournamentScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: TournamentScreen(),
    ));

    // Esperar a que el initState y los datos asíncronos terminen
    await tester.pumpAndSettle();

    // Verifica que la pantalla se haya renderizado correctamente
    expect(find.byType(DropdownButton<int>), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
  });
}
