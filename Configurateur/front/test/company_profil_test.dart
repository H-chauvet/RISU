import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/screens/company-profil/company-profil.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

void main() {
  final OrganizationList mockItem = OrganizationList(
    id: 1,
    name: "Risu",
    type: "Entreprise",
    affiliate: "affiliate",
    containers: "des conteneurs",
    contactInformation: "information",
  );

  testWidgets('CompanyPage should render without error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyProfilPage(),
    ));

    expect(find.byType(CompanyProfilPage), findsOneWidget);
    await tester.pump();

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(Image), findsWidgets);
    expect(find.byIcon(Icons.edit), findsWidgets);
    expect(find.text("Nos Conteneurs :"), findsOneWidget);
  });

  testWidgets('Show Edit Popup for Company Name', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyProfilPage(),
    ));

    expect(find.byType(CompanyProfilPage), findsOneWidget);
    await tester.pump();

    expect(find.byIcon(Icons.edit), findsWidgets);

    await tester.tap(find.byIcon(Icons.edit).at(0));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Risu V2');
    await tester.tap(find.text('Modifier').first);
    await tester.pumpAndSettle();
  });

  testWidgets('Show Edit Popup for Company Informations',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: CompanyProfilPage(),
    ));

    expect(find.byType(CompanyProfilPage), findsOneWidget);
    await tester.pump();

    expect(find.byIcon(Icons.edit), findsWidgets);

    await tester.tap(find.byIcon(Icons.edit).at(0));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'New Contact Information');
    await tester.tap(find.text('Modifier').first);
    await tester.pumpAndSettle();
    expect(find.text('Nouvelles informations'), findsOneWidget);
  });
}
