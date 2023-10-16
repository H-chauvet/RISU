import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/container-creation/container_creation.dart';

void main() {
  testWidgets('Container Creation progress bar', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    expect(find.text('Précédent'), findsOneWidget);
    expect(find.text('Terminer'), findsOneWidget);
  });

  /*testWidgets('updateCube', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    ContainerCreationState containerCreationState = ContainerCreationState();

    containerCreationState
        .updateCube(LockerCoordinates(1, 2, 'Devant', 'Haut', 1, 'Rouge'));
    containerCreationState
        .updateCube(LockerCoordinates(2, 2, 'Derrière', 'Haut', 2, 'Bleu'));
    containerCreationState
        .updateCube(LockerCoordinates(3, 5, 'Devant', 'Bas', 3, 'Vert'));

    expect(containerCreationState.lockers[0].type, 'Petit casier');
    expect(containerCreationState.lockers[0].price, 50);
    expect(containerCreationState.lockers[1].type, 'Moyen casier');
    expect(containerCreationState.lockers[1].price, 100);
    expect(containerCreationState.lockers[2].type, 'Grand casier');
    expect(containerCreationState.lockers[2].price, 150);
  });*/
}
