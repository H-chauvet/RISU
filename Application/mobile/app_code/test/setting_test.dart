import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/settings/settings_page.dart';

import 'globals.dart';

void main() {
  group('Test Settings', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Init Page', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const SettingsPage()));
    });
  });
}
