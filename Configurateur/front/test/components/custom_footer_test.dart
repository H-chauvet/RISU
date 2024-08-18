import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_footer.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:front/services/theme_service.dart';

import 'package:front/components/custom_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('CustomPopup displays title and content correctly',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomFooter(),
          ),
        ),
      ),
    );

    expect(find.text("Communauté"), findsOneWidget);
    expect(find.text("Nous contacter"), findsOneWidget);
    expect(find.text("Vos avis"), findsOneWidget);
    expect(find.text("Questions fréquentes"), findsOneWidget);
    expect(find.text("L'entreprise Risu"), findsOneWidget);
    expect(find.text("Mon Compte"), findsOneWidget);
    expect(find.text("Mon Profil"), findsOneWidget);
    expect(find.text("Mes conteneurs"), findsOneWidget);
    expect(find.text("Créer un conteneur"), findsOneWidget);
    expect(find.text("Copyright ©2024, Tous droits réservés."), findsOneWidget);
    expect(find.text("Communauté"), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
