import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  testWidgets('Profile Info user widgets with information empty fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ProfileInformationsPage()));

    // FIRST NAME
    Finder nameField =
        find.byKey(const Key('profile_info-text_field-new_name'));
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, "");
    await tester.pumpAndSettle();

    // LAST NAME
    Finder lastNameField =
        find.byKey(const Key('profile_info-text_field-last_name'));
    expect(lastNameField, findsOneWidget);
    await tester.enterText(nameField, "");
    await tester.pumpAndSettle();

    // EMAIL
    Finder emailField = find.byKey(const Key('profile_info-text_field-email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, "");
    await tester.pumpAndSettle();

    Finder updateInfo =
        find.byKey(const Key('informations-button_update_user'));
    expect(updateInfo, findsOneWidget);
    await tester.tap(updateInfo);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('informations-alert_dialog_error_no_info')),
        findsOneWidget);
  });

  testWidgets('Profile Info user widgets with values',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ProfileInformationsPage()));

    // FIRST NAME
    Finder nameField =
        find.byKey(const Key('profile_info-text_field-new_name'));
    expect(nameField, findsOneWidget);
    await tester.enterText(nameField, "new name");
    await tester.pumpAndSettle();

    // LAST NAME
    Finder lastNameField =
        find.byKey(const Key('profile_info-text_field-last_name'));
    expect(lastNameField, findsOneWidget);
    await tester.enterText(lastNameField, "new last name");
    await tester.pumpAndSettle();

    // EMAIL
    Finder emailField = find.byKey(const Key('profile_info-text_field-email'));
    expect(emailField, findsOneWidget);
    await tester.enterText(emailField, "test@test.com");
    await tester.pumpAndSettle();

    Finder updateInfos =
        find.byKey(const Key('informations-button_update_user'));
    expect(updateInfos, findsOneWidget);
    await tester.tap(updateInfos);
    await tester.pumpAndSettle();

    // PASSWORD
    Finder currPasswordField =
        find.byKey(const Key('profile_info-text_field-curr_password'));
    expect(currPasswordField, findsOneWidget);

    Finder newPasswordField =
        find.byKey(const Key('profile_info-text_field-new_password'));
    expect(newPasswordField, findsOneWidget);

    Finder newPasswordFieldConf =
        find.byKey(const Key('profile_info-text_field-new_password_conf'));
    expect(newPasswordFieldConf, findsOneWidget);

    // scroll down to the button
    await tester.dragUntilVisible(
        newPasswordField, // what you want to find
        updateInfos, // widget you want to scroll
        const Offset(0, -300) // delta to move
        );

    await tester.enterText(currPasswordField, "admin");
    await tester.pumpAndSettle();
    await tester.enterText(newPasswordField, "newOne");
    await tester.pumpAndSettle();
    await tester.enterText(newPasswordFieldConf, "newOne");
    await tester.pumpAndSettle();

    Finder updatePassword =
        find.byKey(const Key('profile_info-button-update_password'));
    expect(updatePassword, findsOneWidget);
    await tester.tap(updatePassword);
    await tester.pumpAndSettle();
  });

  testWidgets('Profile Info user widgets with empty password',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ProfileInformationsPage()));
    Finder updateInfo =
        find.byKey(const Key('informations-button_update_user'));
    expect(updateInfo, findsOneWidget);

    Finder updatePassword =
        find.byKey(const Key('profile_info-button-update_password'));
    expect(updatePassword, findsOneWidget);

    await tester.dragUntilVisible(
        updatePassword, // what you want to find
        updateInfo, // widget you want to scroll
        const Offset(0, -300) // delta to move
        );

    await tester.tap(updatePassword);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profile_info-alert_dialog-no_password')),
        findsOneWidget);
  });

  testWidgets('Profile Info user widgets with different new passwords',
      (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ProfileInformationsPage()));
    Finder updateInfo =
        find.byKey(const Key('informations-button_update_user'));
    expect(updateInfo, findsOneWidget);

    Finder currPasswordField =
        find.byKey(const Key('profile_info-text_field-curr_password'));
    expect(currPasswordField, findsOneWidget);

    Finder newPasswordField =
        find.byKey(const Key('profile_info-text_field-new_password'));
    expect(newPasswordField, findsOneWidget);

    Finder newPasswordFieldConf =
        find.byKey(const Key('profile_info-text_field-new_password_conf'));
    expect(newPasswordFieldConf, findsOneWidget);

    Finder updatePassword =
        find.byKey(const Key('profile_info-button-update_password'));
    expect(updatePassword, findsOneWidget);

    await tester.dragUntilVisible(
        updatePassword, // what you want to find
        updateInfo, // widget you want to scroll
        const Offset(0, -300) // delta to move
        );

    await tester.enterText(currPasswordField, "admin");
    await tester.pumpAndSettle();
    await tester.enterText(newPasswordField, "newOne1");
    await tester.pumpAndSettle();
    await tester.enterText(newPasswordFieldConf, "newOne2");
    await tester.pumpAndSettle();

    await tester.tap(updatePassword);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('profile_info-alert_dialog-diff_password')),
        findsOneWidget);
  });
}
