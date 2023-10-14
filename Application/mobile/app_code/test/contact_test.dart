import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:http/http.dart' as http;

// Create a mock HTTP client for testing
class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('ContactPage widget test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: ContactPage(),
      ),
    );

    // Verify that the initial widget is displayed
    expect(find.text('Nous contacter'), findsOneWidget);

    // Simulate user input
    final nameField = find.byKey(const Key('name'));
    await tester.enterText(nameField, 'hugo');
    final emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'test@example.com');
    final messageField = find.byKey(const Key('message'));
    await tester.enterText(messageField, 'Hello, World!');

    // Simulate button tap
    final sendButton = find.byKey(const Key('new-contact-button'));
    await tester.tap(sendButton);
    await tester.pump();
  });
}