import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/article_list_data.dart';

import 'globals.dart';

void main() {
  group(
    'ArticleListData integration test',
    () {
      setUpAll(() async {
        // This code runs once before all the tests.
        WidgetsFlutterBinding.ensureInitialized();
        WidgetController.hitTestWarningShouldBeFatal = true;
      });

      tearDown(() {
        // This code runs after each test case.
      });

      test('ArticleListData constructor should create an instance', () {
        final articleListData = ArticleData(
            id: 0,
            containerId: 0,
            name: 'name',
            available: true,
            price: 3,
            categories: []);
        expect(articleListData.id, 0);
        expect(articleListData.containerId, 0);
        expect(articleListData.name, 'name');
        expect(articleListData.available, true);
        expect(articleListData.price, 3);
      });

      test('ArticleListData constructor should create an instance from json',
          () {
        dynamic json = {
          'id': 0,
          'containerId': 0,
          'name': 'name',
          'available': true,
          'price': 300,
          'categories': [],
        };
        final articleListData = ArticleData.fromJson(json);
        expect(articleListData.id, 0);
        expect(articleListData.containerId, 0);
        expect(articleListData.name, 'name');
        expect(articleListData.available, true);
        expect(articleListData.price, 3);
      });

      test('ArticleListData toMap should return data as json', () {
        final articleListData = ArticleData(
          id: 0,
          containerId: 1,
          name: 'name',
          available: true,
          price: 3,
          categories: [],
        );
        dynamic json = articleListData.toMap();
        expect(json['id'], 0);
        expect(json['containerId'], 1);
        expect(json['name'], 'name');
        expect(json['available'], true);
        expect(json['price'], 3);
      });

      testWidgets(
        'ArticleDataCard should show from ArticleData',
        (WidgetTester tester) async {
          final articleListData = ArticleData(
            id: 0,
            containerId: 1,
            name: 'name',
            available: true,
            price: 3,
            categories: [],
          );
          await tester.pumpWidget(
              initPage(ArticleDataCard(articleData: articleListData)));

          Finder articleButton = find.byKey(const Key('articles-list_card'));
          expect(articleButton, findsOneWidget);
          await tester.tap(articleButton);
          await tester.pumpAndSettle();
        },
      );
    },
  );
}
