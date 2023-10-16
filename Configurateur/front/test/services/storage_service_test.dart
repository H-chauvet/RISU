import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/main.dart';
import 'package:front/services/storage_service.dart';

void main() {
  test('test storage service', () {
    runApp(const MyApp());
    StorageService storageService = StorageService();

    storageService.writeStorage('test', 'key');

    storageService.readStorage('test').then((value) {
      expect(value, 'key');
    });
  });
}
