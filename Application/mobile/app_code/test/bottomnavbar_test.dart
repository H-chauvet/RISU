import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/bottomnavbar.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('BottomNavBar should display and handle taps',
      (WidgetTester tester) async {
    int currentIndex = 0; // Initial index

    await tester.pumpWidget(
      initPage(
        Scaffold(
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTap: (index) {
              currentIndex = index;
            },
            theme: ThemeData(
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                backgroundColor: Colors.blue,
                selectedItemColor: Colors.green,
                unselectedItemColor: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );

    // Verify that the initial currentIndex is 0.
    expect(currentIndex, 0);

    // Tap the second item (index 1) in the BottomNavigationBar.
    await tester.tap(find.byType(BottomNavBar));
    await tester.pumpAndSettle();

    // Verify that the currentIndex has changed to 1.
    expect(currentIndex, 1);
  });
}
