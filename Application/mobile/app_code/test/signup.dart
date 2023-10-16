import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Signup Page Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
    });

    Finder textinputRightIconFinder =
        find.byKey(const Key('textinput-button_righticon'));
    find.byKey(const Key('signup-textinput_email'));
    Finder textInputPasswordFinder =
        find.byKey(const Key('signup-textinput_password'));
    testWidgets('Widget Rendering Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: SignupPage(),
          ),
        ),
      );

      // Check if key widgets are present
      expect(find.byKey(const Key('signup-appbar')), findsOneWidget);
      expect(find.byKey(const Key('signup-text_title')), findsOneWidget);
      expect(find.byKey(const Key('signup-textinput_email')), findsOneWidget);
      expect(
          find.byKey(const Key('signup-textinput_password')), findsOneWidget);
      expect(find.byKey(const Key('signup-button_signup')), findsOneWidget);
      expect(
          find.byKey(const Key('signup-textbutton_gotologin')), findsOneWidget);
    });

    testWidgets('Signup Process Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: SignupPage(),
          ),
        ),
      );

      // Enter email and password
      await tester.enterText(
          find.byKey(const Key('signup-textinput_email')), 'test@example.com');
      await tester.enterText(
          find.byKey(const Key('signup-textinput_password')), 'password123');
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          true);
      await tester.tap(textinputRightIconFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          false);

      expect(
          find.byKey(const Key('signup-textbutton_gotologin')), findsOneWidget);
      // Tap the signup button
      await tester.tap(find.byKey(const Key('signup-button_signup')));
    });
  });
}
