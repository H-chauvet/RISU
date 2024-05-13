import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/login/ask_reset_password/ask_reset_password_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/signup/signup_page.dart';

import 'globals.dart';

void main() {
  group('Test Login', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Click on checkbox to toggle stay connected',
        (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const LoginPage()));

      Finder checkBoxFinder =
          find.byKey(const Key('login-checkbox_stayconnected'));

      expect(tester.widget<Checkbox>(checkBoxFinder).value, false);

      await tester.tap(checkBoxFinder);
      await tester.pump();

      expect(tester.widget<Checkbox>(checkBoxFinder).value, true);
    });

    testWidgets('Click on text to toggle stay connected',
        (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const LoginPage()));

      Finder TextStayConnectedFinder =
          find.byKey(const Key('login-text_stayconnected'));

      expect(
          tester
              .widget<Checkbox>(
                  find.byKey(const Key('login-checkbox_stayconnected')))
              .value,
          false);

      await tester.tap(TextStayConnectedFinder);
      await tester.pump();

      expect(
          tester
              .widget<Checkbox>(
                  find.byKey(const Key('login-checkbox_stayconnected')))
              .value,
          true);
    });

    testWidgets('Login', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const LoginPage()));

      Finder appBarTitle = find.byKey(const Key('appbar-text_title'));
      Finder textInputEmailFinder =
          find.byKey(const Key('login-textinput_email'));
      Finder textInputPasswordFinder =
          find.byKey(const Key('login-textinput_password'));
      Finder CheckBoxFinder =
          find.byKey(const Key('login-checkbox_stayconnected'));
      Finder TextStayConnectedFinder =
          find.byKey(const Key('login-text_stayconnected'));
      Finder textButtonResetPasswordFinder =
          find.byKey(const Key('login-textbutton_resetpassword'));
      Finder buttonSigninFinder = find.byKey(const Key('login-button_signin'));
      Finder textinputRightIconFinder =
          find.byKey(const Key('textinput-button_righticon'));
      Finder textButtonSignupFinder =
          find.byKey(const Key('login-textbutton_gotosignup'));
      Finder alertdialogEmptyFieldsFinder =
          find.byKey(const Key('login-alertdialog_emptyfields'));

      expect(appBarTitle, findsOneWidget);
      expect(textInputEmailFinder, findsOneWidget);
      expect(textInputPasswordFinder, findsOneWidget);
      expect(CheckBoxFinder, findsOneWidget);
      expect(TextStayConnectedFinder, findsOneWidget);
      expect(textinputRightIconFinder, findsOneWidget);
      expect(textButtonResetPasswordFinder, findsOneWidget);
      expect(buttonSigninFinder, findsOneWidget);
      expect(textButtonSignupFinder, findsOneWidget);
      expect(alertdialogEmptyFieldsFinder, findsNothing);

      await tester.tap(buttonSigninFinder);
      await tester.pumpAndSettle();

      await tester.enterText(textInputEmailFinder, 'admin@gmail.com');

      expect(find.byType(AlertDialog), findsOneWidget);
      Finder okButton = find.byKey(const Key('alertdialog-button_ok'));
      await tester.tap(okButton);
      await tester.pumpAndSettle();
      expect(alertdialogEmptyFieldsFinder, findsNothing);

      await tester.pumpAndSettle();
      await tester.enterText(textInputPasswordFinder, 'admin');
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          true);
      await tester.tap(textinputRightIconFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          false);
    });
  });

  testWidgets('Invalid login should show error message',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(initPage(const LoginPage()));

    await tester.enterText(
        find.byKey(const Key('login-textinput_email')), 'invalid_email');
    await tester.enterText(
        find.byKey(const Key('login-textinput_password')), 'invalid_password');
    await tester.tap(find.byKey(const Key('login-button_signin')));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets(
      'Tapping \'Mot de passe oublié ?\' should show reset password dialog',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(initPage(const LoginPage()));
    await tester.enterText(
        find.byKey(const Key('login-textinput_email')), 'user@gmail.com');

    await tester.tap(find.byKey(const Key('login-textbutton_resetpassword')));

    await tester.pumpAndSettle();

    expect(find.byType(AskResetPasswordPage), findsOneWidget);
  });

  testWidgets(
      'Tapping \'Pas de compte ? S\'inscrire\' should navigate to SignupPage',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(initPage(const LoginPage()));

    await tester.tap(find.byKey(const Key('login-textbutton_gotosignup')));
    await tester.pumpAndSettle();

    expect(find.byType(SignupPage), findsOneWidget);
  });
}
