// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/screens/container-creation/design_screen.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Payment confirmation screen', (WidgetTester tester) async {
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
          child: const DesignScreen(
            lockers:
                '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
            amount: 60,
            containerMapping: '1',
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text("Design"), findsOneWidget);
    expect(find.text("Suivant"), findsOneWidget);
    expect(find.text("Précédent"), findsOneWidget);
    expect(find.text("Importer une image"), findsOneWidget);
    expect(find.text("Retirer l'image sélectionner"), findsOneWidget);
    expect(find.text("Appliquer"), findsOneWidget);
    expect(find.text("Petit casier"), findsOneWidget);
    expect(find.text("10€"), findsOneWidget);
    expect(find.text("Moyen casier"), findsOneWidget);
    expect(find.text("20€"), findsOneWidget);
    expect(find.text("Grand casier"), findsOneWidget);
    expect(find.text("30€"), findsOneWidget);

    await tester.tap(find.text("Suivant"));
    await tester.tap(find.text("Précédent"));
    await tester.tap(find.text("Retirer l'image sélectionner"));

    await tester.pumpAndSettle();
  });

  testWidgets('Payment confirmation screen', (WidgetTester tester) async {
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
          child: const DesignScreen(
            lockers:
                '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
            amount: 60,
            containerMapping: '1',
          ),
        ),
      ),
    ));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.byKey(const Key('design-face')));

    await tester.pump();

    await tester.tap(find.text('Devant').last);

    await tester.pumpAndSettle();
  });

  testWidgets('loadImage devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage derrière', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);
    designScreenState.face = "Derrière";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage gauche', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);
    designScreenState.face = "Gauche";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage droite', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);
    designScreenState.face = "Droite";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage Haut', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);
    designScreenState.face = "Haut";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage Bas', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.picked = FilePickerResult(files);
    designScreenState.face = "Bas";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('removeImage Bas', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design face du dessous", 50));

    designScreenState.face = "Bas";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Haut', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design face du haut", 50));

    designScreenState.face = "Haut";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Gauche', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design côté gauche", 50));

    designScreenState.face = "Gauche";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Droite', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design côté droit", 50));

    designScreenState.face = "Droite";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design face avant", 50));

    designScreenState.face = "Devant";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("design face arrière", 50));

    designScreenState.face = "Derrière";

    await designScreenState.removeImage(true);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });
}