import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/feedbacks/feedbacks_card.dart';
import 'package:front/services/storage_service.dart';

void main() {
  testWidgets('FeedbacksCard displays feedback details', (WidgetTester tester) async {
    token = "token";
    userMail = "risu.admin@gmail.com";

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      MaterialApp(
        home: FeedbacksCard(
          fb: Feedbacks(
            id: 1,
            firstName: 'John',
            lastName: 'Doe',
            email: 'john.doe@example.com',
            message: 'Great app!',
            mark: '5',
          ),
        ),
      ),
    );

    expect(find.text('Great app!'), findsOneWidget);
    expect(find.text('Avis posté par John Doe'), findsOneWidget);
    expect(find.text('5 / 5'), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byType(Divider), findsOneWidget);
  });
}
