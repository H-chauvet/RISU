import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/container.dart';
import 'package:front/screens/container-list/container_list.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> deleteContainer(ContainerListData container) async {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() async {
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
    sharedPreferences = MockSharedPreferences();
  });
  testWidgets('ContainerPage should render without error',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(5000, 5000));
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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerPage(),
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
    expect(find.text("Gestion des conteneurs et objets"), findsOneWidget);
  });

  testWidgets('Empty object', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(5000, 5000));
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    var fakeData = [
      {
        "id": 1,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes",
        "latitude": 47.210537,
        "longitude": -1.566808,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      },
      {
        "id": 2,
        "createdAt": "2024-11-20T15:22:21.618Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Boulevard de l'Océan",
        "city": "Saint-Brévin",
        "latitude": 47.232375,
        "longitude": -2.179429,
        "price": 300.1,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "emptyContainer"
      },
      {
        "id": 3,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "organizationId": 1,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes 2.0",
        "latitude": 0,
        "longitude": 0,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      }
    ];

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerPage(
                  fetchContainerFromServer: () async => fakeData,
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

    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text("Liste des objets"));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text("Aucun objet trouvé."), findsWidgets);
    await tester.pump();
  });

  testWidgets('Should render objects', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(5000, 5000));
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    var fakeData = [
      {
        "id": 1,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes",
        "latitude": 47.210537,
        "longitude": -1.566808,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      },
      {
        "id": 2,
        "createdAt": "2024-11-20T15:22:21.618Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Boulevard de l'Océan",
        "city": "Saint-Brévin",
        "latitude": 47.232375,
        "longitude": -2.179429,
        "price": 300.1,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "emptyContainer"
      },
      {
        "id": 3,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "organizationId": 1,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes 2.0",
        "latitude": 0,
        "longitude": 0,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      }
    ];

    var fakeItem = [
      {
        "id": 1,
        "name": "Ballon de volley",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 0.5,
        "description": null,
        "rating": 4.5,
        "category": null
      },
      {
        "id": 2,
        "name": "Raquette",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 1.0,
        "description": null,
        "rating": 4,
        "category": null
      },
      {
        "id": 3,
        "name": "Ballon de football",
        "available": false,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 0.75,
        "description": null,
        "rating": 0,
        "category": null
      },
      {
        "id": 4,
        "name": "Freesbee",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 1.5,
        "description": null,
        "rating": 0,
        "category": null
      },
      {
        "id": 5,
        "name": "Ballon de volley",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 0.5,
        "description": null,
        "rating": 0,
        "category": "Plage"
      },
      {
        "id": 6,
        "name": "Raquette",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 1.0,
        "description": null,
        "rating": 0,
        "category": "Tennis"
      },
      {
        "id": 7,
        "name": "Ballon de football",
        "available": false,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 0.75,
        "description": null,
        "rating": 0,
        "category": "Foot"
      }
    ];

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerPage(
                  fetchContainerFromServer: () async => fakeData,
                  fetchItemFromServer: () async => fakeItem,
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

    await tester.pumpAndSettle(const Duration(seconds: 2));
    await tester.tap(find.text("Liste des objets"));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text("Nom : Raquette"), findsWidgets);
    await tester.pump();
    await tester.tap(find.byKey(Key("editButton_2")));
    await tester.pump();
    expect(find.text("Modifier un objet"), findsOneWidget);
    expect(find.text("Disponible"), findsOneWidget);
    await tester.enterText(find.byKey(const Key('editPopupNewName')), 'test');
    await tester.enterText(
        find.byKey(const Key('editPopupDescription')), 'test');
    await tester.enterText(find.byKey(const Key('editPopupPrice')), 'test');
    await tester.tap(find.byKey(const Key("editPopupSwitch")));

    await tester.pump();
  });

  testWidgets('ContainerPage should render without error',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(5000, 5000));
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    var fakeData = [
      {
        "id": 0,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes",
        "latitude": 47.210537,
        "longitude": -1.566808,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      },
      {
        "id": 1,
        "createdAt": "2024-11-20T15:22:21.618Z",
        "organizationId": null,
        "containerMapping": "",
        "address": "Boulevard de l'Océan",
        "city": "Saint-Brévin",
        "latitude": 47.232375,
        "longitude": -2.179429,
        "price": 300.1,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "emptyContainer"
      },
      {
        "id": 2,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "organizationId": 1,
        "containerMapping": "",
        "address": "Rue d'Alger",
        "city": "Nantes 2.0",
        "latitude": 0,
        "longitude": 0,
        "price": 500.5,
        "width": 12,
        "height": 5,
        "designs": null,
        "informations": null,
        "paid": false,
        "saveName": "container"
      }
    ];

    var fakeItem = [
      {
        "id": 1,
        "name": "Ballon de volley",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 0.5,
        "description": null,
        "rating": 4.5,
        "category": null
      },
      {
        "id": 2,
        "name": "Raquette",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 1.0,
        "description": null,
        "rating": 4,
        "category": null
      },
      {
        "id": 3,
        "name": "Ballon de football",
        "available": false,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 0.75,
        "description": null,
        "rating": 0,
        "category": null
      },
      {
        "id": 4,
        "name": "Freesbee",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.372Z",
        "containerId": 1,
        "price": 1.5,
        "description": null,
        "rating": 0,
        "category": null
      },
      {
        "id": 5,
        "name": "Ballon de volley",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 0.5,
        "description": null,
        "rating": 0,
        "category": "Plage"
      },
      {
        "id": 6,
        "name": "Raquette",
        "available": true,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 1.0,
        "description": null,
        "rating": 0,
        "category": "Tennis"
      },
      {
        "id": 7,
        "name": "Ballon de football",
        "available": false,
        "createdAt": "2024-11-20T15:22:21.363Z",
        "containerId": 3,
        "price": 0.75,
        "description": null,
        "rating": 0,
        "category": "Foot"
      }
    ];

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerPage(
                  fetchContainerFromServer: () async => fakeData,
                  fetchItemFromServer: () async => fakeItem,
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
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text("Liste des objets"));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text("Ajouter un article"));
    await tester.pump();
    expect(find.text("Créer un nouvel objet"), findsOneWidget);
  });

  testWidgets('ContainerMobilePage displays message details',
      (WidgetTester tester) async {
    final List<ContainerListData> containers = [];
    containers.add(
      ContainerListData(
        id: 1,
        createdAt: '2022-01-01',
        organization: 'Test Organization',
        organizationId: 123,
        containerMapping: {},
        price: 29.99,
        address: "blabla",
        city: "Nantes",
        design: null,
        informations: "c'est un conteneur",
        saveName: "name",
      ),
    );

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
              home: Scaffold(
                body: Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: containers.length,
                      itemBuilder: (context, index) {
                        final product = containers[index];
                        return ContainerCards(
                          container: product,
                          onDelete: deleteContainer,
                          page: "page",
                        );
                      },
                    ),
                  ],
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

    expect(find.text("Ville : Nantes"), findsWidgets);
    expect(find.text("Adresse : blabla"), findsWidgets);
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
  });

  test('ContainerTest toJson and fromJson', () {
    final container = ContainerListData(
      id: 1,
      createdAt: '2022-01-01',
      organization: 'Test Organization',
      organizationId: 123,
      containerMapping: {},
      price: 29.99,
      address: "blabla",
      city: null,
      design: null,
      informations: "c'est un conteneur",
      saveName: "name",
    );

    final Map<String, dynamic> containerJson = container.toMap();
    final ContainerListData parsedContainer =
        ContainerListData.fromJson(containerJson);

    expect(parsedContainer.id, container.id);
    expect(parsedContainer.createdAt, container.createdAt);
    expect(parsedContainer.organization, container.organization);
    expect(parsedContainer.organizationId, container.organizationId);
    expect(parsedContainer.containerMapping, container.containerMapping);
    expect(parsedContainer.price, container.price);
    expect(parsedContainer.address, container.address);
    expect(parsedContainer.city, container.city);
    expect(parsedContainer.design, container.design);
    expect(parsedContainer.informations, container.informations);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
