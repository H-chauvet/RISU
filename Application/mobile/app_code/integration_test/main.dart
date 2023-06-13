import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/main.dart';

void main() {
  testWidgets('MyApp Integration Test', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle();
    // Verify the initial state of the app
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
