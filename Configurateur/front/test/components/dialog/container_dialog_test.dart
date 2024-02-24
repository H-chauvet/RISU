import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  void blankFunction(LockerCoordinates coordinates, bool unitTesting) {}

  testWidgets('test unfilled form', (WidgetTester tester) async {
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
            child: ContainerDialog(
              callback: blankFunction,
              size: 1,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ajouter'));
    await tester.tap(find.text('Petit'));
    await tester.tap(find.text('Moyen'));
    await tester.tap(find.text('Grand'));
    await tester.tap(find.text('Devant'));
    await tester.tap(find.text('Derrière'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsWidgets);
  });

  testWidgets('test invalid position form', (WidgetTester tester) async {
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
            child: ContainerDialog(
              callback: blankFunction,
              size: 1,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(0), '13');

    await tester.tap(find.text('Ajouter'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsOneWidget);
    expect(find.text('Position invalide'), findsOneWidget);
  });

  testWidgets('test invalid position form 2', (WidgetTester tester) async {
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
            child: ContainerDialog(
              callback: blankFunction,
              size: 1,
            ),
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField).at(1), '6');

    await tester.tap(find.text('Ajouter'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsOneWidget);
    expect(find.text('Position invalide'), findsOneWidget);
  });
}
