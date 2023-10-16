import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/validators.dart';

void main() {
  group('Validators Integration Test', () {
    testWidgets('Valid Phone Number', (WidgetTester tester) async {
      // Create a MaterialApp to enable building widgets
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

      // Expect that the text widget displays no error message
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

    // Add more test cases for email, date, and notEmpty validators as needed

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

    testWidgets('Invalid Date', (WidgetTester tester) async {
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

      expect(
          find.text('Invalid date format. Please use the format "dd/mm/yyyy"'),
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
