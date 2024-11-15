import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/team/team_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  group('TeamPage visual tests', () {
    testWidgets('Visual elements render correctly on TeamPage',
        (WidgetTester tester) async {
      final testPage = initPage(const TeamPage());
      await waitForLoader(tester: tester, testPage: testPage);
    });
  });
}
