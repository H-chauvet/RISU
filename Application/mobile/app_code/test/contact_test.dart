import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

// Create a mock HTTP client for testing
class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('ContactPage widget test', (WidgetTester tester) async {
    userInformation = UserData(
        email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: ContactPage(),
        ),
      ),
    );

    // Verify that the initial widget is displayed
    expect(find.text('Nous contacter'), findsOneWidget);

    // Simulate user input
    final nameField = find.byKey(Key('name'));
    await tester.enterText(nameField, 'hugo');
    final emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'test@example.com');
    final messageField = find.byKey(Key('message'));
    await tester.enterText(messageField, 'Hello, World!');

    // Simulate button tap
    final sendButton = find.byKey(Key('new-contact-button'));
    await tester.tap(sendButton);
    await tester.pumpAndSettle();
  });
}
