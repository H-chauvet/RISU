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
}
