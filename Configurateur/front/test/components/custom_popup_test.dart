import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

    const contentWidget = Text('This is content');
    const testTitle = 'Test Title';

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomPopup(
              title: testTitle,
              content: contentWidget,
            ),
          ),
        ),
      ),
    );

    expect(find.text(testTitle), findsOneWidget);

    expect(find.text('This is content'), findsOneWidget);

    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('CustomPopup close button functionality',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    const contentWidget = Text('This is content 2');
    const testTitle = 'Test Title 2';

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CustomPopup(
              title: testTitle,
              content: contentWidget,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CustomPopup), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(find.byType(CustomPopup), findsNothing);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
