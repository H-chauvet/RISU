import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/faq/answer_page.dart';
import 'package:risu/pages/faq/faq_page.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  List<dynamic> questions = [
    {
      'title_fr': 'Comment rejoindre l\'équipe ?',
      'title_en': 'How to join the team ?',
      'content_fr':
          'Pour rejoindre l\'équipe, il suffit de nous contacter via le formulaire de contact.',
      'content_en':
          'To join the team, you just have to contact us via the contact form.'
    }
  ];

  testWidgets('Faq Page, find elements', (WidgetTester tester) async {
    userInformation = initExampleUser();
    final testPage = initPage(FaqPage(
      questions: questions,
    ));
    await waitForLoader(tester: tester, testPage: testPage);

    Finder faqTitleText = find.byKey(const Key("faq-title-text"));
    expect(faqTitleText, findsOneWidget);

    Finder someQuestionsFaText =
        find.byKey(const Key("some-questions-faq-text"));
    expect(someQuestionsFaText, findsOneWidget);

    Finder needToJoinUsButton = find.byKey(const Key("need-to-join-us-text"));
    expect(needToJoinUsButton, findsOneWidget);

    Finder contactUsButton = find.byKey(const Key("contact-us-button-text"));
    expect(contactUsButton, findsOneWidget);
    await tester.tap(contactUsButton);
    await tester.pumpAndSettle();
  });
}
