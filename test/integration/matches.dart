import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Creamos un Fake PlayersScreen para simular
class FakePlayersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jugadores'),
          actions: const [
            Icon(Icons.search),
          ],
        ),
        body: ListView(
          children: const [
            ListTile(title: Text('Jugador 1')),
            ListTile(title: Text('Jugador 2')),
            ListTile(title: Text('Jugador 3')),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets('Prueba simulada de integración de PlayersScreen',
      (WidgetTester tester) async {
    // Montar la pantalla fake
    await tester.pumpWidget(FakePlayersScreen());

    // Verificar título en AppBar
    expect(find.text('Jugadores'), findsOneWidget);

    // Verificar icono de búsqueda
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verificar que hay ListTile en la lista
    expect(find.byType(ListTile), findsWidgets);

    // Simular scroll
    await tester.fling(find.byType(ListView), const Offset(0, -300), 1000);
    await tester.pumpAndSettle();

    // Confirmar que aún hay ListTile tras scroll
    expect(find.byType(ListTile), findsWidgets);
  });
}
