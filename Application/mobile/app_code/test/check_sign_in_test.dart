import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

void main() {
  group('Check Sign In Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('User info complete', (WidgetTester tester) async {
      userInformation =
          UserData(email: "email@gmail.com", firstName: "", lastName: "");
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                checkSignin(context).then((res) => {expect(res, true)});
                return const Scaffold();
              },
            ),
          ),
        ),
      );
    });
    testWidgets('User info null', (WidgetTester tester) async {
      userInformation = null;

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) =>
                  ThemeProvider(false), // Provide a default value for testing.
            ),
          ],
          child: MaterialApp(
            home: Container(),
          ),
        ),
      );

      BuildContext context = tester.element(find.byType(Container));

      final res = checkSignin(context);
      await tester.pumpAndSettle();
      final Finder authRequired =
          find.byKey(const Key("check_sign_in-alert_dialog-required_auth"));
      expect(authRequired, findsOneWidget);

      final Finder okButton = find.byKey(const Key("alertdialog-button_ok"));
      expect(okButton, findsOneWidget);

      await tester.tap(okButton);
    });
  });
}
