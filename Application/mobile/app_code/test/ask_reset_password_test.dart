import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/pages/login/ask_reset_password/ask_reset_password_page.dart';

import 'globals.dart';

void main() {
  group('Test Ask Reset Password', () {
    setUpAll(() async {
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    Finder appBarFinder = find.byType(MyAppBar);
    Finder textFinder =
        find.byKey(const Key('ask_reset_password-text_description'));
    Finder textInputFinder =
        find.byKey(const Key('ask_reset_password-textinput_email'));
    Finder textButtonFinder =
        find.byKey(const Key('ask_reset_password-textbutton_gotologin'));
    Finder buttonFinder =
        find.byKey(const Key('ask_reset_password-button_send'));

    testWidgets('Check UI components', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const AskResetPasswordPage()));

      expect(appBarFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
      expect(textInputFinder, findsOneWidget);
      expect(textButtonFinder, findsOneWidget);
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('Go back to Login', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const AskResetPasswordPage()));

      await tester.tap(textButtonFinder);
      await tester.pumpAndSettle();

      // Only testing if the page AskResetPasswordPage is not found because
      // we pop the page when clicking the textButton to go back to login
      expect(find.byType(AskResetPasswordPage), findsNothing);
    });

    testWidgets('Check email', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const AskResetPasswordPage()));

      await tester.enterText(textInputFinder, 'test@gmail.com');

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
    });
  });
}
