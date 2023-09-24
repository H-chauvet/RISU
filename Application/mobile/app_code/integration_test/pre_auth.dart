import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/main.dart';

void main() {
  group('Test PreAuth', () {
    MyApp app = const MyApp();

    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      // This code runs before each test case.
      app = const MyApp();
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
          child: MaterialApp(
            home: app,
          ),
        ),
      );

      Finder subTitleFinder = find.byKey(const Key('pre_auth-subtitle_text'));
      Finder goToLoginFinder =
          find.byKey(const Key('pre_auth-button_go_to_login'));
      Finder goToSignupFinder =
          find.byKey(const Key('pre_auth-button_go_to_signup'));

      await tester.pumpAndSettle();

      expect(subTitleFinder, findsOneWidget);
      expect(goToLoginFinder, findsOneWidget);
      expect(goToSignupFinder, findsOneWidget);

      await tester.tap(goToLoginFinder);
      await tester.pumpAndSettle();

      /*Finder goBack = find.byKey(const Key('back-button'));
      expect(goBack, findsOneWidget);

      await tester.tap(goBack);
      await tester.pumpAndSettle();*/
    });

    testWidgets('Register', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) =>
                  ThemeProvider(false), // Provide a default value for testing.
            ),
          ],
          child: MaterialApp(
            home: app,
          ),
        ),
      );

      Finder subTitleFinder = find.byKey(const Key('pre_auth-subtitle_text'));
      Finder goToLoginFinder =
          find.byKey(const Key('pre_auth-button_go_to_login'));
      Finder goToSignupFinder =
          find.byKey(const Key('pre_auth-button_go_to_signup'));

      await tester.pumpAndSettle();

      expect(subTitleFinder, findsOneWidget);
      expect(goToLoginFinder, findsOneWidget);
      expect(goToSignupFinder, findsOneWidget);

      await tester.tap(goToSignupFinder);
      await tester.pumpAndSettle();
    });
  });
}
