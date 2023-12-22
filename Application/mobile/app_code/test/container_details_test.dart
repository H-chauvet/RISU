import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/container/details_page.dart';
import 'package:risu/utils/theme.dart';

void main () {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Container details should not be displayed from empty id',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: ContainerDetailsPage(containerId: ''),
          ),
        ),
      );

      Finder invalidData = find.byKey(const Key('container-details_invaliddata'));
      Finder titleData = find.byKey(const Key('container-details_title'));
      Finder containerData = find.byKey(const Key('container-details_article-list'));
      Finder articleListButton = find.byKey(const Key('container-button_article-list-page'));

      expect(invalidData, findsOneWidget);
      expect(titleData, findsOneWidget);
      expect(containerData, findsOneWidget);
      expect(articleListButton, findsOneWidget);

      await tester.tap(articleListButton);
      await tester.pumpAndSettle();
    }
  );
}