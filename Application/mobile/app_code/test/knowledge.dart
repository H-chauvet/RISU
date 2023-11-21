import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/knowledge/knowledge_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Test Knowledge page', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Knowledge page', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) =>
                  ThemeProvider(false), // Provide a default value for testing.
            ),
          ],
          child: const MaterialApp(
            home: KnowledgePage(),
          ),
        ),
      );
      Finder buttonChangeColorFinder =
      find.byKey(const Key('knowledge-button-change_color'));
      Finder buttonContactApiFinder =
      find.byKey(const Key('knowledge-button-contact_api'));
      Finder alertDialog =
      find.byKey(const Key('alertdialog-button_ok'));

      expect(buttonChangeColorFinder, findsOneWidget);
      expect(buttonContactApiFinder, findsOneWidget);
      expect(alertDialog, findsNothing);

      final materialFinder = find
          .byType(Material)
          .first;
      expect(materialFinder, findsOneWidget);

      final Color? oldBackgroundColor = tester
          .widget<Material>(
        materialFinder,
      )
          .color;

      await tester.tap(buttonChangeColorFinder);
      await tester.pumpAndSettle();

      final Color? newBackgroundColor = tester
          .widget<Material>(
        materialFinder,
      )
          .color;

      expect(oldBackgroundColor != newBackgroundColor, true);

      await tester.tap(buttonContactApiFinder);
      await tester.pumpAndSettle();

      expect(alertDialog, findsOneWidget);
    });
  });
}
