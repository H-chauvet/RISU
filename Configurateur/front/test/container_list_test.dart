import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/container-list/container_web.dart';
import 'package:front/screens/company/company.dart';

void main() {
  
  testWidgets('UserMobileCard displays message details', (WidgetTester tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: ContainerCard(
          container: ContainerList(
            id: 1,
            price: 10.0,
            createdAt: null,
            organization: null,
            organizationId: 2,
            containerMapping: null,
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text(1.toString()), findsOneWidget);
    expect(find.text(10.0.toString()), findsOneWidget);
  });
}