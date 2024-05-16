import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/tickets_page.dart';
import 'package:front/screens/contact/contact.dart';
import 'package:front/screens/profile/profile_page.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Test de profile page', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ProfilePage(),
        ),
      ),
    ));

    await tester.pump();

    // Modification mot de passe
    await tester.tap(find.byKey(const Key('edit-password')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('password')), 'Xx_poneyLover_xX');
    await tester.enterText(
        find.byKey(const Key('confirm-password')), 'Xx_poneyLover_xX');

    await tester.tap(find.byKey(const Key('cancel-edit-password')));
    await tester.pump();

    // Modification nom
    await tester.tap(find.byKey(const Key('edit-name')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('first-name')), 'Whaouh');
    await tester.enterText(find.byKey(const Key('last-name')), 'MinouMinou');

    await tester.tap(find.byKey(const Key('cancel-edit-name')));
    await tester.pump();

    // Modification entreprise
    await tester.tap(find.byKey(const Key('edit-company')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('company')), 'Risu');

    await tester.tap(find.byKey(const Key('cancel-edit-company')));
    await tester.pump();

    // Modification mail
    await tester.tap(find.byKey(const Key('edit-mail')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('user-mail')), 'henri@risu.fr');
    await tester.tap(find.byKey(const Key('cancel-edit-mail')));
    await tester.pump();
  });

  testWidgets('Test de profile page2', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('tokenExpiration')).thenReturn(
        DateTime.now().add(const Duration(minutes: 30)).toIso8601String());
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ProfilePage(),
        ),
      ),
    ));

    await tester.pump();

    // Modification mot de passe
    await tester.tap(find.byKey(const Key('edit-password')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('password')), 'Xx_poneyLover_xX');
    await tester.enterText(
        find.byKey(const Key('confirm-password')), 'Xx_poneyLover_xX');
    await tester.tap(find.byKey(const Key('button-password')));
    await tester.pump();

    // Modification nom
    await tester.tap(find.byKey(const Key('edit-name')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('first-name')), 'Whaouh');
    await tester.enterText(find.byKey(const Key('last-name')), 'MinouMinou');
    await tester.tap(find.byKey(const Key('button-name')));
    await tester.pump();

    // Modification entreprise
    await tester.tap(find.byKey(const Key('edit-company')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('company')), 'Risu');
    await tester.tap(find.byKey(const Key('button-company')));
    await tester.pump();

    // Modification mail
    await tester.tap(find.byKey(const Key('edit-mail')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('user-mail')), 'henri@risu.fr');
    await tester.tap(find.byKey(const Key('button-user-mail')));
    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
