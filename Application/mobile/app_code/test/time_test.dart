import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/time.dart';

void main() {
  group('Time Tests', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    test('Testing Format Time', () {
      final formatTime = formatDateTime("2024-04-07 13:17:44.435038");
      expect("07/04/2024 13:17", formatTime);
    });
  });
}
