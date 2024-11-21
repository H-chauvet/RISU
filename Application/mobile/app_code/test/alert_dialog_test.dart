import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/alert_dialog.dart';

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

  testWidgets('Info AlertDialog', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(Scaffold()));

    MyAlertDialog.showInfoAlertDialog(
        key: const Key('alert_dialog_info'),
        context: tester.element(find.byType(Scaffold)),
        title: 'Yo',
        message: 'Yo');

    await tester.pumpAndSettle();

    Finder infoAlertDialog = find.byKey(const Key('alert_dialog_info'));
    expect(infoAlertDialog, findsOneWidget);
  });
}
