import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/container.dart';
import 'package:front/screens/container-list/container_list.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<void> deleteContainer(ContainerListData container) async {}

void main() {
  testWidgets('ContainerPage should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerPage(),
        ),
      ),
    ));

    expect(find.text("Gestion des conteneurs et objets"), findsOneWidget);
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
      MaterialApp(
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
      ),
    );

    expect(find.text("Ville : Nantes"), findsWidgets);
    expect(find.text("adresse : blabla"), findsWidgets);
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
