import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/login/login_page.dart';

void main() {
  testWidgets('LoginPage Integration Test', (WidgetTester tester) async {
    // Build the app and navigate to the login page
    await tester.pumpWidget(
      const MaterialApp(home: LoginPage()),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));
    // Verify the initial state of the login page
    expect(find.byKey(const Key('title-text')), findsOneWidget);
    expect(find.byKey(const Key('email-text_input')), findsOneWidget);
    expect(find.byKey(const Key('continue_email-button')), findsOneWidget);
    expect(find.byKey(const Key('goto_signup-button')), findsOneWidget);

    // Tap the "Continuer avec un e-mail" button
    await tester.tap(find.byKey(const Key('continue_email-button')));
    await tester.pumpAndSettle();

    // Verify the state after tapping the "Continuer avec un e-mail" button
    expect(find.byKey(const Key('title-text')), findsOneWidget);
    expect(find.byKey(const Key('email-text_input')), findsOneWidget);
    expect(find.byKey(const Key('login-button')), findsOneWidget);
    expect(find.byKey(const Key('continue_email-button')), findsNothing);
    expect(find.byKey(const Key('reset_password-button')), findsOneWidget);

    // Enter the email and password
    await tester.enterText(
        find.byKey(const Key('email-text_input')), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key('password-text_input')), 'password');

    // Tap the "Se connecter" button
    await tester.tap(find.byKey(const Key('login-button')));
    await tester.pumpAndSettle();

    // Verify the login succeeded and the user data is stored
    expect(find.text('Connexion refused.'), findsOneWidget);
  });
}
