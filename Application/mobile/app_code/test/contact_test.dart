import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('ContactPage full info', (WidgetTester tester) async {
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

    Finder nameInput = find.byKey(const Key('contact-text_input-input_name'));
    expect(nameInput, findsOneWidget);
    await tester.enterText(nameInput, 'hugo');
    await tester.pumpAndSettle();

    Finder emailInput = find.byKey(const Key('contact-text_input-input_email'));
    expect(emailInput, findsOneWidget);
    await tester.enterText(emailInput, 'test@example.com');
    await tester.pumpAndSettle();

    Finder messageInput =
        find.byKey(const Key('contact-text_input-input_message'));
    expect(messageInput, findsOneWidget);
    await tester.enterText(messageInput, 'Hello, World!');
    await tester.pumpAndSettle();

    Finder sendButton = find.byKey(const Key('contact-button-send_message'));
    expect(sendButton, findsOneWidget);

    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    Finder invalidAlertDialog =
        find.byKey(const Key('contact-alert_dialog-invalid_info'));
    expect(invalidAlertDialog, findsNothing);

    Finder refusedAlertDialog =
        find.byKey(const Key('contact-alert_dialog-refused'));
    expect(refusedAlertDialog, findsNothing);
  });

  testWidgets('ContactPage no info', (WidgetTester tester) async {
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

    Finder sendButton = find.byKey(const Key('contact-button-send_message'));
    expect(sendButton, findsOneWidget);

    await tester.tap(sendButton);
    await tester.pumpAndSettle();

    Finder alertDialog =
        find.byKey(const Key('contact-alert_dialog-invalid_info'));
    expect(alertDialog, findsOneWidget);
  });
}
