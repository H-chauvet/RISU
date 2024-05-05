import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Test de LandingPage', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const LandingPage(),
        ),
      ),
    ));
    expect(
        find.text(
            'Louer du matériel quand vous en avez envie\n en toute simplicité grâce à RISU !'),
        findsOneWidget);
    expect(
        find.text(
            'Trouvez des locations selon vos \rbesoins, où vous les souhaitez'),
        findsOneWidget);
    expect(find.text('Des conteneurs disponibles partout en france !'),
        findsOneWidget);
    expect(find.text('Concevez le conteneur de vos rêves,\nselon vos envies !'),
        findsOneWidget);
    expect(
        find.text(
            'Grâce à notre configurateur innovant,\nvotre conteneur sera à la hauteur de vos attentes'),
        findsOneWidget);

    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
