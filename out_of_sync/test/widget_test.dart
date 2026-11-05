import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:out_of_symc/main.dart';

void main() {
  testWidgets('home screen asks for a name without starting networking', (tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Out of Sync'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Lag nytt spill'), findsOneWidget);
    expect(find.text('Bli med i spill'), findsOneWidget);
  });

  testWidgets('creating a game with an empty name shows validation', (tester) async {
    await tester.pumpWidget(const MainApp());
    final createButton = find.text('Lag nytt spill');
    await tester.ensureVisible(createButton);
    await tester.tap(createButton);
    await tester.pump();
    expect(find.text('Skriv inn navn for å lage spillet'), findsOneWidget);
  });
}
