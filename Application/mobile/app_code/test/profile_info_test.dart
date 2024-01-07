import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/utils/theme.dart';

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

  testWidgets('Profile Info user widgets with values',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );

        // FIRST NAME
        Finder nameField =
        find.byKey(const Key('profile_info-text_field-new_name'));
        expect(nameField, findsOneWidget);
        await tester.enterText(nameField, "new name");
        await tester.pumpAndSettle();

        Finder updateName =
        find.byKey(const Key('profile_info-button-update_firstName'));
        expect(updateName, findsOneWidget);
        await tester.tap(updateName);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_firstName')),
            findsNothing);

        // LAST NAME
        Finder lastNameField =
        find.byKey(const Key('profile_info-text_field-last_name'));
        expect(lastNameField, findsOneWidget);
        await tester.enterText(lastNameField, "new last name");
        await tester.pumpAndSettle();

        Finder updateLastName =
        find.byKey(const Key('profile_info-button-update_last_name'));
        expect(updateLastName, findsOneWidget);
        await tester.tap(updateLastName);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_last_name')),
            findsNothing);

        // E MAIL
        Finder emailField = find.byKey(
            const Key('profile_info-text_field-email'));
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, "test@test.com");
        await tester.pumpAndSettle();

        Finder updateEmail =
        find.byKey(const Key('profile_info-button-update_email'));
        expect(updateEmail, findsOneWidget);

        await tester.dragUntilVisible(
            updateEmail, // what you want to find
            updateLastName, // widget you want to scroll
            const Offset(0, -100) // delta to move
        );
        await tester.tap(updateEmail);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_email')),
            findsNothing);

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

        await tester.dragUntilVisible(
            newPasswordField, // what you want to find
            updateLastName, // widget you want to scroll
            const Offset(0, -300) // delta to move
        );

        await tester.enterText(currPasswordField, "curr");
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

  testWidgets('Profile Info user widgets with empty name',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );
        Finder updateName =
        find.byKey(const Key('profile_info-button-update_firstName'));
        expect(updateName, findsOneWidget);
        await tester.tap(updateName);
        await tester.pumpAndSettle();

        Finder alertDialogName =
        find.byKey(const Key('profile_info-alert_dialog-no_firstName'));

        expect(alertDialogName, findsOneWidget);
      });

  testWidgets('Profile Info user widgets with empty last name',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );
        Finder updateLastName =
        find.byKey(const Key('profile_info-button-update_last_name'));
        expect(updateLastName, findsOneWidget);
        await tester.tap(updateLastName);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_last_name')),
            findsOneWidget);
      });
  testWidgets('Profile Info user widgets with empty email',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );
        Finder updateLastName =
        find.byKey(const Key('profile_info-button-update_last_name'));
        expect(updateLastName, findsOneWidget);

        Finder updateEmail =
        find.byKey(const Key('profile_info-button-update_email'));
        expect(updateEmail, findsOneWidget);

        await tester.dragUntilVisible(
            updateEmail, // what you want to find
            updateLastName, // widget you want to scroll
            const Offset(0, -100) // delta to move
        );

        await tester.tap(updateEmail);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_email')),
            findsOneWidget);
      });

  testWidgets('Profile Info user widgets with empty password',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );
        Finder updateLastName =
        find.byKey(const Key('profile_info-button-update_last_name'));
        expect(updateLastName, findsOneWidget);

        Finder updatePassword =
        find.byKey(const Key('profile_info-button-update_password'));
        expect(updatePassword, findsOneWidget);

        await tester.dragUntilVisible(
            updatePassword, // what you want to find
            updateLastName, // widget you want to scroll
            const Offset(0, -300) // delta to move
        );

        await tester.tap(updatePassword);
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('profile_info-alert_dialog-no_password')),
            findsOneWidget);
      });

  testWidgets('Profile Info user widgets with different new passwords',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(
                        false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfileInformationsPage(),
            ),
          ),
        );
        Finder updateLastName =
        find.byKey(const Key('profile_info-button-update_last_name'));
        expect(updateLastName, findsOneWidget);

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
            updateLastName, // widget you want to scroll
            const Offset(0, -300) // delta to move
        );

        await tester.enterText(currPasswordField, "curr");
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
