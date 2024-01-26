import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/dialog/rating_dialog_content.dart';
import 'package:front/screens/feedbacks/feedbacks_card.dart';
import 'package:front/services/storage_service.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  test('Feedbacks.toMap should convert Feedbacks object to JSON', () {
    Feedbacks feedback = Feedbacks(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      message: 'Great app!',
      mark: '5',
    );

    Map<String, dynamic> json = feedback.toMap();

    expect(json['id'], 1);
    expect(json['firstName'], 'John');
    expect(json['lastName'], 'Doe');
    expect(json['email'], 'john.doe@example.com');
    expect(json['message'], 'Great app!');
    expect(json['mark'], '5');
  });
  test('Feedbacks.fromJson should create a Feedbacks object from JSON', () {
    Map<String, dynamic> json = {
      'id': 1,
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'message': 'Great app!',
      'mark': '5',
    };
    Feedbacks feedback = Feedbacks.fromJson(json);

    expect(feedback.id, 1);
    expect(feedback.firstName, 'John');
    expect(feedback.lastName, 'Doe');
    expect(feedback.email, 'john.doe@example.com');
    expect(feedback.message, 'Great app!');
    expect(feedback.mark, '5');
  });

  testWidgets('FeedbacksCard displays feedback details',
      (WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
