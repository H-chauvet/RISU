import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/company-creation/company-creation.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });
  testWidgets('Company creation test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    TestWidgetsFlutterBinding.ensureInitialized();

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
              theme: ThemeData(fontFamily: 'Roboto'),
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: CompanyCreationPage(
                  params: '',
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pump();
    expect(find.text("Création d'entreprise"), findsOneWidget);
    expect(find.text("Souhaitez-vous inviter des collaborateurs ?"),
        findsOneWidget);

    await tester.enterText(find.byKey(const Key("contact")), "test");
    await tester.enterText(
        find.byKey(const Key("collaboratorContact")), "test");
    await tester.enterText(find.byKey(const Key("name")), "test");

    await tester.tap(
      find.byKey(
        const Key('send-button'),
      ),
    );
    await tester.pump();
    await tester.tap(
      find.byKey(
        const Key("terminate"),
      ),
    );
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('invite team member test', (WidgetTester tester) async {
    CompanyCreationPageState state = CompanyCreationPageState();

    state.collaboratorList = ['test'];

    state.inviteTeamMember({});
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
