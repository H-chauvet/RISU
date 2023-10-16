import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/components/progress_bar.dart';

void voidFunc() {}

void main() {
  testWidgets('test progress bar', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(const MaterialApp(
        home: ProgressBar(
      length: 5,
      progress: 1,
      next: 'Suivant',
      previous: 'Précédent',
      previousFunc: voidFunc,
      nextFunc: voidFunc,
    )));

    expect(find.byKey(const Key("circleShape_0")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_1")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_2")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_3")), findsOneWidget);
    expect(find.byKey(const Key("circleShape_4")), findsOneWidget);
  });
}
