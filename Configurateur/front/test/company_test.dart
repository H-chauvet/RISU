
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/company/company.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  setUp(() async {
    final roboto = rootBundle.load('assets/roboto/Roboto-Medium.ttf');
    final fontLoader = FontLoader('Roboto')..addFont(roboto);
    await fontLoader.load();
  });

  testWidgets('CompanyPage should render without error',
      (WidgetTester tester) async {
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
                child: const MaterialApp(
                  home: CompanyPage(),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.byType(CompanyPage), findsOneWidget);
    await tester.pump();

    expect(find.text("Entreprise"), findsOneWidget);
    expect(find.text("Notre équipe :"), findsOneWidget);
    expect(find.text("Nos Conteneurs :"), findsOneWidget);
  });

  testWidgets('CompanyPage should display team members',
      (WidgetTester tester) async {
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
                child: const MaterialApp(
                  home: CompanyPage(),
                ),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text("HENRI"), findsOneWidget);
    expect(find.text("LOUIS"), findsOneWidget);
    expect(find.text("HUGO"), findsOneWidget);
  });

  testWidgets('CompanyPage should display team', (WidgetTester tester) async {
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
                child: const MaterialApp(
                  home: CompanyPage(),
                ),
              ),
            );
          },
        ),
      ),
    );


    expect(find.byKey(const Key('member_image_0')), findsOneWidget);
    expect(find.byKey(const Key('member_image_1')), findsOneWidget);
    expect(find.byKey(const Key('member_image_2')), findsOneWidget);
    expect(find.byKey(const Key('member_image_3')), findsOneWidget);
    expect(find.byKey(const Key('member_image_4')), findsOneWidget);
  });

  test('ContainerTest toJson and fromJson', () {
    final container = MyContainerList(
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
    );

    final Map<String, dynamic> containerJson = container.toMap();
    final MyContainerList parsedContainer =
        MyContainerList.fromJson(containerJson);

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
