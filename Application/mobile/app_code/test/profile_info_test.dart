import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';

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

    Finder logoFinder = find.byKey(const Key('appbar-image_logo'));
    Finder infoTextFinder =
        find.byKey(const Key('profile_info-text_informations'));
    Finder firstNameFinder =
        find.byKey(const Key('profile_info-text_field_firstname'));
    Finder lastNameFinder =
        find.byKey(const Key('profile_info-text_field_lastname'));
    Finder emailFinder = find.byKey(const Key('profile_info-text_field_email'));
    Finder updateInformationButtonFinder =
        find.byKey(const Key('profile_info-button_update'));
    Finder passwordTextFinder =
        find.byKey(const Key('profile_info-text_password'));
    Finder passwordFinder =
        find.byKey(const Key('profile_info-text_field_current_password'));
    Finder newPasswordFinder =
        find.byKey(const Key('profile_info-text_field_new_password'));
    Finder newPasswordConfirmationFinder = find
        .byKey(const Key('profile_info-text_field_new_password_confirmation'));
    Finder updatePasswordButtonFinder =
        find.byKey(const Key('profile_info-button_update_password'));

    Finder okButtonFinder = find.byKey(const Key('alertdialog-button_ok'));

    testWidgets('UI elements', (WidgetTester tester) async {
      userInformation = initExampleUser();
      final testPage = initPage(const ProfileInformationsPage());
      await waitForLoader(tester: tester, testPage: testPage);

      expect(logoFinder, findsOneWidget);
      expect(infoTextFinder, findsOneWidget);
      expect(firstNameFinder, findsOneWidget);
      expect(lastNameFinder, findsOneWidget);
      expect(emailFinder, findsOneWidget);
      expect(updateInformationButtonFinder, findsOneWidget);
      expect(passwordTextFinder, findsOneWidget);
      expect(passwordFinder, findsOneWidget);
      expect(newPasswordFinder, findsOneWidget);
      expect(newPasswordConfirmationFinder, findsOneWidget);
      expect(updatePasswordButtonFinder, findsOneWidget);
      expect(find.text(userInformation!.firstName!), findsOneWidget);
      expect(find.text(userInformation!.lastName!), findsOneWidget);
      expect(find.text(userInformation!.email), findsOneWidget);
    });

    testWidgets('UI expected behavior', (WidgetTester tester) async {
      userInformation = initExampleUser();
      final testPage = initPage(const ProfileInformationsPage());
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.enterText(firstNameFinder, 'firstNameTest');
      await tester.enterText(lastNameFinder, 'lastNameTest');
      await tester.enterText(emailFinder, 'emailTest@gmail.com');
      await tester.tap(updateInformationButtonFinder);
      await tester.pumpAndSettle();

      await tester.enterText(passwordFinder, 'current_password');
      await tester.enterText(newPasswordFinder, 'new_password');
      await tester.enterText(newPasswordConfirmationFinder, 'new_password');
      // await tester.tap(updatePasswordButtonFinder);
      await tester.pumpAndSettle();

      expect(okButtonFinder, findsOneWidget);
      await tester.tap(okButtonFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('UI unexpected behavior', (WidgetTester tester) async {
      userInformation = initExampleUser();
      final testPage = initPage(const ProfileInformationsPage());
      await waitForLoader(tester: tester, testPage: testPage);

      await tester.enterText(firstNameFinder, '');
      await tester.enterText(lastNameFinder, '');
      await tester.enterText(emailFinder, '');
      await tester.tap(updateInformationButtonFinder);
      await tester.pumpAndSettle();

      expect(okButtonFinder, findsOneWidget);
      await tester.tap(okButtonFinder);
      await tester.pumpAndSettle();

      await tester.enterText(emailFinder, 'invalid_email');
      await tester.tap(updateInformationButtonFinder);
      await tester.pumpAndSettle();
      expect(okButtonFinder, findsOneWidget);
      await tester.tap(okButtonFinder);
      await tester.pumpAndSettle();

      await tester.pumpAndSettle();

      await tester.enterText(passwordFinder, 'current_password');
      await tester.pumpAndSettle();

      await tester.enterText(newPasswordFinder, 'new_password');
      await tester.pumpAndSettle();

      await tester.enterText(newPasswordConfirmationFinder, 'wrong_password');
      await tester.pumpAndSettle();
    });
  });
}
