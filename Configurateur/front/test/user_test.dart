import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/screens/user-list/user-component-web.dart';
import 'package:front/screens/user-list/user_list.dart';


Future<void> deleteUserMobile(UserMobile container) async {}
Future<void> deleteUserWeb(User container) async {}

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
          onDelete: deleteUserMobile,
        ),
      ),
    );

    expect(find.text('John'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
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
          onDelete: deleteUserWeb,
        ),
      ),
    );
    expect(find.text('John'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
  });
  
  testWidgets('ContainerPage should render without error',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: UserPage(),
    ));

    // Verify that the ContainerPage is rendered.
    expect(find.byType(UserPage), findsOneWidget);
    await tester.pump();
    expect(find.text("Gestion des utilisateurs"), findsOneWidget);
  });

  test('UserMobile toJson and fromJson', () {
    final user = UserMobile(
      id: '1',
      email: 'test@example.com',
      firstName: 'John',
      lastName: 'Doe',
    );

    final Map<String, dynamic> userJson = user.toMap();
    final UserMobile parsedUser = UserMobile.fromJson(userJson);

    expect(parsedUser.id, user.id);
    expect(parsedUser.email, user.email);
    expect(parsedUser.firstName, user.firstName);
    expect(parsedUser.lastName, user.lastName);
  });

  test('UserWeb toJson and fromJson', () {
    final user = User(
      id: 1,
            firstName: 'John',
            lastName: 'Doe',
            company: 'copany',
            email: 'john.doe@example.com',
    );

    final Map<String, dynamic> userJson = user.toMap();
    final User parsedUser = User.fromJson(userJson);

    expect(parsedUser.id, user.id);
    expect(parsedUser.lastName, user.lastName);
    expect(parsedUser.firstName, user.firstName);
    expect(parsedUser.company, user.company);
    expect(parsedUser.email, user.email);
  });
}
