// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/register-confirmation/confirmed_user.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return MaterialApp(
      home: child,
    );
  }

  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Confirmed user screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(
        createWidgetForTesting(child: const ConfirmedUser(params: 'uuid')));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(
        find.text(
            'Votre inscription a bien été confirmée, vous pouvez maintenant vous connecter et profiter de notre application'),
        findsOneWidget);

    // await tester.tap(find.byKey(const Key('go-home')));
    await tester.pumpAndSettle();
  });
}
