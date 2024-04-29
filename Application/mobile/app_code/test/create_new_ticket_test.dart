import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/new_ticket_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  var ticket1 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Sylvie',
    'creatorId': "PasUser",
    'assignedId': "User",
  };
  sleep(const Duration(seconds: 1));
  var ticket3 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Titouan',
    'creatorId': "User",
    'assignedId': "PasUser",
  };
  sleep(const Duration(seconds: 1));
  var ticket2 = {
    'createdAt': DateTime.now().toString(),
    'chatUid': '1',
    'title': 'Le titre mémoire',
    'content': 'Rocket League',
    'creatorId': "User",
    'assignedId': "PasUser",
  };

  List<dynamic> ticketList = [ticket1, ticket2, ticket3];
  Map<String, List<dynamic>> mapTickets = {
    '1': ticketList,
  };

  testWidgets('Conversation page open ticket', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage = initPage(const NewTicketPage());
    await waitForLoader(tester: tester, testPage: testPage);

    Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));
    expect(appBarTitleData, findsOneWidget);

    Finder textInputObject =
        find.byKey(const Key('new-ticket-text_input-input-title'));
    expect(textInputObject, findsOneWidget);
    await tester.enterText(textInputObject, "Je suis l'objet");

    Finder textInputContent =
        find.byKey(const Key('new-ticket-text_input-input_message'));
    expect(textInputContent, findsOneWidget);
    await tester.enterText(textInputContent, "Je suis le contenu");
    await tester.pumpAndSettle();

    Finder buttonNewTicket =
        find.byKey(const Key('new-ticket-button-send_message'));
    expect(buttonNewTicket, findsOneWidget);

    await tester.dragUntilVisible(
        buttonNewTicket, // what you want to find
        textInputContent, // widget you want to scroll
        const Offset(0, -300) // delta to move
        );

    await tester.tap(buttonNewTicket);
    await tester.pumpAndSettle();
  });
}
