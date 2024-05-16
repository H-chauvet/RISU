import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/signup/signup_page.dart';

import 'globals.dart';

void main() {
  group('Signup Page Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    Finder logoFinder = find.byKey(const Key('appbar-image_logo'));
    Finder textInputRightIconFinder =
        find.byKey(const Key('textinput-button_righticon'));
    Finder textInputRightIconConfirmationFinder = find
        .byKey(const Key('signup-textinput_password_confirmation_righticon'));
    Finder textInputEmailFinder =
        find.byKey(const Key('signup-textinput_email'));
    Finder textInputPasswordFinder =
        find.byKey(const Key('signup-textinput_password'));
    Finder textInputPasswordConfirmationFinder =
        find.byKey(const Key('signup-textinput_password_confirmation'));

    testWidgets('Widget Rendering Test', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const SignupPage()));

      // Check if key widgets are present
      expect(logoFinder, findsOneWidget);
      expect(find.byKey(const Key('signup-appbar')), findsOneWidget);
      expect(find.byKey(const Key('signup-text_title')), findsOneWidget);
      expect(textInputEmailFinder, findsOneWidget);
      expect(textInputPasswordFinder, findsOneWidget);
      expect(textInputPasswordConfirmationFinder, findsOneWidget);
      expect(textInputRightIconFinder, findsOneWidget);
      expect(textInputRightIconConfirmationFinder, findsOneWidget);
      expect(find.byKey(const Key('signup-button_signup')), findsOneWidget);
      expect(
          find.byKey(const Key('signup-textbutton_gotologin')), findsOneWidget);
    });

    testWidgets('Signup Process Test', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const SignupPage()));

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
      await tester.enterText(textInputEmailFinder, 'test@example.com');
      await tester.enterText(textInputPasswordFinder, 'password123');

      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          true);
      expect(
          tester
              .widget<MyTextInput>(textInputPasswordConfirmationFinder)
              .obscureText,
          true);
      await tester.tap(textInputRightIconFinder);
      await tester.tap(textInputRightIconConfirmationFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          false);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<MyTextInput>(textInputPasswordConfirmationFinder)
              .obscureText,
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
