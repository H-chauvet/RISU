import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/services/locker_service.dart';

void main() {
  void blankFunction(LockerCoordinates coordinates) {}

  testWidgets('test interactive panel', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(
        MaterialApp(home: InteractivePanel(callback: blankFunction)));

    expect(find.image(const AssetImage("assets/cube.png")), findsWidgets);
  });
}
