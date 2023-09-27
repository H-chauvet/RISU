import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

void main() {
  testWidgets('Logged in user should see HomePage',
      (WidgetTester tester) async {
    userInformation = UserData(email: 'example@gmail.com');
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

    // Verify that the HomePage is displayed
    expect(find.byType(BottomNavBar), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    await tester.tap(find.byType(BottomNavBar));
    await tester.pumpAndSettle();
  });

  testWidgets('Logged out user should see LoginPage',
      (WidgetTester tester) async {
    // Mock necessary dependencies
    // Mock the user being logged out
    // Set up necessary providers
    userInformation = null;
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

    // Verify that the LoginPage is displayed
    expect(find.byType(LoginPage), findsOneWidget);
  });

  // Add more test cases for other scenarios
}
