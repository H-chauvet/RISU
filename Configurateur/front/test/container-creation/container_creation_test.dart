import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/container-creation/container_creation.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  testWidgets('Container Creation progress bar', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    expect(find.text('Précédent'), findsOneWidget);
    expect(find.text('Suivant'), findsOneWidget);
  });

  testWidgets('Container Creation invalid JWT token',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();
  });

  testWidgets('Container Creation progress bar 3', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('previous')));
  });

  testWidgets('Container Creation go next', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('terminate')));
  });

  testWidgets('Container Creation back view panel from front',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('back-view')));
  });

  testWidgets('Container Creation back view panel from left',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('front-view')));
  });

  testWidgets('Container Creation back view panel 2',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('front-view')));
    await tester.tap(find.byKey(const Key('left-view')));
  });

  testWidgets('Container Creation back view panel 3',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (_) => ThemeService(),
        ),
      ],
      child: MaterialApp(
        home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: const ContainerCreation(),
        ),
      ),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('front-view')));
  });

  testWidgets('updateCube', (WidgetTester tester) async {
    ContainerCreationState containerCreationState = ContainerCreationState();

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
}
