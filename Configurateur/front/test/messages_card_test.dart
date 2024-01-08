import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:front/services/storage_service.dart';

void main() {
  test('Feedbacks.toMap should convert Feedbacks object to JSON', () {
    Message msg = Message(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      message: 'Great app!',
    );

    Map<String, dynamic> json = msg.toMap();

    expect(json['id'], 1);
    expect(json['firstName'], 'John');
    expect(json['lastName'], 'Doe');
    expect(json['email'], 'john.doe@example.com');
    expect(json['message'], 'Great app!');
  });
  test('Message.fromJson should create a Feedbacks object from JSON', () {
    Map<String, dynamic> json = {
      'id': 1,
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'message': 'Great app!',
    };
    Message feedback = Message.fromJson(json);

    expect(feedback.id, 1);
    expect(feedback.firstName, 'John');
    expect(feedback.lastName, 'Doe');
    expect(feedback.email, 'john.doe@example.com');
    expect(feedback.message, 'Great app!');
  });
  testWidgets('MessageCard', (WidgetTester tester) async {
    token = "token";
    userMail = "risu.admin@gmail.com";

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      MaterialApp(
        home: MessageCard(
          message: Message(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            email: 'john.doe@example.com',
            message: 'Hello, how are you?',
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
    expect(find.text('Hello, how are you?'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}

