import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/article_filters_page.dart';

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

  testWidgets('Article filters page should be displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(
      const ArticleFiltersPage(
        isAscending: true,
        isAvailable: true,
        selectedCategoryId: null,
        sortBy: 'price',
        articleCategories: [
          {'id': 1, 'name': 'Sport'},
          {'id': 2, 'name': 'Plage'}
        ],
      ),
    ));

    Finder sortBy = find.byKey(const Key('filter-text_sortBy'));
    Finder ascendingPrice =
        find.byKey(const Key('filter-radio_priceAscending'));
    Finder descendingPrice =
        find.byKey(const Key('filter-radio_priceDescending'));
    Finder ascendingNote = find.byKey(const Key('filter-radio_noteAscending'));
    Finder descendingNote =
        find.byKey(const Key('filter-radio_noteDescending'));
    Finder minInput = find.byKey(const Key('filter-input_min'));
    Finder maxInput = find.byKey(const Key('filter-input_max'));
    Finder switchAvailable = find.byKey(const Key('filter-switch_available'));
    Finder filterApply = find.byKey(const Key('filter-button_apply'));

    expect(sortBy, findsOneWidget);
    expect(ascendingPrice, findsOneWidget);
    expect(descendingPrice, findsOneWidget);
    expect(ascendingNote, findsOneWidget);
    expect(descendingNote, findsOneWidget);
    expect(minInput, findsOneWidget);
    expect(maxInput, findsOneWidget);
    expect(switchAvailable, findsOneWidget);
    expect(filterApply, findsOneWidget);

    await tester.tap(ascendingPrice);
    await tester.tap(descendingPrice);
    await tester.tap(ascendingNote);
    await tester.tap(descendingNote);
    await tester.enterText(minInput, '1');
    await tester.enterText(maxInput, '5');

    await tester.ensureVisible(switchAvailable);
    await tester.tap(switchAvailable);
    await tester.tap(filterApply);
  });
}
