import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/showModalBottomSheet.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Bottom sheet', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(Scaffold()));

    myShowModalBottomSheet(
        tester.element(find.byType(Scaffold)), 'Yo', Text('Yo'));

    await tester.pumpAndSettle();

    Finder bottomSheet = find.byKey(const Key('bottom_sheet'));
    expect(bottomSheet, findsOneWidget);
  });
}
