import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/dialog/remove_design_dialog.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  Future<void> blankFunction(bool a, int b) {
    return Future<void>.value();
  }

  setUp(() async {
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

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
            child: RemoveDesignDialog(
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
    await tester.tap(find.text('Haut'));
    await tester.tap(find.text('Gauche'));
    await tester.tap(find.text('Bas'));
    await tester.tap(find.text('Droite'));
    await tester.tap(find.text('Retirer'));

    await tester.pump();

    expect(find.text('Retirer une image'), findsOneWidget);
    expect(find.text('Quelle image souhaitez-vous retirer ?'), findsWidgets);
  });
}
