import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

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

  /*testWidgets('ContactPage widget test', (WidgetTester tester) async {
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

    await tester.pumpAndSettle();
    expect(find.text('Nous contacter'), findsOneWidget);

    final nameField = find.byKey(Key('name'));
    await tester.enterText(nameField, 'hugo');
    final emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'test@example.com');
    final messageField = find.byKey(Key('message'));
    await tester.enterText(messageField, 'Hello, World!');

    final sendButton = find.byKey(Key('new-contact-button'));
    await tester.tap(sendButton);
    await tester.pumpAndSettle();
  });*/
}
