import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/container.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

Future<void> deleteContainer(CtnList container) async {}

void main() {
  final CtnList mockItem = CtnList(
    id: 1,
    createdAt: '2022-01-01',
    organization: "orga",
    organizationId: 1,
    containerMapping: "ctnMapping",
    price: 19.99,
    address: "4 rue George",
    city: "Nantes",
    design: "design",
    informations: "c'est une info",
    saveName: "Container V12",
  );
  testWidgets('CtnList should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContainerCards(
        container: mockItem,
        onDelete: deleteContainer,
        page: 'page'
      ),
    ));

    expect(find.byType(ContainerCards), findsOneWidget);
    await tester.pump();
    expect(find.text("Ville : Nantes"), findsOneWidget);
    expect(find.text("adresse : 4 rue George"), findsOneWidget);
  });

  testWidgets('Show Edit Popup for Name', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContainerCards(
        container: mockItem,
        onDelete: deleteContainer,
        page: 'page',
      ),
    ));

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
  });

  testWidgets('CtnList should render without error',
      (WidgetTester tester) async {
    final Map<String, dynamic> containerJson = mockItem.toMap();
    final CtnList parsedContainer = CtnList.fromJson(containerJson);

    expect(parsedContainer.id, mockItem.id);
    expect(parsedContainer.createdAt, mockItem.createdAt);
    expect(parsedContainer.organization, mockItem.organization);
    expect(parsedContainer.organizationId, mockItem.organizationId);
    expect(parsedContainer.containerMapping, mockItem.containerMapping);
    expect(parsedContainer.price, mockItem.price);
    expect(parsedContainer.address, mockItem.address);
    expect(parsedContainer.city, mockItem.city);
    expect(parsedContainer.design, mockItem.design);
    expect(parsedContainer.informations, mockItem.informations);
    expect(parsedContainer.saveName, mockItem.saveName);
  });

  testWidgets('CtnList should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContainerCards(
        container: mockItem,
        onDelete: deleteContainer,
        page: "page",
      ),
    ));

    expect(find.byType(ContainerCards), findsOneWidget);
    await tester.pump();
    expect(find.text("Ville : Nantes"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));

    await tester.pumpAndSettle();
  });

  testWidgets('CtnList test Icon arrow_forward',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ContainerCards(
        container: mockItem,
        onDelete: deleteContainer,
        page: "page",
      ),
    ));

    expect(find.byType(ContainerCards), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
