import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/confirmation_dialog.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('test cancel dialog', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

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
            child: ConfirmationDialog(),
          ),
        ),
      ),
    );

    expect(find.text('Confirmation'), findsOneWidget);
    expect(find.text('Etes-vous certains de vouloir faire cette action ?'),
        findsOneWidget);

    await tester.tap(find.text('Annuler'));

    await tester.pump();
  });

  testWidgets('test confirmation dialog', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

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
            child: ConfirmationDialog(),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Confirmer'));

    await tester.pump();
  });
}
