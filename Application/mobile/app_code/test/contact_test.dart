import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/contact/contact_state.dart';

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

  var ticket1 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Sylvie',
    'creatorId': "User",
    'assignedId': "",
  };
  sleep(const Duration(seconds: 1));
  var ticket3 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Titouan',
    'creatorId': "User",
    'assignedId': "",
  };
  sleep(const Duration(seconds: 1));
  var ticket2 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Rocket League',
    'creatorId': "User",
    'assignedId': "",
  };

  List<dynamic> ticketList = [ticket1, ticket2, ticket3];
  Map<String, List<dynamic>> mapTickets = {
    '1': ticketList,
  };

  testWidgets('ContactPage create ticket', (WidgetTester tester) async {
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

  testWidgets('ContactPage open / close', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage = initPage(const ContactPage());
    await waitForLoader(tester: tester, testPage: testPage);

    Finder errorAlertDialog = find.byKey(const Key("alertdialog-button_ok"));
    expect(errorAlertDialog, findsOneWidget);

    await tester.tap(errorAlertDialog);
    await tester.pumpAndSettle();
    expect(errorAlertDialog, findsNothing);

    Finder inkWellOpenTickets =
        find.byKey(const Key('contact-ink-well-show-open'));
    Finder inkWellCloseTickets =
        find.byKey(const Key('contact-ink-well-show-close'));

    expect(inkWellOpenTickets, findsOneWidget);
    expect(inkWellCloseTickets, findsOneWidget);

    await tester.tap(inkWellCloseTickets);
    await tester.pumpAndSettle();

    await tester.tap(inkWellOpenTickets);
    await tester.pumpAndSettle();
  });

  testWidgets('ContactPage basics interaction', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage = initPage(const ContactPage(), appTheme: 'Sombre');

    await waitForLoader(tester: tester, testPage: testPage);

    Finder errorAlertDialog = find.byKey(const Key("alertdialog-button_ok"));
    expect(errorAlertDialog, findsOneWidget);

    await tester.tap(errorAlertDialog);
    await tester.pumpAndSettle();

    expect(errorAlertDialog, findsNothing);
    Finder inkWellOpenTickets =
        find.byKey(const Key('contact-ink-well-show-open'));
    Finder inkWellCloseTickets =
        find.byKey(const Key('contact-ink-well-show-close'));

    expect(inkWellOpenTickets, findsOneWidget);
    expect(inkWellCloseTickets, findsOneWidget);

    await tester.tap(inkWellCloseTickets);
    await tester.pumpAndSettle();

    await tester.tap(inkWellOpenTickets);
    await tester.pumpAndSettle();
  });

  test('Testing sort tickets', () {
    final test = ContactPageState();

    test.sortTickets(mapTickets);
    expect(mapTickets["1"], [ticket1, ticket3, ticket2]);
  });

  testWidgets('ContactPage mock open tickets', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage =
        initPage(ContactPage(testTickets: mapTickets), appTheme: 'Sombre');

    await waitForLoader(tester: tester, testPage: testPage);

    Finder errorAlertDialog = find.byKey(const Key("alertdialog-button_ok"));
    expect(errorAlertDialog, findsNothing);

    Finder inkWellOpenTickets =
        find.byKey(const Key('contact-ink-well-show-open'));
    Finder inkWellCloseTickets =
        find.byKey(const Key('contact-ink-well-show-close'));

    expect(inkWellOpenTickets, findsOneWidget);
    expect(inkWellCloseTickets, findsOneWidget);

    await tester.tap(inkWellCloseTickets);
    await tester.pumpAndSettle();

    await tester.tap(inkWellOpenTickets);
    await tester.pumpAndSettle();

    Finder goToChat = find.byKey(const Key('contact-gesture-go-to-chat'));

    expect(goToChat, findsOneWidget);

    await tester.tap(goToChat);
    await tester.pumpAndSettle();
  });

  testWidgets('ContactPage mock close tickets', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage =
        initPage(ContactPage(testTickets: mapTickets), appTheme: 'Sombre');

    await waitForLoader(tester: tester, testPage: testPage);

    Finder errorAlertDialog = find.byKey(const Key("alertdialog-button_ok"));
    expect(errorAlertDialog, findsNothing);

    Finder inkWellOpenTickets =
        find.byKey(const Key('contact-ink-well-show-open'));
    Finder inkWellCloseTickets =
        find.byKey(const Key('contact-ink-well-show-close'));

    expect(inkWellOpenTickets, findsOneWidget);
    expect(inkWellCloseTickets, findsOneWidget);

    await tester.tap(inkWellCloseTickets);
    await tester.pumpAndSettle();

    Finder goToChat = find.byKey(const Key('contact-gesture-go-to-chat'));

    expect(goToChat, findsOneWidget);

    await tester.tap(goToChat);
    await tester.pumpAndSettle();
  });
}
