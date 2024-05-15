import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/files/login.dart'; // Asegúrate de que la ruta de importación es correcta.

void main() {
  testWidgets('Login Screen widgets test', (WidgetTester tester) async {
    // Construye la app y desencadena un frame.
    await tester.pumpWidget(MaterialApp(home: LoginScreen()));

    // Verifica que los campos de texto y botones están presentes.
    expect(find.byKey(const ValueKey('email')), findsOneWidget);
    expect(find.byKey(const ValueKey('password')), findsOneWidget);

    // Rellena los campos de texto con entradas de prueba.
    await tester.enterText(
        find.byKey(const ValueKey('email')), 'test@test.com');
    await tester.enterText(
        find.byKey(const ValueKey('password')), 'testPassword');

    // Toca el botón de 'Iniciar sesión' usando un Key o el finder más específico.
    await tester.tap(find.byKey(const Key(
        'signInButton'))); // Asegúrate de haber añadido el Key en tu botón ElevatedButton.
    // O si estás usando el método más específico sin Key:
    // await tester.tap(find.widgetWithText(ElevatedButton, 'Iniciar sesión'));

    await tester.pump(); // Desencadena un frame.

    // Realiza aserciones adicionales, como verificar que aparece un SnackBar o que se navega a otra pantalla.
  });
}
