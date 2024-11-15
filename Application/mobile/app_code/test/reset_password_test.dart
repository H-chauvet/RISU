import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/reset_password/reset_password_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // Ensures Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  group('ResetPasswordPage tests', () {
    testWidgets('Visual elements render correctly',
        (WidgetTester tester) async {
      final testPage = initPage(const ResetPasswordPage(token: ''));

      await waitForLoader(tester: tester, testPage: testPage);
      Finder passwordField =
          find.byKey(const Key('reset_password-textinput_password'));
      Finder confirmPasswordField =
          find.byKey(const Key('signup-textinput_password_confirmation'));
      expect(passwordField, findsOneWidget);
      expect(confirmPasswordField, findsOneWidget);
    });

    testWidgets('Error when fields are empty', (WidgetTester tester) async {
      final testPage = initPage(const ResetPasswordPage(token: 'testToken'));
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.pumpWidget(testPage);

      Finder confirmButton = find.byKey(const Key('reset_password-confirm'));
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      Finder errorDialog = find.byType(AlertDialog);
      expect(errorDialog, findsOneWidget);

      Finder dialogOkButton = find.byKey(const Key("alertdialog-button_ok"));
      expect(dialogOkButton, findsOneWidget);
      await tester.tap(dialogOkButton);
    });

    testWidgets('Toggles password visibility', (WidgetTester tester) async {
      final testPage = initPage(const ResetPasswordPage(token: 'testToken'));
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.pumpWidget(testPage);

      Finder visibilityIcon = find.byIcon(Icons.visibility).first;
      expect(visibilityIcon, findsOneWidget);

      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle();

      Finder visibilityOffIcon = find.byIcon(Icons.visibility_off).first;
      expect(visibilityOffIcon, findsOneWidget);
    });

    testWidgets('Handles valid inputs correctly', (WidgetTester tester) async {
      final testPage = initPage(const ResetPasswordPage(token: 'testToken'));
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.pumpWidget(testPage);

      Finder passwordField =
          find.byKey(const Key('reset_password-textinput_password'));
      Finder confirmPasswordField =
          find.byKey(const Key('signup-textinput_password_confirmation'));
      await tester.enterText(passwordField, 'ValidPass123');
      await tester.enterText(confirmPasswordField, 'ValidPass123');

      Finder confirmButton = find.byKey(const Key('reset_password-confirm'));
      await tester.tap(confirmButton);
    });

    testWidgets('Displays error for mismatched passwords',
        (WidgetTester tester) async {
      final testPage = initPage(const ResetPasswordPage(token: 'testToken'));
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.pumpWidget(testPage);

      Finder passwordField =
          find.byKey(const Key('reset_password-textinput_password'));
      Finder confirmPasswordField =
          find.byKey(const Key('signup-textinput_password_confirmation'));
      await tester.enterText(passwordField, 'ValidPass123');
      await tester.enterText(confirmPasswordField, 'Mismatch123');

      Finder confirmButton = find.byKey(const Key('reset_password-confirm'));
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();

      Finder errorDialog = find.byType(AlertDialog);
      expect(errorDialog, findsOneWidget);

      Finder dialogOkButton = find.byKey(const Key("alertdialog-button_ok"));
      await tester.tap(dialogOkButton);
    });
  });
}
