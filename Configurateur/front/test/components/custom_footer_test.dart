import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_footer.dart';
import 'package:provider/provider.dart';
import 'package:front/services/theme_service.dart';
import 'dart:ui' as ui;

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
    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());
    await tester.binding.setSurfaceSize(const Size(5000, 5000));

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
    expect(find.text("Questions fréquentes"), findsOneWidget);
    expect(find.text("L'entreprise Risu"), findsOneWidget);
    expect(find.text("Mon Compte"), findsOneWidget);
    expect(find.text("Mon Profil"), findsOneWidget);
    expect(find.text("Mes conteneurs"), findsOneWidget);
    expect(find.text("Créer un conteneur"), findsOneWidget);
    expect(find.text("Copyright ©2024, Tous droits réservés."), findsOneWidget);
    expect(find.text("Communauté"), findsOneWidget);
  });

  testWidgets('CustomFooter displays elements and handles hover correctly',
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

    final textsToTest = [
      "Nous contacter",
      "Questions fréquentes",
      "L'entreprise Risu",
      "Mon Profil",
      "Mes conteneurs",
      "Créer un conteneur",
    ];

    for (var text in textsToTest) {
      final textFinder = find.text(text);
      expect(textFinder, findsOneWidget);

      final renderObject = tester.renderObject(find.byType(MouseRegion).first);
      final offset = tester.getCenter(textFinder);
      final pointer = TestPointer(1, ui.PointerDeviceKind.mouse);

      // Simulate hover
      tester.binding.handlePointerEvent(pointer.hover(offset));
      await tester.pump();

      final textWidget = tester.firstWidget<Text>(textFinder);
      expect(textWidget.style?.decoration, TextDecoration.underline,
          reason: '$text should be underlined on hover');

      // Simulate exit hover
      tester.binding.handlePointerEvent(pointer.hover(Offset(-100, -100)));
      await tester.pump();

      final textWidgetAfterExit = tester.firstWidget<Text>(textFinder);
      expect(textWidgetAfterExit.style?.decoration, TextDecoration.none,
          reason: '$text should not be underlined when not hovered');
    }
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
