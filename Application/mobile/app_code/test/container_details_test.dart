import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:risu/pages/container/details_page.dart';
import 'package:risu/pages/container/details_state.dart';

import 'globals.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets(
    'Container details should not be displayed from empty id',
    (WidgetTester tester) async {
      final testPage = initPage((const ContainerDetailsPage(containerId: -1)));
      await waitForLoader(tester: tester, testPage: testPage);

      final ContainerDetailsState testData =
          tester.state(find.byType(ContainerDetailsPage));
      expect(testData.getContainerId(), -1);
      expect(testData.getAddress(), '');
      expect(testData.getCity(), '');
      expect(testData.getAvailableItems(), 0);

      Finder containerData =
          find.byKey(const Key('container-details_article-list'));
      expect(containerData, findsOneWidget);

      await tester.pumpAndSettle();
      Finder articleListButton =
          find.byKey(const Key('container-button_article-list-page'));
      expect(articleListButton, findsOneWidget);
    },
  );
}
