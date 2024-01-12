import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/storage_service.dart';
import 'package:mockito/mockito.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:your_app/path/to/my_alert_test.dart'; // Ajuster le chemin

class MockBuildContext extends Mock implements BuildContext {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('MyAlertTest', () {
    final mockContext = MockBuildContext();
    final mockNavigatorObserver = MockNavigatorObserver();

    test('checkSignin - token vide', () async {
      token = '';

      bool isSignedIn = await checkSignin(mockContext);

      expect(isSignedIn, false);
    });

    test('checkSignin - token non vide', () async {
      token = 'token';

      bool isSignedIn = await checkSignin(mockContext);

      expect(isSignedIn, true);
    });

    test('checkSignInAdmin - token vide ou utilisateur non admin', () async {
      token = '';
      userMail = 'utilisateur_non_admin@email.com';

      bool isSignedInAdmin = await checkSignInAdmin(mockContext);

      expect(isSignedInAdmin, false);
    });

    test('checkSignInAdmin - token non vide et utilisateur admin', () async {
      token = 'token';
      userMail = 'risu.admin@gmail.com';

      bool isSignedInAdmin = await checkSignInAdmin(mockContext);

      expect(isSignedInAdmin, true);
    });

  });
}
