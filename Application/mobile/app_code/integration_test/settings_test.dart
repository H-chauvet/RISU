import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/main.dart';

void main() {
  group('Test Settings', () {
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

    testWidgets('Settings', (WidgetTester tester) async {
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

      Finder goToLoginFinder =
          find.byKey(const Key('settings-button_go_to_parameter_page'));

      await tester.pumpAndSettle();

      expect(goToLoginFinder, findsOneWidget);

      await tester.tap(goToLoginFinder);
      await tester.pumpAndSettle();

      Finder dropDown =
          find.byKey(const Key('drop_down'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Clair'));
      expect(find.text('Clair'), findsOneWidget);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sombre'));
      expect(find.text('Sombre'), findsOneWidget);
      await tester.pumpAndSettle();

    });
  });
}
