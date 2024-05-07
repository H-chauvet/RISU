import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/list_page.dart';

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

  testWidgets('Container details should not be displayed from empty id',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ArticleListPage(containerId: -1)));

    Finder articleCard = find.byKey(const Key('articles-list_card'));
    Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));

    expect(articleCard, findsNothing);
    expect(appBarTitleData, findsOneWidget);
  });

  testWidgets('Container details empty page after loading',
      (WidgetTester tester) async {
    final testPage = initPage(const ArticleListPage(containerId: -1));
    waitForLoader(tester: tester, testPage: testPage);
  });

  testWidgets('Container details with test data', (WidgetTester tester) async {
    final item1 = {
      "id": -1,
      "name": "Ballon de volley",
      "containerId": -1,
      "price": 0.5,
      "available": true,
      "categories": []
    };

    final item2 = {
      "id": -1,
      "name": "Raquette",
      "containerId": -1,
      "price": 10.5,
      "available": false,
      "categories": []
    };

    List<dynamic> testData = [item1, item2, item1, item2];

    final testPage =
        initPage(ArticleListPage(containerId: -1, testItemData: testData));
    await tester.pumpWidget(testPage);
  });
}
