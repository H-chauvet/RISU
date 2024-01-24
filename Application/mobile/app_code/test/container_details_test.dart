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
      await tester
          .pumpWidget(initPage(const ContainerDetailsPage(containerId: '')));

      final ContainerDetailsState testData =
          tester.state(find.byType(ContainerDetailsPage));
      expect(testData.getContainerId(), '');
      expect(testData.getAddress(), '');
      expect(testData.getLocalization(), '');
      expect(testData.getAvailableItems(), 0);

      Finder titleData = find.byKey(const Key('container-details_title'));
      expect(titleData, findsOneWidget);

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
