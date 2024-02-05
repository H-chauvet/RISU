import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/validators.dart';

import 'globals.dart';

void main() {
  group('Validators Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Valid Email', (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(
                    Validators().email(context, 'example@email.com') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('Please enter a valid email.'), findsNothing);
    });

    testWidgets('Valid Not Empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(
                    Validators().notEmpty(context, 'Valid Input') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('This field is required'), findsNothing);
    });

    testWidgets('Invalid Not Empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(Validators().notEmpty(context, '') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
