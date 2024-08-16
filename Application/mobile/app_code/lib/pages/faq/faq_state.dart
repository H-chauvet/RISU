import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/conversation_page.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/time.dart';

import 'faq_page.dart';

class FaqPageState extends State<FaqPage> {
  List<dynamic> questions = [];
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
    if (widget.questions.isEmpty) {
      getQuestions();
    } else {
      questions = widget.questions;
    }
  }

  void getQuestions() async {
    setState(() {
      questions = [
        {
          'title_fr': 'Comment rejoindre l\'équipe ?',
          'title_en': 'How to join the team ?',
          'content_fr':
              'Pour rejoindre l\'équipe, il suffit de nous contacter via le formulaire de contact.',
          'content_en':
              'To join the team, you just have to contact us via the contact form.'
        },
        {
          'title_fr': 'Trouver l\'article idéal',
          'title_en': 'Find the perfect article',
          'content_fr':
              'Pour trouver l\'article idéal, il suffit de parcourir les articles dans nos différents conteneurs. Utilisez les filtres pour affiner votre recherche. Ajoutez les articles en favoris pour les retrouver plus facilement.',
          'content_en':
              'To find the perfect article, just browse the articles in our different containers. Use the filters to refine your search. Add articles to your favorites to find them more easily.'
        },
        {
          'title_fr': 'Comment configurer votre compte ?',
          'title_en': 'How to set up your account ?',
          'content_fr':
              'Pour configurer votre compte, il suffit de vous rendre dans le menu burger en haut à droite, puis appuyez sur "détails du profil" ou bien, allez dans "Profil", puis "Paaramètres", puis "Voir les détails du profil". Vous pourrez y modifier vos informations personnelles, vos préférences de notifications, votre thème de l\'application et votre langue.',
          'content_en':
              'To set up your account, just go to the burger menu at the top right, then press "profile details" or, go to "Profile", then "Settings", then "View profile details". You can modify your personal information, your notification preferences, your application theme and your language.'
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.myTickets,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!
                        .faqTitle(userInformation!.firstName!),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.needToJoinUs,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.someQuestionsFaq,
                    style: TextStyle(
                      fontSize: 18,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FloatingActionButton.extended(
                    key: const Key('contact-us-button'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const ContactPage();
                          },
                        ),
                      ).then((value) => getQuestions());
                    },
                    backgroundColor:
                        themeProvider.currentTheme.secondaryHeaderColor,
                    label: Text(
                      AppLocalizations.of(context)!.contactUs,
                      style: TextStyle(
                          color: themeProvider.currentTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
