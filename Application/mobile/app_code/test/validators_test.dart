import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/validators.dart';

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
    
    testWidgets('Valid Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(
                    Validators().phoneNumber(context, '+1234567890') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('Please enter a valid phone number.'), findsNothing);
    });

    testWidgets('Invalid Phone Number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(Validators().phoneNumber(context, 'invalid') ?? '');
              },
            ),
          ),
        ),
      );

      // Expect that the text widget displays an error message
      expect(find.text('Please enter a valid phone number.'), findsOneWidget);
    });

    testWidgets('Valid Email', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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

    testWidgets('Valid Date', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(Validators().date(context, '01/01/2023') ?? '');
              },
            ),
          ),
        ),
      );

      expect(
          find.text('Invalid date format. Please use the format "dd/mm/yyyy"'),
          findsNothing);
    });

    testWidgets('Invalid Month', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(Validators().date(context, '32/13/2023') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('Invalid month. Please enter a value between 1 and 12'),
          findsOneWidget);
    });

    testWidgets('Invalid Day', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return Text(Validators().date(context, '32/11/2023') ?? '');
              },
            ),
          ),
        ),
      );

      expect(find.text('Invalid day. Please enter a value between 1 and 30'),
          findsOneWidget);
    });

    testWidgets('Valid Not Empty', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
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
        MaterialApp(
          home: Scaffold(
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
