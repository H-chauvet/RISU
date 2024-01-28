import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/profile/profile_page.dart';

import 'globals.dart';

void main() {
  group('Test profile page', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Profile page with complete user info (Settings)',
        (WidgetTester tester) async {
      userInformation = initExampleUser();
      await tester.pumpWidget(initPage(const ProfilePage()));

      Finder profilePhotoUser =
          find.byKey(const Key('profile-profile_photo-user_photo'));
      expect(profilePhotoUser, findsOneWidget);
      Finder buttonToComplete =
          find.byKey(const Key('profile-button-complete_button'));
      expect(buttonToComplete, findsNothing);

      Finder buttonSettings =
          find.byKey(const Key('profile-button-settings_button'));
      expect(buttonSettings, findsOneWidget);

      expect(find.text('Mes locations'), findsOneWidget);
      Finder buttonRent =
          find.byKey(const Key('profile-button-my_rentals_button'));
      expect(buttonRent, findsOneWidget);

      await tester.tap(buttonSettings);
      await tester.pumpAndSettle();
    });

    testWidgets('Profile page, test the rental button',
        (WidgetTester tester) async {
      userInformation = initExampleUser();
      await tester.pumpWidget(initPage(const ProfilePage()));

      expect(find.text('Mes locations'), findsOneWidget);
      Finder buttonRent =
          find.byKey(const Key('profile-button-my_rentals_button'));
      expect(buttonRent, findsOneWidget);

      await tester.tap(buttonRent);
      await tester.pump();
    });

    testWidgets('Profile page with complete user info (Log out)',
        (WidgetTester tester) async {
      userInformation = initExampleUser();
      await tester.pumpWidget(initPage(const ProfilePage()));

      Finder buttonLogOut =
          find.byKey(const Key('profile-button-log_out_button'));
      expect(buttonLogOut, findsOneWidget);

      await tester.tap(buttonLogOut);
      await tester.pumpAndSettle();
    });

    testWidgets('Profile page with no user info', (WidgetTester tester) async {
      userInformation = initNullUser();
      await tester.pumpWidget(initPage(const ProfilePage()));

      Finder buttonToComplete =
          find.byKey(const Key('profile-button-complete_button'));
      expect(buttonToComplete, findsOneWidget);

      await tester.tap(buttonToComplete);
      await tester.pump();
    });
  });
}
