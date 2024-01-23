import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/container-list/item-list/item_component.dart';
import 'package:front/screens/company/company.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
<<<<<<< HEAD
  testWidgets('ItemCard displays message details', (WidgetTester tester) async {
=======
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
  });

  testWidgets('ItemCard displays message details', (WidgetTester tester) async {
    when(sharedPreferences.getString('token')).thenReturn('test-token');

>>>>>>> dev
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
            image: "image",
            description: "c'est un objet",
          ),
          onDelete: (message) {},
        ),
      ),
    );

    expect(find.text("1"), findsOneWidget);
    expect(find.text("Hello world"), findsOneWidget);
  });
<<<<<<< HEAD

  test('ContainerTest toJson and fromJson', () {
    final container = ItemList(
      id: 1,
      name: "Hello world",
      price: 10.0,
      createdAt: null,
      available: true,
      containerId: 2,
      container: 0,
      image: "image",
      description: "c'est un objet",
    );

    final Map<String, dynamic> containerJson = container.toMap();
    final ItemList parsedContainer = ItemList.fromJson(containerJson);

    expect(parsedContainer.id, container.id);
    expect(parsedContainer.name, container.name);
    expect(parsedContainer.price, container.price);
    expect(parsedContainer.createdAt, container.createdAt);
    expect(parsedContainer.available, container.available);
    expect(parsedContainer.container, container.container);
    expect(parsedContainer.containerId, container.containerId);
    expect(parsedContainer.image, container.image);
    expect(parsedContainer.description, container.description);
  });
}
=======
}

class MockSharedPreferences extends Mock implements SharedPreferences {}
>>>>>>> dev
