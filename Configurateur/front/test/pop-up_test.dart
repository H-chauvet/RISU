import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/storage_service.dart';
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
  final mockNavigatorObserver = MockNavigatorObserver();

  test('checkSignin - token vide', () async {
    SharedPreferences.setMockInitialValues({});

    bool isSignedIn = await checkSignin(mockContext);

    expect(isSignedIn, false);
  });

  test('checkSignin - token non vide', () async {
    SharedPreferences.setMockInitialValues({
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJNYWlsIjoiY2VkcmljLmNvcmdlQGdtYWlsLmNvbSIsImNvbmZpcm1lZCI6dHJ1ZSwiaWF0IjoxNzA1ODY5ODIwfQ.kBl1SxA59i7biwIIPoYPLgY0hECVvNP7wciioe4B2I8',
      'tokenExpiration':
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String()
    });

    String userMail = 'risu.admin@gmail.com';

    when(sharedPreferences.getString('token')).thenReturn(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJNYWlsIjoiY2VkcmljLmNvcmdlQGdtYWlsLmNvbSIsImNvbmZpcm1lZCI6dHJ1ZSwiaWF0IjoxNzA1ODY5ODIwfQ.kBl1SxA59i7biwIIPoYPLgY0hECVvNP7wciioe4B2I8');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    bool isSignedIn = await checkSignin(mockContext);

    expect(isSignedIn, true);
  });

  test('checkSignInAdmin - token vide ou utilisateur non admin', () async {
    SharedPreferences.setMockInitialValues({});

    bool isSignedInAdmin = await checkSignInAdmin(mockContext);

    expect(isSignedInAdmin, false);
  });

  test('checkSignInAdmin - token non vide et utilisateur admin', () async {
    SharedPreferences.setMockInitialValues({
      'token':
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJNYWlsIjoicmlzdS5hZG1pbkBnbWFpbC5jb20iLCJjb25maXJtZWQiOmZhbHNlLCJpYXQiOjE3MDU4NzAxMTN9.6tB_XpF67uv_4oTEmiCO3OgDuzIUQ7U_lgvXpHs34Ds',
      'tokenExpiration':
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String()
    });

    when(sharedPreferences.getString('token')).thenReturn(
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjMsInVzZXJNYWlsIjoicmlzdS5hZG1pbkBnbWFpbC5jb20iLCJjb25maXJtZWQiOmZhbHNlLCJpYXQiOjE3MDU4NzAxMTN9.6tB_XpF67uv_4oTEmiCO3OgDuzIUQ7U_lgvXpHs34Ds');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

    bool isSignedInAdmin = await checkSignInAdmin(mockContext);

    expect(isSignedInAdmin, true);
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
