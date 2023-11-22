import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:risu/components/drop_down_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('MyDropdownButton', () {
    late MockSharedPreferences sharedPreferences;

    setUp(() {
      sharedPreferences = MockSharedPreferences();
    });

    testWidgets('Dropdown shows loading when waiting for theme',
        (WidgetTester tester) async {
      when(sharedPreferences.getBool('isDarkTheme')).thenReturn(null);

      await tester.pumpWidget(
        const MaterialApp(
            home: Scaffold(
          body: MyDropdownButton(),
        )),
      );

      expect(find.text('Loading...'), findsOneWidget);
      expect(find.text('Error'), findsNothing);
      expect(find.text('Clair'), findsNothing);
      expect(find.text('Sombre'), findsNothing);
    });
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
