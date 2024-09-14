import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/screens/profile/profile_page.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets(
    'Profile page test',
    (WidgetTester tester) async {
      when(sharedPreferences.getString('token')).thenReturn('test-token');
      when(sharedPreferences.getString('tokenExpiration')).thenReturn(
          DateTime.now().add(const Duration(minutes: 30)).toIso8601String());

      await tester.binding.setSurfaceSize(const Size(5000, 5000));

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
                theme: ThemeData(fontFamily: 'Roboto'),
                home: InheritedGoRouter(
                  goRouter: AppRouter.router,
                  child: const ProfilePage(),
                ),
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check if footer is displayed
      expect(find.byType(CustomFooter), findsOneWidget);

      // Email modification
      await tester.ensureVisible(find.byKey(const Key('edit-mail')));
      await tester.tap(find.byKey(const Key('edit-mail')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('user-mail')), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key('user-mail')), 'henri@risu.fr');
      await tester.tap(find.byKey(const Key('close-popup')));
      await tester.pumpAndSettle();

      // Password modification
      await tester.ensureVisible(find.byKey(const Key('edit-password')));
      await tester.tap(find.byKey(const Key('edit-password')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('password')), findsOneWidget);
      expect(find.byKey(const Key('confirm-password')), findsOneWidget);
      await tester.enterText(
          find.byKey(const Key('password')), 'Xx_poneyLover_xX');
      await tester.enterText(
          find.byKey(const Key('confirm-password')), 'Xx_poneyLover_xX');
      await tester.tap(find.byKey(const Key('close-popup')));
      await tester.pumpAndSettle();

      // Name modification
      await tester.ensureVisible(find.byKey(const Key('edit-name')));
      await tester.tap(find.byKey(const Key('edit-name')));
      await tester.pumpAndSettle();

      expect(find.text('Mettre à jour'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('first-name')), 'Whaouh');
      await tester.enterText(find.byKey(const Key('last-name')), 'MinouMinou');
      await tester.tap(find.byKey(const Key('close-popup')));
      await tester.pumpAndSettle();
    },
  );
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
