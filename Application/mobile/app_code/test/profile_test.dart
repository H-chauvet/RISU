import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

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

  testWidgets('Profile page with complete user info (Settings)',
      (WidgetTester tester) async {
    userInformation = UserData(
        email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) =>
                ThemeProvider(false), // Provide a default value for testing.
          ),
        ],
        child: const MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );
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
    Finder buttonRent = find.byKey(const Key('profile-button-my_rentals_button'));
    expect(buttonRent, findsOneWidget);

    await tester.tap(buttonSettings);
    await tester.pumpAndSettle();
  });

  testWidgets('Profile page, test the rental button',
          (WidgetTester tester) async {
        userInformation = UserData(
            email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
        await tester.pumpWidget(
          MultiProvider(
            providers: [
              ChangeNotifierProvider<ThemeProvider>(
                create: (_) =>
                    ThemeProvider(false), // Provide a default value for testing.
              ),
            ],
            child: const MaterialApp(
              home: ProfilePage(),
            ),
          ),
        );
        expect(find.text('Mes locations'), findsOneWidget);
        Finder buttonRent = find.byKey(const Key('profile-button-my_rentals_button'));
        expect(buttonRent, findsOneWidget);

        await tester.tap(buttonRent);
        await tester.pumpAndSettle();
      });

  testWidgets('Profile page with complete user info (Log out)',
      (WidgetTester tester) async {
    userInformation = UserData(
        email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) =>
                ThemeProvider(false), // Provide a default value for testing.
          ),
        ],
        child: const MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );
    Finder buttonLogOut =
        find.byKey(const Key('profile-button-log_out_button'));
    expect(buttonLogOut, findsOneWidget);

    await tester.tap(buttonLogOut);
    await tester.pumpAndSettle();
  });

  testWidgets('Profile page with no user info', (WidgetTester tester) async {
    userInformation =
        UserData(email: 'example@gmail.com', firstName: null, lastName: null);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) =>
                ThemeProvider(false), // Provide a default value for testing.
          ),
        ],
        child: const MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );
    Finder buttonToComplete =
        find.byKey(const Key('profile-button-complete_button'));
    expect(buttonToComplete, findsOneWidget);

    await tester.tap(buttonToComplete);
    await tester.pumpAndSettle();
  });
}
