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
      var aaaa = initPage((const ContainerDetailsPage(containerId: '')));
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

      final ContainerDetailsState testData =
      tester.state(find.byType(ContainerDetailsPage));
      expect(testData.getContainerId(), '');
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
