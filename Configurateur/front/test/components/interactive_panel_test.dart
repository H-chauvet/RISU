import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/components/interactive_panel.dart';

void main() {
  testWidgets('test interactive panel', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(const MaterialApp(home: InteractivePanel()));

    expect(find.image(const AssetImage("assets/cube.png")), findsWidgets);
  });
}
