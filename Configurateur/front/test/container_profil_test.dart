import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/components/container.dart';
import 'package:front/components/items-information.dart';
import 'package:front/screens/company-profil/container-profil.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_test.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Test de company profil page', (WidgetTester tester) async {
    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeService>(
            create: (_) => ThemeService(),
          ),
        ],
        child: MaterialApp(
            home: InheritedGoRouter(
          goRouter: AppRouter.router,
          child: MaterialApp(
            home: ContainerProfilPage(
                container: ContainerListData(
                    id: 1,
                    createdAt: null,
                    organization: null,
                    organizationId: 1,
                    containerMapping: null,
                    price: 10,
                    address: 'oui',
                    city: 'nantes',
                    design: null,
                    informations: 'info',
                    saveName: "saveName")),
          ),
        ))));

    final state_assign = tester.state(find.byType(ContainerProfilPage))
        as ContainerProfilPageState;

    state_assign.setState(() {
      state_assign.container = ContainerListData(
          id: 1,
          createdAt: null,
          organization: null,
          organizationId: 1,
          containerMapping: null,
          price: 10,
          address: 'oui',
          city: 'nantes',
          design: null,
          informations: 'info',
          saveName: "saveName");
      state_assign.items = [
        ItemList(
          id: 1,
          name: 'Item1',
          description: 'Description1',
          price: 100.0,
          available: true,
          container: null,
          createdAt: null,
          containerId: null,
          image: null,
          category: null,
        )
      ];
    });
    await tester.pump();

    // Edit information
    await tester.tap(find.byKey(Key('edit-city')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('city')), 'infor orga');

    await tester.tap(find.byKey(const Key('cancel-edit-city')));
    await tester.pump();

    // EDIT INFO 2
    await tester.tap(find.byKey(Key('edit-city')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('city')), 'infor orga');

    await tester.tap(find.byKey(const Key('button-city')));
    await tester.pump();

    // EDIT ADDRESS
    await tester.tap(find.byKey(Key('edit-address')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('address')), 'infor orga');

    await tester.tap(find.byKey(const Key('cancel-edit-address')));
    await tester.pump();

    // EDIT ADDRESS 2
    await tester.tap(find.byKey(Key('edit-address')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(2));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('address')), 'infor orga');

    await tester.tap(find.byKey(const Key('button-address')));
    await tester.pump();

    // EDIT ITEM
    await tester.tap(find.byKey(Key('edit-items')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(1));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('name')), 'name container');
    await tester.enterText(find.byKey(const Key('price')), 'price container');
    await tester.enterText(
        find.byKey(const Key('description')), 'desc container');

    await tester.tap(find.byKey(const Key('cancel-edit-item')));
    await tester.pump();

    // EDIT ITEM 2
    await tester.tap(find.byKey(Key('edit-items')));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Modifier'), findsNWidgets(1));
    expect(find.text('Annuler'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('name')), 'name container');
    await tester.enterText(find.byKey(const Key('price')), 'price container');
    await tester.enterText(
        find.byKey(const Key('description')), 'desc container');

    await tester.tap(find.byKey(const Key('button-item')));
    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
