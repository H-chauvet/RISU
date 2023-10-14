import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:risu/pages/signup/signup_page.dart';

// Create a mock HTTP client using Mockito
class MockClient extends Mock implements http.Client {}

void main() {
  late MockClient mockClient;

  setUp(() {
    // Initialize the mock HTTP client before each test case
    mockClient = MockClient();
  });

  testWidgets('Initial state and UI rendering', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    // Verify the initial state of the form fields
    expect(find.byKey(const Key('email-text_input')), findsOneWidget);
    expect(find.byKey(const Key('password-text_input')), findsOneWidget);
    expect(find.byKey(const Key('password_confirmation-text_input')),
        findsOneWidget);

    // Verify the presence of buttons and texts
    expect(find.byKey(const Key('send_signup-button')), findsOneWidget);
    expect(find.byKey(const Key('go_login-button')), findsOneWidget);
    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Retour à l\'écran de connexion...'), findsOneWidget);
  });

  testWidgets('Form input validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPage()));

    // Fill in the email field with an invalid email address
    await tester.enterText(
        find.byKey(const Key('email-text_input')), 'invalid-email');
    await tester.pumpAndSettle();

    // Verify the error message for the email field
    expect(find.text('Doit être une adresse e-mail valide.'), findsOneWidget);

    // Fill in the password field with a short password
    await tester.enterText(
        find.byKey(const Key('password-text_input')), 'short');
    await tester.pumpAndSettle();

    // Verify the error message for the password field
    expect(find.text('Le mot de passe doit contenir au moins 8 caractères.'),
        findsOneWidget);

    // Fill in the confirmation password field with a different value
    await tester.enterText(
        find.byKey(const Key('password_confirmation-text_input')), 'different');
    await tester.pumpAndSettle();

    // Verify the error message for the confirmation password field
    expect(
        find.text('Les mots de passe ne correspondent pas.'), findsOneWidget);
  });

  // Test case for successful API request and response handling
  testWidgets('Successful API request and response handling',
      (WidgetTester tester) async {
    when(mockClient.post(
      Uri.parse('http://10.0.2.2:8080/api/signup'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"statusCode": 201}', 201));

    await tester.pumpWidget(
      const MaterialApp(home: SignupPage()),
    );

    await tester.enterText(
        find.byKey(const Key('email-text_input')), 'valid@example.com');
    await tester.enterText(
        find.byKey(const Key('password-text_input')), 'password');
    await tester.enterText(
        find.byKey(const Key('password_confirmation-text_input')), 'password');

    await tester.tap(find.byKey(const Key('send_signup-button')));
    await tester.pumpAndSettle();

    expect(find.text('A confirmation e-mail has been sent to you !'),
        findsOneWidget);
  });

  // Test case for missing fields in API request
  testWidgets('Missing fields in API request', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SignupPage()),
    );

    await tester.tap(find.byKey(const Key('send_signup-button')));
    await tester.pumpAndSettle();

    expect(find.text('Please fill all the field !'), findsOneWidget);
  });

  // Test case for invalid API response status code
  testWidgets('Invalid API response status code', (WidgetTester tester) async {
    when(mockClient.post(
      Uri.parse('http://10.0.2.2:8080/api/signup'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('{"statusCode": 400}', 400));

    await tester.pumpWidget(
      const MaterialApp(home: SignupPage()),
    );

    await tester.enterText(
        find.byKey(const Key('email-text_input')), 'invalid@example.com');
    await tester.enterText(
        find.byKey(const Key('password-text_input')), 'password');
    await tester.enterText(
        find.byKey(const Key('password_confirmation-text_input')), 'password');

    await tester.tap(find.byKey(const Key('send_signup-button')));
    await tester.pumpAndSettle();

    expect(find.text('Invalid e-mail address !'), findsOneWidget);
  });
}
