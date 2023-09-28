import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';

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

    testWidgets('Login', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) =>
                  ThemeProvider(false), // Provide a default value for testing.
            ),
          ],
          child: const MaterialApp(
            home: LoginPage(),
          ),
        ),
      );

      Finder subTitleFinder = find.byKey(const Key('login-text_title'));
      Finder textInputEmailFinder =
          find.byKey(const Key('login-textinput_email'));
      Finder textInputPasswordFinder =
          find.byKey(const Key('login-textinput_password'));
      Finder textButtonResetPasswordFinder =
          find.byKey(const Key('login-textbutton_resetpassword'));
      Finder buttonSigninFinder = find.byKey(const Key('login-button_signin'));
      Finder textinputRightIconFinder =
          find.byKey(const Key('textinput-button_righticon'));
      Finder textButtonSignupFinder =
          find.byKey(const Key('login-textbutton_gotosignup'));
      Finder alertdialogEmptyFieldsFinder =
          find.byKey(const Key('login-alertdialog_emptyfields'));
      Finder alertdialogConnectionRefusedFinder =
          find.byKey(const Key('login-alertdialog_connectionrefused'));
      Finder alertdialogInvalidDataFinder =
          find.byKey(const Key('login-alertdialog_invaliddata'));
      Finder alertdialogInvalidTokenFinder =
          find.byKey(const Key('login-alertdialog_invalidtoken'));
      Finder alertdialogInvalidResponseFinder =
          find.byKey(const Key('login-alertdialog_invalidresponse'));
      Finder alertdialogInvalidCredentialsFinder =
          find.byKey(const Key('login-alertdialog_invalidcredentials'));
      Finder alertdialogErrorFinder =
          find.byKey(const Key('login-alertdialog_error'));

      expect(subTitleFinder, findsOneWidget);
      expect(textInputEmailFinder, findsOneWidget);
      expect(textInputPasswordFinder, findsOneWidget);
      expect(textinputRightIconFinder, findsOneWidget);
      expect(textButtonResetPasswordFinder, findsOneWidget);
      expect(buttonSigninFinder, findsOneWidget);
      expect(textButtonSignupFinder, findsOneWidget);
      expect(alertdialogEmptyFieldsFinder, findsNothing);

      await tester.tap(buttonSigninFinder);
      await tester.pumpAndSettle();

      await tester.enterText(textInputEmailFinder, 'example@gmail.com');

      expect(find.byKey(const Key('alertdialog-button_ok')), findsOneWidget);
      await tester.tap(find.byKey(const Key('alertdialog-button_ok')));
      await tester.pumpAndSettle();
      expect(alertdialogEmptyFieldsFinder, findsNothing);

      await tester.pumpAndSettle();
      await tester.enterText(textInputPasswordFinder, '12345678');
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          true);
      await tester.tap(textinputRightIconFinder);
      await tester.pumpAndSettle();
      expect(tester.widget<MyTextInput>(textInputPasswordFinder).obscureText,
          false);
    });
  });
}
