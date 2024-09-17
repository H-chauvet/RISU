import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/container.dart';
import 'package:front/app_routes.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:sizer/sizer.dart';

Future<void> deleteContainer(ContainerListData container) async {}

void main() {
  final ContainerListData mockItem = ContainerListData(
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
  testWidgets('ContainerListData should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: ContainerCards(
              container: mockItem,
              onDelete: deleteContainer,
              page: 'page',
            ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          );
        },
      ),
    );

    expect(find.byType(ContainerCards), findsOneWidget);
    await tester.pump();
    expect(find.text("Ville : Nantes"), findsOneWidget);
    expect(find.text("Adresse : 4 rue George"), findsOneWidget);
  });

  testWidgets('Show Edit Popup for Name', (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: ContainerCards(
              container: mockItem,
              onDelete: deleteContainer,
              page: 'page',
            ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          );
        },
      ),
    );

    await tester.tap(find.byIcon(Icons.delete).first);
    await tester.pumpAndSettle();
  });

  testWidgets('ContainerListData should render without error',
      (WidgetTester tester) async {
    final Map<String, dynamic> containerJson = mockItem.toMap();
    final ContainerListData parsedContainer =
        ContainerListData.fromJson(containerJson);

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

  testWidgets('ContainerListData should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: ContainerCards(
              container: mockItem,
              onDelete: deleteContainer,
              page: "page",
            ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          );
        },
      ),
    );

    expect(find.byType(ContainerCards), findsOneWidget);
    await tester.pump();
    expect(find.text("Ville : Nantes"), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete));

    await tester.pumpAndSettle();
  });

  testWidgets('ContainerListData test Icon arrow_forward',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MaterialApp(
            home: ContainerCards(
              container: mockItem,
              onDelete: deleteContainer,
              page: "page",
            ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('fr'),
          );
        },
      ),
    );

    expect(find.byType(ContainerCards), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
