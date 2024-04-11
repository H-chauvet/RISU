// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/register-confirmation/register_confirmation.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Register confirmation screen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(
      MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeService>(
              create: (_) => ThemeService(),
            ),
          ],
          child: MaterialApp(
            home: InheritedGoRouter(
              goRouter: AppRouter.router,
              child: createWidgetForTesting(
                  child: const RegisterConfirmation(
                params: '',
              )),
            ),
          )),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Confirmation d'inscription"), findsOneWidget);
    expect(
        find.text(
            "Afin de finaliser l'inscription de votre compte, merci de confirmer cette dernière grâce au lien que vous avez reçu par mail."),
        findsOneWidget);

    await tester.tap(find.byKey(const Key('send-mail')));
    await tester.pumpAndSettle();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
