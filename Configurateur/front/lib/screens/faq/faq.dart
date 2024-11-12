import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// FaqPage
///
/// Faq page for the web application
class FaqPage extends StatefulWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  State<FaqPage> createState() => FaqPageState();
}

/// FaqPageState
///
class FaqPageState extends State<FaqPage> {
  int? openedQuestionIndex;

  @override
  void initState() {
    super.initState();
  }

  /// [faqData] représente les différentes informations affiché dans la page FAQ
  /// question: Questions souvent posé et permet de faciliter la prise en main de l'application
  /// answer: Réponse à la question posé au dessus
  /// linkText: Affiche un texte cliquable permettant d'aller à la page concerné
  /// page: nom de la page vers laquelle le linkText redirige l'utilisateur
  List<Map<String, String>> getFaqData(BuildContext context) {
    return [
      {
        "question": AppLocalizations.of(context)!.accountQuestion,
        "answer": AppLocalizations.of(context)!.accountAnswer,
        "linkText": AppLocalizations.of(context)!.accountLinkText,
        "page": AppLocalizations.of(context)!.accountPage,
      },
      {
        "question": AppLocalizations.of(context)!.passwordQuestion,
        "answer": AppLocalizations.of(context)!.passwordAnswer,
        "linkText": AppLocalizations.of(context)!.passwordLinkText,
        "page": AppLocalizations.of(context)!.passwordPage,
      },
      {
        "question": AppLocalizations.of(context)!.supportQuestion,
        "answer": AppLocalizations.of(context)!.supportAnswer,
        "linkText": AppLocalizations.of(context)!.supportLinkText,
        "page": AppLocalizations.of(context)!.supportPage,
      },
      {
        "question": AppLocalizations.of(context)!.containerQuestion,
        "answer": AppLocalizations.of(context)!.containerAnswer,
        "linkText": AppLocalizations.of(context)!.containerLinkText,
        "page": AppLocalizations.of(context)!.containerPage,
      },
    ];
  }

  /// [Function] : Build the landing page
  @override
  Widget build(BuildContext context) {
    final faqData = getFaqData(context);
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
        flex: 8,
        footer: Footer(
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/Help.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(width: 30.0),
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FAQ',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                ),
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                AppLocalizations.of(context)!.faqText,
                                // '',
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? Colors.white
                                          : lightTheme.primaryColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                AppLocalizations.of(context)!.faqTextFindAnswer,
                                style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? Colors.white
                                          : lightTheme.primaryColor,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    ...faqData.asMap().entries.map(
                      (entry) {
                        int index = entry.key + 1;
                        Map<String, String> faq = entry.value;

                        return FaqItem(
                          question: faq["question"]!,
                          answer: faq["answer"]!,
                          linkText: faq["linkText"]!,
                          page: faq["page"]!,
                          isOpen: openedQuestionIndex == index,
                          questionNumber: index,
                          onToggle: () {
                            setState(
                              () {
                                openedQuestionIndex =
                                    openedQuestionIndex == index ? null : index;
                              },
                            );
                          },
                        );
                      },
                    ).toList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final String linkText;
  final String page;
  final bool isOpen;
  final int questionNumber;
  final VoidCallback onToggle;

  const FaqItem({
    Key? key,
    required this.question,
    required this.answer,
    required this.linkText,
    required this.page,
    required this.isOpen,
    required this.questionNumber,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  child: Text(
                    '$questionNumber',
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.appBarTheme.backgroundColor
                          : lightTheme.appBarTheme.backgroundColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      question,
                      style: TextStyle(
                        fontSize: 18,
                        color: Provider.of<ThemeService>(context).isDark
                            ? Colors.white
                            : lightTheme.primaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                isOpen
                    ? const Icon(Icons.arrow_drop_up)
                    : const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    answer,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8.0),
                  RichText(
                    text: TextSpan(
                      text: linkText,
                      style: TextStyle(
                        fontSize: 16,
                        color: Provider.of<ThemeService>(context).isDark
                            ? Colors.blue.shade300
                            : Colors.blue.shade700,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          context.go(page);
                        },
                    ),
                  ),
                ],
              ),
            ),
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
