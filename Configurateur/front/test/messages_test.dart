import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:front/services/storage_service.dart';

void main() {
  
  testWidgets('MessageCard displays message details', (WidgetTester tester) async {
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

