// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/save_container/confirmation_save.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Confirmation save', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ConfirmationSave(),
        ),
      ),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Votre conteneur a bien été sauvegardé'), findsOneWidget);
    expect(find.text("blabla"), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
