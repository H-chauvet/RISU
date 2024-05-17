import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/messages/messages_card.dart';
import 'package:front/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });
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
    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
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
          );
        },
      ),
    );

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john.doe@example.com'), findsOneWidget);
    expect(find.text('Hello, how are you?'), findsOneWidget);
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockJwtDecoder {
  static Map<String, dynamic> Function(String token) decode =
      (String token) => {};

  // Setter for the decode function
  static void setDecodeFunction(
      Map<String, dynamic> Function(String) decodeFunction) {
    decode = decodeFunction;
  }
}

class MockFunction {
  final Function function;
  MockFunction(this.function);

  dynamic call(Object? arg) => Function.apply(function, [arg]);
}
