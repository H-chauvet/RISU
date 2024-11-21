import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/container.dart';
import 'package:front/components/items-information.dart';
import 'package:front/screens/company-profil/container-profil.dart';
import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    sharedPreferences = MockSharedPreferences();
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('Container profil screen', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

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
                child: const ContainerProfilPage(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(ContainerProfilPage), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);

    await tester.tap(find.byKey(const Key('edit-city')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cancel-edit-city')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('edit-address')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cancel-edit-address')));
    await tester.pumpAndSettle();


    expect(find.text('Aucun objet trouvé.'), findsOneWidget);
    expect(find.text('Ville : Pas de ville associée'), findsOneWidget);
    expect(find.text('Adresse : Aucune adresse'), findsOneWidget);
  });

  testWidgets('Container profil screen with city and address',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

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
                child: const ContainerProfilPage(),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    final state_assign = tester.state(find.byType(ContainerProfilPage))
        as ContainerProfilPageState;

    state_assign.setState(() {
      state_assign.tmp = ContainerListData(
          id: 1,
          createdAt: null,
          organization: null,
          organizationId: 1,
          containerMapping: null,
          price: 2,
          address: 'rue george',
          city: 'batz sur mer',
          design: null,
          informations: 'informations',
          saveName: 'saveName');
    });

     state_assign.setState(() {
      state_assign.items = [
        ItemList(id: 1, name: "bonsoir", available: true, container: null, createdAt: null, containerId: 1, price: 2, image: null, description: "description", category: null, status: null)
      ];
    });

    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text("Adresse : rue george"), findsOneWidget);
    expect(find.text("Nom de la ville : batz sur mer"), findsOneWidget);

    expect(find.text("Nom : bonsoir"), findsOneWidget);
    expect(find.text("Description : description"), findsOneWidget);

    await tester.tap(find.byKey(const Key('edit-item')));
    await tester.pump(const Duration(seconds: 3));
    await tester.tap(find.byKey(const Key('cancel-edit-item')));
    await tester.pump(const Duration(seconds: 3));

  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
