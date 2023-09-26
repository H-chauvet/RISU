import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/main.dart';
import 'package:risu/utils/theme.dart';

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

    Finder goBack = find.byKey(const Key('appbar-button_back'));
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

      Finder subTitleFinder = find.byKey(const Key('pre_auth-text_subtitle'));
      Finder goToLoginFinder =
          find.byKey(const Key('pre_auth-button_gotologin'));
      Finder goToSignupFinder =
          find.byKey(const Key('pre_auth-button_gotosignup'));

      await tester.pumpAndSettle();

      expect(subTitleFinder, findsOneWidget);
      expect(goToLoginFinder, findsOneWidget);
      expect(goToSignupFinder, findsOneWidget);

      await tester.tap(goToLoginFinder);
      await tester.pumpAndSettle();

      expect(goBack, findsOneWidget);

      await tester.tap(goBack);
      await tester.pumpAndSettle();
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

      Finder subTitleFinder = find.byKey(const Key('pre_auth-text_subtitle'));
      Finder goToLoginFinder =
          find.byKey(const Key('pre_auth-button_gotologin'));
      Finder goToSignupFinder =
          find.byKey(const Key('pre_auth-button_gotosignup'));

      await tester.pumpAndSettle();

      expect(subTitleFinder, findsOneWidget);
      expect(goToLoginFinder, findsOneWidget);
      expect(goToSignupFinder, findsOneWidget);

      await tester.tap(goToSignupFinder);
      await tester.pumpAndSettle();

      expect(goBack, findsOneWidget);

      await tester.tap(goBack);
      await tester.pumpAndSettle();
    });
  });
}
