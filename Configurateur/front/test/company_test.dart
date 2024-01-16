import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/company/company.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:http/http.dart' as http;

void main() {
  testWidgets('CompanyPage should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyPage(),
    ));

    expect(find.byType(CompanyPage), findsOneWidget);
    await tester.pump();

    expect(find.text("Entreprise"), findsOneWidget);
    expect(find.text("Notre équipe :"), findsOneWidget);
    expect(find.text("Nos Conteneurs :"), findsOneWidget);
  });

  testWidgets('CompanyPage should display team members',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyPage(),
    ));

    expect(find.text("HENRI"), findsOneWidget);
    expect(find.text("LOUIS"), findsOneWidget);
    expect(find.text("HUGO"), findsOneWidget);
  });

  testWidgets('CompanyPage should display team', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyPage(),
    ));

    late List<String> members = [
      'assets/Henri.png',
      'assets/Louis.png',
      'assets/Hugo.png',
      'assets/Quentin.png',
      'assets/Tanguy.png',
      'assets/Cédric.png',
    ];

    expect(find.byKey(Key('member_image_0')), findsOneWidget);
    expect(find.byKey(Key('member_image_1')), findsOneWidget);
    expect(find.byKey(Key('member_image_2')), findsOneWidget);
    expect(find.byKey(Key('member_image_3')), findsOneWidget);
    expect(find.byKey(Key('member_image_4')), findsOneWidget);
  });

  test('ContainerTest toJson and fromJson', () {
    final container = MyContainerList(
      id: 1,
      createdAt: '2022-01-01',
      organization: 'Test Organization',
      organizationId: 123,
      containerMapping: {},
      price: 29.99,
      adress: "blabla",
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
    expect(parsedContainer.adress, container.adress);
    expect(parsedContainer.city, container.city);
    expect(parsedContainer.design, container.design);
    expect(parsedContainer.informations, container.informations);
  });
}
