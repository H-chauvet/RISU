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
      Finder articleCategoryIcons1 =
          find.byKey(const Key('article_categories_icons'));
      await tester.pumpAndSettle();

      expect(similarArticleTitle, findsOneWidget);
      expect(articleSimilarImage1, findsOneWidget);
      expect(articleSimilarName1, findsOneWidget);
      expect(articleSimilarPrice1, findsOneWidget);
      expect(articleCategoryIcons1, findsOneWidget);
    },
  );

  testWidgets(
    'Similar articles',
    (WidgetTester tester) async {
      final item1 = {
        "id": -1,
        "name": "Ballon de volley",
        "containerId": -1,
        "price": 0.5,
        "available": true,
        "categories": []
      };

      await tester.pumpWidget(
        initPage(
          ArticleDetailsPage(
            articleId: 1,
            testArticleData: item1,
          ),
        ),
      );
      await tester.pumpAndSettle();

      Finder gestureFavorite =
          find.byKey(const Key("article-button_add-favorite"));

      expect(gestureFavorite, findsOneWidget);

      await tester.tap(gestureFavorite);
    },
  );

  testWidgets('Article details touching rent button',
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
    await tester.pumpAndSettle();

    Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));
    Finder rentData = find.byKey(const Key('article-button_article-rent'));

    expect(rentData, findsOneWidget);
    expect(appBarTitleData, findsOneWidget);

    await tester.tap(rentData);
    await tester.pumpAndSettle();
  });

  testWidgets('Article details with test data', (WidgetTester tester) async {
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
    await tester.pumpAndSettle();

    Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));

    Finder consultArticle =
        find.byKey(const Key('article-button_article-opinion'));

    expect(consultArticle, findsOneWidget);
    expect(appBarTitleData, findsOneWidget);

    await tester.dragUntilVisible(
        consultArticle, // what you want to find
        appBarTitleData, // widget you want to scroll
        const Offset(0, -300) // delta to move
        );
    await tester.tap(consultArticle);
    await tester.pumpAndSettle();
  });

  testWidgets(
    'Article details touching rent button',
    (WidgetTester tester) async {
      final testPage = ArticleDetailsState();
      userInformation = initExampleUser();
      testPage.checkFavorite(-1);
      testPage.deleteFavorite(-1);
      testPage.createFavorite(-1);
    },
  );
}
