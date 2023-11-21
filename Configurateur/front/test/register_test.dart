// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';

import 'package:front/screens/register/register.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const RegisterScreen(),
        ),
      ),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Inscription'), findsOneWidget);
    expect(find.text('Adresse e-mail'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text('Valider le mot de passe'), findsOneWidget);
    expect(find.text("S'inscrire"), findsOneWidget);
    expect(find.text("Déja un compte ? "), findsOneWidget);
    expect(find.text("Connectez-vous."), findsOneWidget);
    expect(find.text("S'inscrire avec :"), findsOneWidget);

    expect(
        find.image(const AssetImage("assets/google-logo.png")), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('email')), 'test@gmail.com');
    await tester.enterText(find.byKey(const Key('password')), 'password');
    await tester.enterText(
        find.byKey(const Key('confirm-password')), 'password');

    await tester.tap(find.byKey(const Key('register')));
    // await tester.tap(find.byKey(const Key('login')));
    await tester.pumpAndSettle();
  });
}
