import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/favorite/favorite_page.dart';

import 'globals.dart';

void main() {
  group('Test FavoritePage', () {
    testWidgets('Favorite Page UI', (WidgetTester tester) async {
      final testPage = initPage(const FavoritePage());
      await waitForLoader(tester: tester, testPage: testPage);
      BuildContext context = tester.element(find.byType(FavoritePage));

      expect(
          find.text(AppLocalizations.of(context)!.myFavorites), findsOneWidget);
      expect(find.text(AppLocalizations.of(context)!.favoritesListEmpty),
          findsOneWidget);
    });
  });
}
