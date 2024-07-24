import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/screens/user-list/user-component-web.dart';
import 'package:front/screens/user-list/user_list.dart';
import 'package:front/services/theme_service.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> deleteUserMobile(UserMobile container) async {}
Future<void> deleteUserWeb(User container) async {}

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('UserMobileCard displays message details',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              home: UserMobileCard(
                user: UserMobile(
                  id: "1",
                  email: 'john.doe@example.com',
                  firstName: 'John',
                  lastName: 'Doe',
                ),
                onDelete: deleteUserMobile,
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Prénom : John'), findsOneWidget);
    expect(find.text('Nom : Doe'), findsOneWidget);
    expect(find.text('Email : john.doe@example.com'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('UserCard displays message details', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: MaterialApp(
          home: UserCard(
            user: User(
              id: 1,
              firstName: 'John',
              lastName: 'Doe',
              company: 'company',
              email: 'john.doe@example.com',
            ),
            onDelete: deleteUserWeb,
          ),
        ),
      ),
    );

    expect(find.text('Prénom : John'), findsOneWidget);
    expect(find.text('Nom : Doe'), findsOneWidget);
    expect(find.text('Email : john.doe@example.com'), findsOneWidget);
    expect(find.text('Entreprise : company'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('ContainerPage should render without error',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(home: UserPage());
          },
        ),
      ),
    );

    // Verify that the ContainerPage is rendered.
    expect(find.byType(UserPage), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.text("Gestion des utilisateurs"), findsOneWidget);
    expect(find.text('Utilisateurs Web'), findsOneWidget);
    expect(find.text('Utilisateurs Mobile'), findsOneWidget);
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

class MockSharedPreferences extends Mock implements SharedPreferences {}
