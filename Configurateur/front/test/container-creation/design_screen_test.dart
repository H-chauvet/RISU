// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/recap_panel/recap_panel.dart';
import 'package:front/screens/container-creation/design_screen/design_screen.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:sizer/sizer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Payment confirmation screen', (WidgetTester tester) async {
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
                child: DesignScreen(
                  lockers:
                      '[{"type":"Petit casier","price":50},{"type":"Moyen casier","price":100},{"type":"Grand casier","price":150}]',
                  amount: 60,
                  containerMapping: '1',
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Choix du design du conteneur"), findsOneWidget);
    expect(find.text("Suivant"), findsOneWidget);
    expect(find.text("Précédent"), findsOneWidget);
    expect(find.text("Retirer une image"), findsOneWidget);
    expect(find.text("Petit Casier"), findsOneWidget);
    expect(find.text("50€"), findsOneWidget);
    expect(find.text("Moyen Casier"), findsOneWidget);
    expect(find.text("100€"), findsOneWidget);
    expect(find.text("Grand Casier"), findsOneWidget);
    expect(find.text("150€"), findsOneWidget);

    await tester.tap(find.text("Suivant"));
    await tester.tap(find.text("Précédent"));

    await tester.pumpAndSettle();
  });

  testWidgets('loadImage devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage derrière', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.face = "Derrière";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage gauche', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();

    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.face = "Gauche";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage droite', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.face = "Droite";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage Haut', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.face = "Haut";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('loadImage Bas', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    List<PlatformFile> files = [];
    files.add(PlatformFile(
        path: 'test', name: 'test', size: 20, bytes: Uint8List(20)));
    designScreenState.face = "Bas";

    await designScreenState.loadImage(true, fileData: Uint8List(20));

    await tester.pump();

    expect(designScreenState.imageIndex, 1);
    expect(designScreenState.materialIndex, 2);
  });

  testWidgets('removeImage Bas', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Bas";

    await designScreenState.removeImage(true, 4);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Haut', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Haut";

    await designScreenState.removeImage(true, 2);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Gauche', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Gauche";

    await designScreenState.removeImage(true, 3);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Droite', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Droite";

    await designScreenState.removeImage(true, 5);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('removeImage Devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Devant";

    await designScreenState.removeImage(true, 0);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('sumPrice', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));
    designScreenState.lockerss.add(Locker("Design personnalisé", 100));
    designScreenState.lockerss.add(Locker("Design personnalisé", 150));

    designScreenState.face = "Devant";

    int price = designScreenState.sumPrice();

    await tester.pump();

    expect(price, 300);
  });

  testWidgets('removeImage Devant', (WidgetTester tester) async {
    DesignScreenState designScreenState = DesignScreenState();
    designScreenState.unitTest = true;

    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    obj.fragments[0].faces[0].materialIndex = 1;
    designScreenState.objs.add(obj);
    designScreenState.lockerss.add(Locker("Design personnalisé", 50));

    designScreenState.face = "Derrière";

    await designScreenState.removeImage(true, 1);

    await tester.pump();

    expect(designScreenState.lockerss.length, 0);
  });

  testWidgets('Load container', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
                child: DesignScreen(
                  lockers:
                      '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
                  amount: 60,
                  containerMapping: '0000000111111111112222333',
                  id: '1',
                  container: jsonEncode(container),
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
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

  testWidgets('Save', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
                child: DesignScreen(
                  lockers:
                      '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
                  amount: 60,
                  containerMapping: '0000000111111111112222333',
                  id: '1',
                  container: jsonEncode(container),
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text("Sauvegarder"));

    await tester.pump();
  });

  testWidgets('Remove image', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    when(sharedPreferences.getString('token')).thenReturn('test-token');

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
                child: DesignScreen(
                  lockers:
                      '[{"type":"Petit casier","price":10},{"type":"Moyen casier","price":20},{"type":"Grand casier","price":30}]',
                  amount: 60,
                  containerMapping: '0000000111111111112222333',
                  id: '1',
                  container: jsonEncode(container),
                ),
              ),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: const Locale('fr'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text("Retirer une image"));

    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
