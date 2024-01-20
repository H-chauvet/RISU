import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
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
            home: ArticleListPage(containerId: ''),
          ),
        ),
      );

      Finder articleCard = find.byKey(const Key('articles-list_card'));
      expect(articleCard, findsNothing);
    }
  );
}
