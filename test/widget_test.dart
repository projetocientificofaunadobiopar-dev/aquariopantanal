// Smoke test do app Bioparque Pantanal.
// O app de produção depende do Supabase, então testes de UI completos
// devem mockar essa dependência. Por enquanto deixamos só um placeholder
// que valida o arquivo Dart.

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('placeholder', () {
    expect(1 + 1, 2);
  });
}
