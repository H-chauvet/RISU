import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeProvider Integration Test', () {
    testWidgets('Toggle theme and save to SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({'isDarkTheme': false});

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

      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.light);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('isDarkTheme'), true);
    });
  });
}
