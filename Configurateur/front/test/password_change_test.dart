// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/password-recuperation/password_change.dart';
import 'package:front/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Password change screen', (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Build our app and trigger a frame.
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(
        createWidgetForTesting(child: const PasswordChange(params: 'uuid')));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Nouveau mot de passe'), findsOneWidget);
    expect(find.text('Mot de passe'), findsOneWidget);
    expect(find.text("Valider le mot de passe"), findsOneWidget);
    expect(find.text("Changer le mot de passe"), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('confirm-password')), 'password');
    await tester.enterText(find.byKey(const Key('password')), 'password');

    // await tester.tap(find.byKey(const Key('change-password')));
    await tester.pumpAndSettle();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
