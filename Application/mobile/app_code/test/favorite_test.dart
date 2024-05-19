import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/favorite/favorite_page.dart';

import 'globals.dart';

void main() {
  group('Test FavoritePage', () {
    testWidgets('Favorite Page UI, no favorites', (WidgetTester tester) async {
      final testPage = initPage(const FavoritePage(testFavorites: []));
      await waitForLoader(tester: tester, testPage: testPage);

      Finder favoriteTitle = find.byKey(const Key('my-favorites-titles'));
      Finder favoriteList = find.byKey(const Key('favorites-list_empty'));

      expect(favoriteTitle, findsOneWidget);
      expect(favoriteList, findsOneWidget);
    });

    testWidgets('Favorite Page UI, 1 favorite', (WidgetTester tester) async {
      const List<dynamic> favorites = [
        {
          'id': 2,
          'item': {
            'id': 1,
            'name': 'Ballon de volley',
            'price': 0.5,
            'available': true,
            'container': {
              'id': 1,
              'address': 'Rue d\'Alger',
              'city': 'Nantes',
            }
          }
        },
        {
          'id': 3,
          'item': {
            'id': 2,
            'name': 'Ballon de volley',
            'price': 0.5,
            'available': false,
            'container': {
              'id': 1,
              'address': 'Rue d\'Alger',
              'city': 'Nantes',
            }
          }
        }
      ];
      final testPage = initPage(const FavoritePage(testFavorites: favorites));
      await waitForLoader(tester: tester, testPage: testPage);

      Finder favoriteCard1 = find.byKey(const Key('favorite-card_0'));
      Finder favoriteImage1 = find.byKey(const Key('favorite-image_0'));
      Finder favoriteName1 = find.byKey(const Key('favorite-name_0'));
      Finder favoritePrice1 = find.byKey(const Key('favorite-price_0'));
      Finder favoriteStatus1 = find.byKey(const Key('favorite-status_0'));
      Finder favoriteStatusCircle1 =
          find.byKey(const Key('favorite-status_circle_0'));
      Finder favoriteStatusText1 =
          find.byKey(const Key('favorite-status_text_0'));
      Finder favoriteStatus2 = find.byKey(const Key('favorite-status_1'));
      Finder favoriteStatusCircle2 =
          find.byKey(const Key('favorite-status_circle_1'));
      Finder favoriteStatusText2 =
          find.byKey(const Key('favorite-status_text_1'));
      Finder favoriteArrow1 = find.byKey(const Key('favorite-arrow_0'));
      Finder favoriteButtonHeart1 =
          find.byKey(const Key('favorite-button_heart_0'));

      expect(favoriteCard1, findsOneWidget);
      expect(favoriteImage1, findsOneWidget);
      expect(favoriteName1, findsOneWidget);
      expect(favoritePrice1, findsOneWidget);
      expect(favoriteStatus1, findsOneWidget);
      expect(favoriteStatusCircle1, findsOneWidget);
      expect(favoriteStatusText1, findsOneWidget);
      expect(favoriteStatus2, findsOneWidget);
      expect(favoriteStatusCircle2, findsOneWidget);
      expect(favoriteStatusText2, findsOneWidget);
      expect(favoriteArrow1, findsOneWidget);
      expect(favoriteButtonHeart1, findsOneWidget);

      await tester.tap(favoriteButtonHeart1);
      await tester.pumpAndSettle();
    });

    testWidgets('Favorite Page UI, 1 favorite', (WidgetTester tester) async {
      const List<dynamic> favorites = [
        {
          'id': 2,
          'item': {
            'id': 1,
            'name': 'Ballon de volley',
            'price': 0.5,
            'available': true,
            'container': {
              'id': 1,
              'address': 'Rue d\'Alger',
              'city': 'Nantes',
            }
          }
        }
      ];
      final testPage = initPage(const FavoritePage(testFavorites: favorites));
      await waitForLoader(tester: tester, testPage: testPage);

      Finder favoriteCard1 = find.byKey(const Key('favorite-card_0'));

      expect(favoriteCard1, findsOneWidget);

      await tester.tap(favoriteCard1);
    });
  });
}
