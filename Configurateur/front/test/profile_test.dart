import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/profile/profile_page.dart';
import 'package:front/services/storage_service.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('Test de ProfilePage', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    TestWidgetsFlutterBinding.ensureInitialized();

    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(const MaterialApp(
      home: ProfilePage(),
    ));

    expect(find.text('Informations personnelles'), findsOneWidget);
    expect(find.text('Nom : Chauvet'), findsOneWidget);
    expect(find.text('Prénom : Henri'), findsOneWidget);
    expect(find.text('E-Mail : henri.chauvet@epitech.eu'), findsOneWidget);
    expect(find.text('Mot de passe : ************'), findsOneWidget);
    expect(find.text('Informations bancaires'), findsOneWidget);
    expect(find.text('Type de paiement : Carte Bancaire'), findsOneWidget);
    expect(find.text('N° Carte : 5132 **** **** **78'), findsOneWidget);

    await tester.tap(find.text('Déconnexion'));
    await tester.pump();
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
