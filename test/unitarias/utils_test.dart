// Archivo: test/unitarias/utils_test.dart

import 'package:flutter_test/flutter_test.dart';

double safeDivide(int value, int matches) {
  if (matches == 0) return 0.0;
  return value / matches;
}

void main() {
  group('Utils Functions Test', () {
    test('safeDivide debería devolver la división correcta', () {
      final result = safeDivide(10, 2);
      expect(result, 5.0); // 10 ÷ 2 = 5
    });

    test('safeDivide debería devolver 0.0 cuando el divisor es cero', () {
      final result = safeDivide(10, 0);
      expect(result, 0.0); // No se puede dividir entre cero
    });

    test('safeDivide debería manejar números negativos', () {
      final result = safeDivide(-10, 2);
      expect(result, -5.0); // -10 ÷ 2 = -5
    });
  });
}
