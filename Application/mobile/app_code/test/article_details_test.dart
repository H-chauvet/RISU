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
    'Article details touching rent button',
    (WidgetTester tester) async {
      final testPage = ArticleDetailsState();
      userInformation = initExampleUser();
      testPage.checkFavorite(-1);
      testPage.deleteFavorite(-1);
      testPage.createFavorite(-1);
    },
  );

  testWidgets(
    'Article with test data',
    (WidgetTester tester) async {
      Map<String, dynamic> testData = {
        "id": -1,
        "containerId": -1,
        "name": '',
        "available": false,
        "price": 0,
        "categories": [],
        "status": "GOOD",
        "imagesUrl": ['', ''],
      };

      Map<String, dynamic> testOpinion = {
        'user': {'firstName': 'Nathan', 'lastName': 'Rousseau'},
        'note': '5',
        'comment': 'Test Comment'
      };

      List<dynamic> testSimilar = [testData];

      final testPage = initPage(ArticleDetailsPage(
        articleId: -1,
        testArticleData: testData,
        similarArticlesData: testSimilar,
        testOpinionList: [testOpinion],
      ));
      await waitForLoader(tester: tester, testPage: testPage);
      await tester.pumpWidget(testPage);
    },
  );
}
