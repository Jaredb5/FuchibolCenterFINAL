import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_2/main.dart'; // Cambia esto según la ruta de tu archivo main.dart
import 'package:flutter/material.dart';

void main() {
  testWidgets('Prueba de renderizado en pantallas pequeñas y grandes', (WidgetTester tester) async {
    // Lista de tamaños de pantalla para probar
    final List<Size> screenSizes = [
      Size(320, 480), // Tamaño pequeño (teléfono antiguo)
      Size(392, 844), // Tamaño mediano (iPhone 13 Pro)
      Size(800, 1280), // Tamaño grande (tablet)
      Size(1920, 1080) // Tamaño computadora
    ];

    for (final size in screenSizes) {
      // Configurar el tamaño de la pantalla simulada
      await tester.binding.setSurfaceSize(size);

      // Cargar la aplicación principal
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Verificar que los elementos principales de la pantalla están presentes
      expect(find.text('Inicio'), findsOneWidget); // Cambia 'Inicio' según tu app
      expect(find.byType(Scaffold), findsOneWidget);

      // Imprimir el tamaño probado en el registro de prueba
      // ignore: avoid_print
      print('Prueba completada con tamaño: ${size.width}x${size.height}');
    }
  });
}
