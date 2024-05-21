import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
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
    'Similar articles',
    (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const ArticleDetailsPage(articleId: 1)));
      await tester.pumpAndSettle();

      Finder similarArticleTitle =
          find.byKey(const Key('article-similar_title'));
      expect(similarArticleTitle, findsNothing);
    },
  );

  testWidgets(
    'Similar articles',
    (WidgetTester tester) async {
      const similarArticlesData = [
        {'id': 1, 'name': 'Article 1', 'price': 10.0},
        {
          'id': 2,
          'name': 'Article 2 but with more than 15 letters',
          'price': 20.0
        },
      ];

      await tester.pumpWidget(
        initPage(
          const ArticleDetailsPage(
            articleId: 1,
            similarArticlesData: similarArticlesData,
          ),
        ),
      );
      await tester.pumpAndSettle();

      Finder similarArticleTitle =
          find.byKey(const Key('article-similar_title'));
      Finder articleSimilarImage1 =
          find.byKey(const Key('article-similar_image_1'));
      Finder articleSimilarName1 =
          find.byKey(const Key('article-similar_name_1'));
      Finder articleSimilarPrice1 =
          find.byKey(const Key('article-similar_price_1'));
      await tester.pumpAndSettle();

      expect(similarArticleTitle, findsOneWidget);
      expect(articleSimilarImage1, findsOneWidget);
      expect(articleSimilarName1, findsOneWidget);
      expect(articleSimilarPrice1, findsOneWidget);
    },
  );
}
