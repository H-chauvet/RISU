import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/details_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets(
    'Article details from an empty articleId',
    (WidgetTester tester) async {
      await tester
          .pumpWidget(initPage(const ArticleDetailsPage(articleId: -1)));

      await tester.pumpAndSettle();

      Finder titleData = find.byKey(const Key('article-details_title'));
      Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));
      Finder favoriteData =
          find.byKey(const Key('article-button_add-favorite'));
      Finder opinionData =
          find.byKey(const Key('article-button_article-opinion'));

      expect(titleData, findsOneWidget);
      expect(appBarTitleData, findsOneWidget);
      expect(titleData, findsOneWidget);
      expect(favoriteData, findsOneWidget);
      expect(opinionData, findsOneWidget);
    },
  );
}
