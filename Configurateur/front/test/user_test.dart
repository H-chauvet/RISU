import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/screens/user-list/user-component-web.dart';

void main() {
  
  testWidgets('UserMobileCard displays message details', (WidgetTester tester) async {

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      MaterialApp(
        home: UserMobileCard(
          user: UserMobile(
            id: "1",
            email: 'john.doe@example.com',
            firstName: 'John',
            lastName: 'Doe',
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text('John'), findsOneWidget);
  });

  testWidgets('UserCard displays message details', (WidgetTester tester) async {

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      MaterialApp(
        home: UserCard(
          user: User(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            company: 'copany',
            email: 'john.doe@example.com',
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text('John'), findsOneWidget);
  });
}
