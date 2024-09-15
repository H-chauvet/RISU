import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/container-creation/shape_screen/shape_screen.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();

    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Shape screen', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(5000, 5000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: const ShapeScreen(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Précédent"), findsOneWidget);
    expect(find.text("Suivant"), findsOneWidget);
    expect(find.text("Forme"), findsOneWidget);
    expect(find.text("Nombre de lignes"), findsOneWidget);
    expect(find.text("Nombre de colonnes"), findsOneWidget);
    expect(find.text("Largeur :"), findsOneWidget);
    expect(find.text("Hauteur :"), findsOneWidget);
    expect(find.text("Nombre d'emplacements :"), findsOneWidget);

    await tester.tap(find.byKey(const Key('row-add')));
    await tester.tap(find.byKey(const Key('row-remove')));

    await tester.tap(find.byKey(const Key('column-add')));
    await tester.tap(find.byKey(const Key('column-remove')));

    await tester.tap(find.byKey(const Key('remove-lockers')));

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('cancel')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove-lockers')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('remove')));
    await tester.pumpAndSettle();

    await tester.tap(find.text("Précédent"));
    await tester.tap(find.text("Suivant"));
    await tester.pumpAndSettle();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
