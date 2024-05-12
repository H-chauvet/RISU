import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/components/items-information.dart';
import 'package:front/app_routes.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

void main() {
  final ItemListInfo mockItem = ItemListInfo(
    id: 1,
    name: 'Test Item',
    available: true,
    container: 123,
    createdAt: '2022-01-01',
    containerId: '456',
    price: 19.99,
    image: 'item_image.png',
    description: "description",
    category: "sport",
  );

  testWidgets('ItemListInfo should render without error',
      (WidgetTester tester) async {
    final Map<String, dynamic> containerJson = mockItem.toMap();
    final ItemListInfo parsedContainer = ItemListInfo.fromJson(containerJson);

    expect(parsedContainer.id, mockItem.id);
    expect(parsedContainer.createdAt, mockItem.createdAt);
    expect(parsedContainer.name, mockItem.name);
    expect(parsedContainer.available, mockItem.available);
    expect(parsedContainer.container, mockItem.container);
    expect(parsedContainer.price, mockItem.price);
    expect(parsedContainer.containerId, mockItem.containerId);
    expect(parsedContainer.image, mockItem.image);
    expect(parsedContainer.description, mockItem.description);
  });
}
