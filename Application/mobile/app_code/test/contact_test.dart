import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';

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

  testWidgets('ContactPage full info', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage = initPage(const ContactPage());
    await waitForLoader(tester: tester, testPage: testPage);

    Finder errorAlertDialog = find.byKey(const Key("alertdialog-button_ok"));
    Finder buttonAddTicket = find.byKey(const Key("contact-add_ticket-button"));
    Finder textTicketEmpty = find.byKey(const Key("contact-tickets-empty"));

    expect(errorAlertDialog, findsOneWidget);

    await tester.tap(errorAlertDialog);
    await tester.pumpAndSettle();

    expect(errorAlertDialog, findsNothing);

    expect(buttonAddTicket, findsOneWidget);
    expect(textTicketEmpty, findsOneWidget);

    await tester.tap(buttonAddTicket);
    await tester.pumpAndSettle();
  });
}
