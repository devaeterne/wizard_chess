import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wizard_chess/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(WizardChessApp());

    // Since bizim örnekte sayıda counter yok, testte arama yapacak metni değiştir.
    expect(find.text('Wizard Chess'), findsOneWidget);
  });
}
