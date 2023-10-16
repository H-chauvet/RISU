import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/components/recap_panel.dart';

void main() {
  void blankSaved() {}
  testWidgets('test sum price', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    List<Locker> list = List.filled(2, Locker('locker', 100));

    await tester.pumpWidget(MaterialApp(
        home: RecapPanel(
      articles: list,
      onSaved: blankSaved,
    )));

    expect(find.text('prix: 200€'), findsOneWidget);
  });

  testWidgets('test locker list display', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    List<Locker> list = List.filled(2, Locker('locker', 100));

    await tester.pumpWidget(MaterialApp(
        home: RecapPanel(
      articles: list,
      onSaved: blankSaved,
    )));

    expect(find.text('locker'), findsNWidgets(2));
    expect(find.text('100€'), findsNWidgets(2));
  });
}
