import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/container/container_list.dart';
import 'package:risu/pages/container/container_page.dart';

import 'globals.dart';

void main() {
  testWidgets('ContainerStat full info', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const ContainerPage()));
    await tester.pump();
    expect(find.text("Liste des conteneurs"), findsOneWidget);
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('ContainerMobilePage displays message details',
      (WidgetTester tester) async {
    final List<ContainerList> containers = [];
    containers.add(
      ContainerList(
        id: 1,
        price: 10,
        createdAt: null,
        organization: null,
        organizationId: 2,
        containerMapping: null,
      ),
    );

    await tester.pumpWidget(
      initPage(
        Scaffold(
          body: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: containers.length,
                itemBuilder: (context, index) {
                  final product = containers[index];
                  return ContainerCard(
                    container: product,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    // expect(find.text("""), findsOneWidget);
    expect(find.text("1"), findsOneWidget);
  });

  testWidgets('ContainerMobileCard displays message details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        ContainerCard(
          container: ContainerList(
            id: 1,
            price: 10,
            createdAt: null,
            organization: null,
            organizationId: 1,
            containerMapping: null,
          ),
        ),
      ),
    );

    expect(find.text("1"), findsOneWidget);
  });
}
