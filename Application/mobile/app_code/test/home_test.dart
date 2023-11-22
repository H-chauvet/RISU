import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Logged in user should see HomePage',
      (WidgetTester tester) async {
    userInformation = UserData(
        email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    await tester.tap(find.byType(BottomNavBar));
    await tester.pumpAndSettle();
  });

  testWidgets(
      'Logged in but without firstName and lastName, cancel the alert dialog',
      (WidgetTester tester) async {
    userInformation =
        UserData(email: 'example@gmail.com', firstName: null, lastName: null);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    Finder cancelButton = find.byKey(const Key('alertdialog-button_cancel'));
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();
  });

  testWidgets(
      'Logged in but without firstName and lastName, accept the alert dialog',
      (WidgetTester tester) async {
    userInformation =
        UserData(email: 'example@gmail.com', firstName: null, lastName: null);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(AlertDialog), findsOneWidget);
    Finder okButton = find.byKey(const Key('alertdialog-button_ok'));
    await tester.tap(okButton);
    await tester.pumpAndSettle();
  });
}
