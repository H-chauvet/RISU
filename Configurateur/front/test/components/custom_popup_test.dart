import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
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

    // Build the CustomPopup widget
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

    // Check that the title is displayed
    expect(find.text(testTitle), findsOneWidget);

    // Check that the content is displayed
    expect(find.text('This is content'), findsOneWidget);

    // Verify that the close button is present
    expect(find.byIcon(Icons.close), findsOneWidget);
  });

  testWidgets('CustomPopup close button functionality',
      (WidgetTester tester) async {
    // Create a mock content widget
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    const contentWidget = Text('This is content 2');
    const testTitle = 'Test Title 2';

    // Build the CustomPopup widget
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

    // Verify that tapping the close button pops the dialog
    expect(find.byType(CustomPopup), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle(); // Ensure all animations are finished

    expect(find.byType(CustomPopup), findsNothing);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
