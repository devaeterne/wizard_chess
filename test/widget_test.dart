import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wizard_chess/main.dart';

void main() {
  testWidgets('Wizard Chess app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(WizardChessApp());

    // AppBar’da 'Wizard Chess' başlığının görünürlüğü
    expect(find.text('Wizard Chess'), findsOneWidget);

    // Satranç tahtasındaki karelerden biri görünmeli
    expect(find.byType(GridView), findsOneWidget);
  });
}
