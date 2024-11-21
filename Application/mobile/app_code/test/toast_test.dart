import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/toast.dart';

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

  testWidgets('Toast message', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(Scaffold()));

    MyToastMessage.show(
        message: 'Yo', context: tester.element(find.byType(Scaffold)));
  });
}
