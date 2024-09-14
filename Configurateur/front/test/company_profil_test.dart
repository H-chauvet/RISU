// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/screens/company-profil/company-profil.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  testWidgets('Test de company profil page', (WidgetTester tester) async {
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
                child: const CompanyProfilPage(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: Locale('fr'),
            );
          },
        ),
      ),
    );
    final state_assign =
        tester.state(find.byType(CompanyProfilPage)) as CompanyProfilPageState;

    state_assign.setState(() {
      state_assign.organization = OrganizationList(
          id: 1,
          name: 'test',
          type: 'test',
          affiliate: null,
          containers: null,
          contactInformation: 'test');
    });

    await tester.pump(const Duration(seconds: 3));

    // Edit information
    await tester.tap(find.byKey(const Key('edit-information')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('information')), 'infor orga');

    await tester.tap(find.byKey(const Key('cancel-edit-information')));
    await tester.pump(const Duration(seconds: 3));

    // Edit type
    await tester.tap(find.byKey(const Key('edit-type')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('type')), 'type orga');
    await tester.tap(find.byKey(const Key('cancel-edit-type')));
    await tester.pump(const Duration(seconds: 3));

    // EDIT type validate
    await tester.tap(find.byKey(const Key('edit-type')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('type')), 'type orga');
    await tester.tap(find.byKey(const Key('button-type')));
    await tester.pump(const Duration(seconds: 3));

    // EDIT information validate
    await tester.tap(find.byKey(const Key('edit-information')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('information')), 'info orga');
    await tester.tap(find.byKey(const Key('button-information')));
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(CustomFooter), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
