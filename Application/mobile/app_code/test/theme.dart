import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeProvider Integration Test', () {
    testWidgets('Toggle theme and save to SharedPreferences', (tester) async {
      // Initialize the SharedPreferences instance for testing.
      SharedPreferences.setMockInitialValues({'isDarkTheme': false});

      // Build a test widget with ThemeProvider.
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => ThemeProvider(false), // Start with light theme.
            child: Consumer<ThemeProvider>(
              builder: (_, themeProvider, __) {
                return MaterialApp(
                  theme: themeProvider.currentTheme,
                  home: Scaffold(
                    body: TextButton(
                      onPressed: () {
                        themeProvider.toggleTheme();
                      },
                      child: const Text('Toggle Theme'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Verify that the initial theme is light.
      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.light);

      // Tap the "Toggle Theme" button.
      await tester.tap(find.byType(TextButton));
      await tester.pump();

      // Verify that the theme has toggled to dark.
      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.dark);

      // Verify that the theme change has been saved to SharedPreferences.
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkTheme'), true);
    });
  });
}
