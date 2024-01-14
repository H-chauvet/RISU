import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('ArticleListData integration test', () {
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
          id: 'id',
          containerId: 'containerId',
          name: 'name',
          available: true,
          price: 3);
      expect(articleListData.id, 'id');
      expect(articleListData.containerId, 'containerId');
      expect(articleListData.name, 'name');
      expect(articleListData.available, true);
      expect(articleListData.price, 3);
    });

    test('ArticleListData constructor should create an instance from json', () {
      dynamic json = {
        'id': 'id',
        'containerId': 'containerId',
        'name': 'name',
        'available': true,
        'price': 3
      };
      final articleListData = ArticleData.fromJson(json);
      expect(articleListData.id, 'id');
      expect(articleListData.containerId, 'containerId');
      expect(articleListData.name, 'name');
      expect(articleListData.available, true);
      expect(articleListData.price, 3);
    });

    test('ArticleListData toMap should return data as json', () {
      final articleListData = ArticleData(
          id: 'id',
          containerId: 'containerId',
          name: 'name',
          available: true,
          price: 3);
      dynamic json = articleListData.toMap();
      expect(json['id'], 'id');
      expect(json['containerId'], 'containerId');
      expect(json['name'], 'name');
      expect(json['available'], true);
      expect(json['price'], 3);
    });

    testWidgets('ArticleDataCard should show from ArticleData',
    (WidgetTester tester) async {
      final articleListData = ArticleData(
          id: 'id',
          containerId: 'containerId',
          name: 'name',
          available: true,
          price: 3);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: MaterialApp(
            home: ArticleDataCard(articleData: articleListData),
          ),
        ),
      );

      Finder articleButton = find.byKey(const Key('articles-list_card'));
      expect(articleButton, findsOneWidget);
      await tester.tap(articleButton);
      await tester.pumpAndSettle();
    }
  );
  });
}
