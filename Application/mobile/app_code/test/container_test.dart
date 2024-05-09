import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/container/container_card.dart';
import 'package:risu/pages/container/container_page.dart';

import 'globals.dart';

void main() {
  testWidgets('ContainerStat full info', (WidgetTester tester) async {
    await tester
        .pumpWidget(initPage(ContainerPage(onDirectionClicked: (id) {})));
    await tester.pump();
    expect(find.byType(ListView), findsNothing);
  });

  testWidgets('ContainerMobileCard displays message details',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        ContainerCard(
          container: ContainerList(
            id: 1,
            address: 'rue george',
            city: 'nantes',
            longitude: 0,
            latitude: 0,
            itemCount: 0
          ),
          onDirectionClicked: (id) {},
        ),
      ),
    );

    expect(find.text("nantes"), findsOneWidget);
    expect(find.text("rue george"), findsOneWidget);
  });
}
