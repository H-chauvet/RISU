import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Working button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: MyParameter(
                title: "TestButton",
                goToPage: SettingsPage(),
                paramIcon: Icon(Icons.abc)),
          ),
        ),
      ),
    );
    Finder testButton = find.byType(MyParameter);

    expect(testButton, findsOneWidget);

    //await tester.tap(testButton);
    //await tester.pumpAndSettle();
  });

  testWidgets('Non Working button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: MaterialApp(
          home: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: const Column(
              children: [
                SizedBox(height: 20),
                MyParameter(
                    title: "TestButton",
                    goToPage: SettingsPage(),
                    paramIcon: Icon(Icons.abc),
                    locked: true),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
    Finder testButton = find.byType(MyParameter);
    expect(testButton, findsOneWidget);

    Finder gestureButton = find.byType(GestureDetector);
    expect(gestureButton, findsOneWidget);

    await tester.dragUntilVisible(
        gestureButton, // what you want to find
        testButton, // widget you want to scroll
        const Offset(0, -300) // delta to move
    );

    await tester.tap(gestureButton);
    await tester.pumpAndSettle();
  });
}
