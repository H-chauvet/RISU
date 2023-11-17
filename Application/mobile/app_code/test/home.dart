import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

void main() {
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

  testWidgets('Logged out user should see LoginPage',
      (WidgetTester tester) async {
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

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('Valid login should navigate to HomePage',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Enter valid credentials and tap "Se connecter" button
    await tester.enterText(find.byKey(const Key('login-textinput_email')),
        'valid_email@example.com');
    await tester.enterText(
        find.byKey(const Key('login-textinput_password')), 'valid_password');
    await tester.tap(find.byKey(const Key('login-button_signin')));
    await tester.pumpAndSettle();

    // Verify that it navigates to HomePage
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Invalid login should show error message',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Enter invalid credentials and tap "Se connecter" button
    await tester.enterText(
        find.byKey(const Key('login-textinput_email')), 'invalid_email');
    await tester.enterText(
        find.byKey(const Key('login-textinput_password')), 'invalid_password');
    await tester.tap(find.byKey(const Key('login-button_signin')));
    await tester.pumpAndSettle();

    // Verify that an error message is shown
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets(
      'Tapping "Mot de passe oublié ?" should show reset password dialog',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Tap "Mot de passe oublié ?" button
    await tester.tap(find.byKey(const Key('login-textbutton_resetpassword')));
    await tester.pumpAndSettle();

    // Verify that the reset password dialog is shown
    expect(find.text('A reset password has been sent to your email box.'),
        findsOneWidget);
  });

  testWidgets(
      'Tapping "Pas de compte ? S\'inscrire" should navigate to SignupPage',
      (WidgetTester tester) async {
    userInformation = null;
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(true),
          ),
        ],
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );

    // Tap "Pas de compte ? S'inscrire" button
    await tester.tap(find.byKey(const Key('login-textbutton_gotosignup')));
    await tester.pumpAndSettle();

    // Verify that it navigates to SignupPage
    expect(find.byType(SignupPage), findsOneWidget);
  });
}
