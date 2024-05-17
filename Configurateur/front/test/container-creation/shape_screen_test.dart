import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Shape screen', (WidgetTester tester) async {
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
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: const ShapeScreen(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Précédent"), findsOneWidget);
    expect(find.text("Suivant"), findsOneWidget);
    expect(find.text("Forme"), findsOneWidget);
    expect(find.text("Nombres de lignes"), findsOneWidget);
    expect(find.text("Nombres de colonnes"), findsOneWidget);
    expect(find.text("Largeur:"), findsOneWidget);
    expect(find.text("Hauteur:"), findsOneWidget);
    expect(find.text("2.5 mètres"), findsOneWidget);
    expect(find.text("Nombre d'emplacements:"), findsOneWidget);
    expect(find.text("120"), findsOneWidget);

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
