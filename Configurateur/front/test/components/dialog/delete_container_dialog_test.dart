import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/delete_container_dialog.dart';
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
            child: DeleteContainerDialog(
              callback: blankFunction,
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
        ),
      ),
    );

    await tester.tap(find.text('Devant'));
    await tester.tap(find.text('Derrière'));
    await tester.tap(find.text('Supprimer'));

    await tester.enterText(find.byKey(const Key('locker-row')), '1');
    await tester.enterText(find.byKey(const Key('locker-column')), '1');

    await tester.pump();

    expect(find.text('Supprimer un conteneur'), findsOneWidget);
    expect(find.text('Sur quelle face du casier voulez-vous le supprimer ?'),
        findsWidgets);
  });
}
