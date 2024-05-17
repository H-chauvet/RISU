// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/container-creation/recap_screen/recap_screen.dart';
import 'package:front/services/storage_service.dart';
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

  testWidgets('Recap screen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1920, 1080);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

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
                child: const RecapScreen(
                  lockers:
                      '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
                  amount: 60,
                  containerMapping: '1',
                  id: '1',
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Récapitulatif"), findsOneWidget);
    expect(find.text("Précédent"), findsOneWidget);
    expect(find.text("Suivant"), findsOneWidget);
    expect(find.text("Récapitulatif de la commande"), findsOneWidget);
    expect(find.text("Petit casier"), findsOneWidget);
    expect(find.text("10€"), findsOneWidget);
    expect(find.text("Moyen casier"), findsOneWidget);
    expect(find.text("20€"), findsOneWidget);
    expect(find.text("Grand casier"), findsOneWidget);
    expect(find.text("30€"), findsOneWidget);
    expect(find.text("Prix total: 60€"), findsOneWidget);

    await tester.tap(find.text("Précédent"));
    await tester.tap(find.text("Suivant"));
    await tester.pumpAndSettle();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
