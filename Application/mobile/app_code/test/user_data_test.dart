import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/utils/user_data.dart';

void main() {
  group('UserData Integration Tests', () {
    test('UserData constructor should create an instance with email', () {
      final userData = UserData(
          email: 'test@example.com', firstName: 'Test', lastName: 'Example');
      expect(userData.email, 'test@example.com');
      expect(userData.token, isNull);
    });

    test('UserData displayUserEmail should return a Text widget with email',
        () {
      final userData = UserData(
          email: 'test@example.com', firstName: 'Test', lastName: 'Example');
      final widget = userData.displayUserEmail();
      expect(widget, isA<Column>());
      final column = widget as Column;
      expect(column.children.length, 1);
      final text = column.children.first as Text;
      expect(text.data, 'test@example.com');
    });

    test('UserData.fromJson should create an instance from a JSON map', () {
      final jsonData = {
        'user': {'email': 'test@example.com'},
        'token': 'test_token',
      };
      final userData = UserData.fromJson(jsonData);
      expect(userData.email, 'test@example.com');
      expect(userData.token, 'test_token');
    });

    test('UserData.fromJson should handle missing token in JSON', () {
      final jsonData = {
        'user': {'email': 'test@example.com'},
      };
      final userData = UserData.fromJson(jsonData);
      expect(userData.email, 'test@example.com');
      expect(userData.token, isNull);
    });
  });
}
