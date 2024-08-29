import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/providers/theme.dart';

import 'answer_page.dart';

class AnswerPageState extends State<AnswerPage> {
  final LoaderManager _loaderManager = LoaderManager();
  dynamic question;
  dynamic translatedQuestion = {};

  AnswerPageState({required this.question});

  @override
  void initState() {
    super.initState();
    setState(() {
      question = widget.question;
    });
    Future.delayed(Duration.zero, () {
      final currentLocale = Localizations.localeOf(context);

      setState(() {
        translatedQuestion = {
          'title': question['title_${currentLocale.languageCode}'] ?? 'fr',
          'content': question['content_${currentLocale.languageCode}'] ?? 'fr',
        };
      });
    });
  }

  Widget buildAnswerContent(
      dynamic translatedQuestion, ThemeProvider themeProvider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            key: const Key('answer-title-text'),
            translatedQuestion['title'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeProvider.currentTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            key: const Key('answer-content-text'),
            translatedQuestion['content'] ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: themeProvider.currentTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.center,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    key: const Key('need-more-details-text'),
                    AppLocalizations.of(context)!.needMoreDetails,
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
                      );
                    },
                    backgroundColor:
                        themeProvider.currentTheme.secondaryHeaderColor,
                    label: Text(
                      AppLocalizations.of(context)!.contactUs,
                      style: TextStyle(
                        color: themeProvider.currentTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!
            .faqAnswer(translatedQuestion['title']),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: FutureBuilder(
        future: Future.delayed(Duration.zero, () {
          final currentLocale = Localizations.localeOf(context);
          return {
            'title': question['title_${currentLocale.languageCode}'],
            'content': question['content_${currentLocale.languageCode}'],
          };
        }),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            translatedQuestion = snapshot.data;
            return buildAnswerContent(translatedQuestion, themeProvider);
          }
        },
      ),
    );
  }
}
