import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/recap_panel/recap_panel.dart';
import 'package:front/screens/container-creation/container_creation/container_creation.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:sizer/sizer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });
  testWidgets('Container Creation progress bar', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerCreation(),
              ),
            );
          },
        ),
      ),
    );

    expect(find.text('Précédent'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });

  testWidgets(
    'Disabled lockers',
    (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      when(sharedPreferences.getString('containerData')).thenReturn('');
      when(sharedPreferences.getString('token')).thenReturn('test-token');

      List<List<String>> containerList = [
        ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
        ['0', '0', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0'],
        ['0', '0', '0', '0', '2', '0', '0', '0', '0', '0', '0', '0'],
        ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
        ['0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0', '0'],
      ];

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
                home: InheritedGoRouter(
                  goRouter: AppRouter.router,
                  child: ContainerCreation(
                    containerMapping: jsonEncode(containerList),
                    height: '5',
                    width: '12',
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );

  testWidgets('Container Creation invalid JWT token',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerCreation(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();
  });

  testWidgets('Container Creation progress bar 3', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerCreation(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(const Key('previous')));
  });

  testWidgets('Container Creation go next', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerCreation(),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    await tester.tap(find.byKey(const Key('terminate')));
  });

  testWidgets('updateCube', (WidgetTester tester) async {
    ContainerCreationState containerCreationState = ContainerCreationState();

    containerCreationState.unitTest = true;
    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 12, 5, 2);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    containerCreationState.objs.add(obj);

    containerCreationState.updateCube(
        LockerCoordinates(1, 2, 'Devant', 'Haut', 1), true);
    containerCreationState.updateCube(
        LockerCoordinates(2, 2, 'Derrière', 'Haut', 2), true);
    containerCreationState.updateCube(
        LockerCoordinates(3, 5, 'Devant', 'Bas', 3), true);
    containerCreationState.updateCube(
        LockerCoordinates(4, 1, 'Devant', 'Bas', 4), true);

    await tester.pump();

    expect(containerCreationState.sumPrice(), 350);

    containerCreationState.autoFillContainer('Devant', true);

    containerCreationState.autoFillContainer('Derrière', true);

    containerCreationState.autoFillContainer('Toutes', true);

    expect(containerCreationState.lockers[0].type, 'Petit casier');
    expect(containerCreationState.lockers[0].price, 50);
    expect(containerCreationState.lockers[1].type, 'Moyen casier');
    expect(containerCreationState.lockers[1].price, 100);
    expect(containerCreationState.lockers[2].type, 'Grand casier');
    expect(containerCreationState.lockers[2].price, 150);
    expect(containerCreationState.lockers[3].type, 'Petit casier');
    expect(containerCreationState.lockers[3].price, 50);
  });

  testWidgets('moveLocker', (WidgetTester tester) async {
    ContainerCreationState containerCreationState = ContainerCreationState();

    containerCreationState.unitTest = true;
    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 12, 5, 2);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    containerCreationState.objs.add(obj);

    containerCreationState.objs[0].fragments[1].faces[0].materialIndex = 1;

    containerCreationState.moveLocker(0, 0, 1, 1, 0, 0);

    await tester.pump();

    expect(
        containerCreationState.objs[0].fragments[0].faces[0].materialIndex, 1);
    expect(
        containerCreationState.objs[0].fragments[1].faces[0].materialIndex, 0);
  });

  testWidgets('Load container', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');
    when(sharedPreferences.getString('containerData')).thenReturn('');

    var container = {
      'id': '1',
      'saveName': 'test',
      'height': '12',
      'width': '5',
      'containerMapping': '0000000111111111112222333',
      'designs': jsonEncode([]),
    };

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
              home: InheritedGoRouter(
                goRouter: AppRouter.router,
                child: ContainerCreation(
                  id: '1',
                  container: jsonEncode(container),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.pump();

    expect(find.text("Petit Casier"), findsNWidgets(1));
    expect(find.text("Moyen Casier"), findsNWidgets(1));
    expect(find.text("Grand Casier"), findsNWidgets(1));
  });

  testWidgets('Reset container', (WidgetTester tester) async {
    ContainerCreationState containerCreationState = ContainerCreationState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 12, 5, 2);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    containerCreationState.objs.add(obj);
    containerCreationState.unitTest = true;

    containerCreationState.objs[0].fragments[1].faces[0].materialIndex = 1;

    containerCreationState.resetContainer();

    await tester.pump();

    expect(containerCreationState.lockers, []);
    for (int i = 0; i < containerCreationState.objs[0].fragments.length; i++) {
      expect(containerCreationState.objs[0].fragments[i].faces[0].materialIndex,
          0);
      expect(containerCreationState.objs[0].fragments[i].faces[1].materialIndex,
          0);
      expect(containerCreationState.objs[0].fragments[i].faces[2].materialIndex,
          0);
      expect(containerCreationState.objs[0].fragments[i].faces[3].materialIndex,
          0);
      expect(containerCreationState.objs[0].fragments[i].faces[4].materialIndex,
          0);
      expect(containerCreationState.objs[0].fragments[i].faces[5].materialIndex,
          0);
    }
  });

  testWidgets('Delete locker', (WidgetTester tester) async {
    ContainerCreationState containerCreationState = ContainerCreationState();

    containerCreationState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 12, 5, 2);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    containerCreationState.objs.add(obj);
    containerCreationState.unitTest = true;
    containerCreationState.width = 12;
    containerCreationState.height = 5;

    containerCreationState.objs[0].fragments[1].faces[0].materialIndex = 1;

    containerCreationState.updateCube(
        LockerCoordinates(1, 1, 'Devant', 'Haut', 2), true);

    expect(
        containerCreationState.objs[0].fragments[0].faces[0].materialIndex, 2);
    expect(
        containerCreationState.objs[0].fragments[12].faces[0].materialIndex, 2);

    containerCreationState.deleteLocker(
        LockerCoordinates(1, 1, 'Devant', 'Haut', 2), true);

    await tester.pump();

    expect(
        containerCreationState.objs[0].fragments[0].faces[0].materialIndex, 0);
    expect(
        containerCreationState.objs[0].fragments[12].faces[0].materialIndex, 0);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
