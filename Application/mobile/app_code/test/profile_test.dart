import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

void main() {
  group('Test profile page', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });
  });

  testWidgets('Profile page', (WidgetTester tester) async {
    userInformation = UserData(
        email: 'example@gmail.com', firstName: 'Example', lastName: 'Gmail');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) =>
                ThemeProvider(false), // Provide a default value for testing.
          ),
        ],
        child: const MaterialApp(
          home: ProfilePage(),
        ),
      ),
    );
    Finder profilePhotoUser =
        find.byKey(const Key('profile-profile_photo-user_photo'));
    expect(profilePhotoUser, findsOneWidget);
  });
}
