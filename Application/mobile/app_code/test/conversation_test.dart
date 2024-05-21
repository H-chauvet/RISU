import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/conversation_page.dart';

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
    final testPage =
        initPage(ConversationPage(tickets: ticketList, isOpen: true));
    await waitForLoader(tester: tester, testPage: testPage);

    Finder titleFinder = find.byKey(const Key('appbar-text_title'));
    expect(titleFinder, findsOneWidget);

    Finder buttonSendMessage =
        find.byKey(const Key('chat-button-send-message'));
    expect(buttonSendMessage, findsOneWidget);

    await tester.tap(buttonSendMessage);
    await tester.pumpAndSettle();
  });

  testWidgets('Conversation page open and sendticket',
      (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage =
        initPage(ConversationPage(tickets: ticketList, isOpen: true));
    await waitForLoader(tester: tester, testPage: testPage);

    Finder titleFinder = find.byKey(const Key('appbar-text_title'));
    expect(titleFinder, findsOneWidget);

    Finder fieldMessage =
        find.byKey(const Key("conversation-text_field-message"));
    expect(fieldMessage, findsOneWidget);

    Finder buttonSendMessage =
        find.byKey(const Key('chat-button-send-message'));
    expect(buttonSendMessage, findsOneWidget);

    await tester.enterText(fieldMessage, "Test Message");
    await tester.pumpAndSettle();

    await tester.tap(buttonSendMessage);
    await tester.pumpAndSettle();
  });

  testWidgets('Conversation page close ticket', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage =
        initPage(ConversationPage(tickets: ticketList, isOpen: false));
    await waitForLoader(tester: tester, testPage: testPage);

    Finder buttonSendMessage =
        find.byKey(const Key('chat-button-send-message'));
    expect(buttonSendMessage, findsNothing);
  });
}
