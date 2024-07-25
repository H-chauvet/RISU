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

      expect(titleData, findsOneWidget);
      expect(appBarTitleData, findsOneWidget);
      expect(titleData, findsOneWidget);
      expect(favoriteData, findsOneWidget);
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

      await tester
          .ensureVisible(find.byKey(Key('article-button_add-favorite')));

      await tester.pumpAndSettle();

      await tester.dragUntilVisible(
        gestureFavorite,
        find.byType(Scrollable),
        const Offset(0, 300),
      );

      expect(gestureFavorite, findsOneWidget);

      await tester.tap(gestureFavorite, warnIfMissed: false);
    },
  );

  testWidgets('Article details, change images buttons',
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

    Finder articleImage = find.byKey(const Key('article-image'));
    Finder buttonPreviousImage =
        find.byKey(const Key('article-button_previous_image'));
    Finder buttonNextImage = find.byKey(const Key('article-button_next_image'));
    Finder articleImageIndicator =
        find.byKey(const Key('article-image_indicator_0'));

    expect(articleImage, findsOneWidget);
    expect(buttonPreviousImage, findsOneWidget);

    //scroll to the button buttonPreviousImage
    await tester.ensureVisible(buttonPreviousImage);
    await tester.ensureVisible(buttonNextImage);

    await tester.dragUntilVisible(
      buttonPreviousImage,
      find.byType(Scrollable),
      const Offset(0, 300),
    );
    await tester.dragUntilVisible(
      buttonNextImage,
      find.byType(Scrollable),
      const Offset(0, 300),
    );

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
