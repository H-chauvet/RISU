import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:your_app/path/to/my_alert_test.dart'; // Ajuster le chemin

class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    WidgetsFlutterBinding.ensureInitialized();

    sharedPreferences = MockSharedPreferences();

    // Replace the actual SharedPreferences instance with the mock
    SharedPreferences.setMockInitialValues({'token': 'test-token'});
  });
  final mockContext = MockBuildContext();

  test('checkSignin - token vide', () async {
    SharedPreferences.setMockInitialValues({});

    dynamic object = await checkSignin(mockContext);

    expect(object['isSignedIn'], false);
  });

  test('checkSignin - token non vide', () async {
    SharedPreferences.setMockInitialValues({
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJNYWlsIjoiY2VkcmljLmNvcmdlQGdtYWlsLmNvbSIsImNvbmZpcm1lZCI6dHJ1ZSwiaWF0IjoxNzA1ODY5ODIwfQ.kBl1SxA59i7biwIIPoYPLgY0hECVvNP7wciioe4B2I8',
      'tokenExpiration':
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String()
    });

    when(sharedPreferences.getString('token')).thenReturn(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJNYWlsIjoiY2VkcmljLmNvcmdlQGdtYWlsLmNvbSIsImNvbmZpcm1lZCI6dHJ1ZSwiaWF0IjoxNzA1ODY5ODIwfQ.kBl1SxA59i7biwIIPoYPLgY0hECVvNP7wciioe4B2I8');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    dynamic object = await checkSignin(mockContext);

    expect(object['isSignedIn'], true);
  });

  test('checkSignInAdmin - token vide ou utilisateur non admin', () async {
    SharedPreferences.setMockInitialValues({});

    dynamic object = await checkSignInAdmin(mockContext);

    expect(object['isSignedIn'], false);
  });

  test('checkSignInAdmin - token non vide et utilisateur admin', () async {
    SharedPreferences.setMockInitialValues({
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInVzZXJNYWlsIjoiZGF2aWQucG9xdWVsaW5AZ21haWwuY29tIiwiY29uZmlybWVkIjpmYWxzZSwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzE1MjU4MzczLCJleHAiOjE3MTUyNjE5NzN9.KCF741HcFG7Gyh7z-OankV9sk1NauvYBRJGb88BR43M',
      'tokenExpiration':
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String()
    });

    when(sharedPreferences.getString('token')).thenReturn(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsInVzZXJNYWlsIjoiZGF2aWQucG9xdWVsaW5AZ21haWwuY29tIiwiY29uZmlybWVkIjpmYWxzZSwicm9sZSI6ImFkbWluIiwiaWF0IjoxNzE1MjU4MzczLCJleHAiOjE3MTUyNjE5NzN9.KCF741HcFG7Gyh7z-OankV9sk1NauvYBRJGb88BR43M');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    dynamic object = await checkSignInAdmin(mockContext);

    expect(object['isSignedIn'], true);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}

class MockJwtDecoder extends Mock implements JwtDecoder {
  static Map<String, dynamic> Function(String token) decode =
      (String token) => {};

  // Setter for the decode function
  static void setDecodeFunction(
      Map<String, dynamic> Function(String) decodeFunction) {
    decode = decodeFunction;
  }
}
