import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Signup Page Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
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

      await tester.pumpAndSettle();

      final Finder alertDialog = find.byType(AlertDialog);
      final Finder signUpButton = find.byKey(const Key('signup-button_signup'));
      final Finder alertDialogButtonOk =
          find.byKey(const Key('alertdialog-button_ok'));
      final Finder textButtonResetPassword =
          find.byKey(const Key('signup-textbutton_resetpassword'));
      final Finder gotoSignInButton =
          find.byKey(const Key('signup-textbutton_gotologin'));
      final Finder gotoSignUpButton =
          find.byKey(const Key('login-textbutton_gotosignup'));

      expect(signUpButton, findsOneWidget);
      expect(textButtonResetPassword, findsOneWidget);
      await tester.tap(textButtonResetPassword);
      await tester.tap(signUpButton);
      await tester.pumpAndSettle();
      expect(alertDialog, findsOneWidget);
      expect(alertDialogButtonOk, findsOneWidget);
      await tester.tap(alertDialogButtonOk);
      await tester.pumpAndSettle();

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

      expect(gotoSignInButton, findsOneWidget);
      String? oldServerIp = serverIp;
      serverIp = 'wrongIP';
      await tester.tap(find.byKey(const Key('signup-button_signup')));
      await tester.pumpAndSettle();
      expect(alertDialog, findsOneWidget);
      expect(alertDialogButtonOk, findsOneWidget);
      await tester.tap(alertDialogButtonOk);
      await tester.pumpAndSettle();
      serverIp = oldServerIp;
      await tester.tap(gotoSignInButton);
      await tester.pumpAndSettle();
      expect(gotoSignUpButton, findsOneWidget);
      await tester.tap(gotoSignUpButton);
      await tester.pumpAndSettle();
      await tester.tap(signUpButton);
    });
  });
}
