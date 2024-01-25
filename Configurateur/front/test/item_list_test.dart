import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:front/screens/company/company.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('ItemCard displays message details', (WidgetTester tester) async {
    when(sharedPreferences.getString('token')).thenReturn('test-token');

    await tester.pumpWidget(
      MaterialApp(
        home: ItemCard(
          item: ItemList(
            id: 1,
            name: "Hello world",
            price: 10.0,
            createdAt: null,
            available: true,
            containerId: 2,
            container: 0,
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text(1.toString()), findsOneWidget);
    expect(find.text("Hello world"), findsOneWidget);
  });
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
