import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/pages/article/details_state.dart';

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

  testWidgets(
    'Article details with test data',
        (WidgetTester tester) async {
      final item1 = {
        "id": -1,
        "name": "Ballon de volley",
        "containerId": -1,
        "price": 0.5,
        "available": true,
        "categories": []
      };
      final testPage =
      initPage(ArticleDetailsPage(articleId: -1, testArticleData: item1));
      await waitForLoader(tester: tester, testPage: testPage);
      await tester.pumpWidget(testPage);
      await tester.pumpAndSettle();

      Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));
      Finder titleData = find.byKey(const Key('article-details_title'));

      Finder opinionData = find.byKey(const Key('article-button_article-rent'));
      Finder consultArticle =
      find.byKey(const Key('article-button_article-opinion'));

      expect(consultArticle, findsOneWidget);
      expect(opinionData, findsOneWidget);
      expect(appBarTitleData, findsOneWidget);

      await tester.dragUntilVisible(
          opinionData, // what you want to find
          titleData, // widget you want to scroll
          const Offset(0, -300) // delta to move
      );

      await tester.tap(opinionData);
      await tester.tap(consultArticle);
    },
  );

  test('Testing sort tickets', () {
    final test = ArticleDetailsState();

    test.getArticleData(null, -1);
  });
}
