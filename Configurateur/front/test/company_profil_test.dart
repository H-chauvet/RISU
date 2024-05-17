// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/app_routes.dart';
import 'package:front/screens/company-profil/company-profil.dart';
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
          child: const MaterialApp(
            home: CompanyProfilPage(),
          ),
        ))));
    final state_assign =
        tester.state(find.byType(CompanyProfilPage)) as CompanyProfilPageState;

    state_assign.setState(() {
      state_assign.organization = OrganizationList(
          id: 1,
          name: 'test',
          type: 'test',
          affiliate: null,
          containers: null,
          contactInformation: 'test');
    });

    await tester.pump();

    await tester.tap(find.byKey(Key('edit-password')));
    await tester.pump();

    //expect(find.text("Pas d'entreprise associée"), findsOneWidget);
    //expect(find.text("Nos Conteneurs :"), findsOneWidget);

    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
