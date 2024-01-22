import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_state.dart';

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

  testWidgets('Check the page content', (WidgetTester tester) async {
    userInformation = initExampleUser();
    await tester.pumpWidget(initPage(const NotificationsPage()));

    expect(find.text("Gestion des notifications"), findsOneWidget);
    expect(find.text("Disponibilité d'un article favoris"), findsOneWidget);
    expect(find.text("Fin de ma location"), findsOneWidget);
    expect(find.text("Actus, offres et conseils de Risu"), findsOneWidget);
    expect(find.text("Tous"), findsOneWidget);
    expect(find.byType(Switch), findsNWidgets(4));
  });

  testWidgets('isAllChecked value', (WidgetTester tester) async {
    userInformation = initExampleUser(notifications: [
      false,
      false,
      false,
    ]);
    await tester.pumpWidget(initPage(const NotificationsPage()));
  });
  testWidgets('Check the variables update', (WidgetTester tester) async {
    userInformation = initExampleUser();
    await tester.pumpWidget(initPage(const NotificationsPage()));

    final Finder switchDisponibilityFinder =
        find.byKey(const Key("notifications-switch_disponibility_favorite"));
    final Finder switchEndRentingFinder =
        find.byKey(const Key("notifications-switch_end_renting"));
    final Finder switchNewsOffersFinder =
        find.byKey(const Key("notifications-switch_news_offers_risu"));
    final Finder switchAllFinder =
        find.byKey(const Key("notifications-switch_all"));
    final Finder buttonSaveFinder =
        find.byKey(const Key("notifications-button_save"));

    // Check all Switch
    expect(switchDisponibilityFinder, findsOneWidget);
    expect(switchEndRentingFinder, findsOneWidget);
    expect(switchNewsOffersFinder, findsOneWidget);
    expect(switchAllFinder, findsOneWidget);
    // Check the save button
    expect(buttonSaveFinder, findsOneWidget);

    expect(NotificationsPageState.isAllChecked, isFalse);

    // Check the behavior of the switch
    expect(NotificationsPageState.isFavoriteItemsAvailableChecked, isFalse);
    await tester.tap(switchDisponibilityFinder);
    await tester.pumpAndSettle();
    expect(NotificationsPageState.isFavoriteItemsAvailableChecked, isTrue);

    // Check the behavior of the switch
    expect(NotificationsPageState.isEndOfRentingChecked, isFalse);
    await tester.tap(switchEndRentingFinder);
    await tester.pumpAndSettle();
    expect(NotificationsPageState.isEndOfRentingChecked, isTrue);

    // Check the behavior of the switch
    expect(NotificationsPageState.isNewsOffersChecked, isFalse);
    await tester.tap(switchNewsOffersFinder);
    await tester.pumpAndSettle();
    expect(NotificationsPageState.isNewsOffersChecked, isTrue);

    // Check the behavior of the switch
    expect(NotificationsPageState.isAllChecked, isTrue);
    await tester.tap(switchAllFinder);
    await tester.pumpAndSettle();
    expect(NotificationsPageState.isAllChecked, isFalse);
    expect(NotificationsPageState.isNewsOffersChecked, isFalse);
    expect(NotificationsPageState.isEndOfRentingChecked, isFalse);
    expect(NotificationsPageState.isFavoriteItemsAvailableChecked, isFalse);

    // Check the behavior of the save button
    await tester.tap(buttonSaveFinder);
    await tester.pumpAndSettle();
  });
}
