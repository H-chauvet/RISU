import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/settings/settings_page.dart';

import 'globals.dart';

void main() {
  group('Test Settings', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Init Page', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const SettingsPage()));

      Finder deleteTextButton =
      find.byKey(const Key('settings-textbutton_delete-account'));
      Finder bottomSizedBox =
      find.byKey(const Key("settings-sized_box-bottom"));

      expect(deleteTextButton, findsOneWidget);
      expect(bottomSizedBox, findsOneWidget);

      await tester.dragUntilVisible(
          deleteTextButton, // what you want to find
          bottomSizedBox, // widget you want to scroll
          const Offset(0, -300) // delta to move
      );

      await tester.tap(deleteTextButton);
      await tester.pump();

      await tester.tap(find.text("Supprimer"));
      await tester.pump();
    });
  });
}
