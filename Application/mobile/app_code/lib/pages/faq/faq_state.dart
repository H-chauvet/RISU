import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/utils/providers/theme.dart';

import 'faq_page.dart';
import 'answer_page.dart';

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
          'title_es': '¿Cómo unirse al equipo?',
          'content_fr':
              'Pour rejoindre l\'équipe, il suffit de nous contacter via le formulaire de contact.',
          'content_en':
              'To join the team, you just have to contact us via the contact form.',
          'content_es':
              'Para unirse al equipo, solo tienes que contactarnos a través del formulario de contacto.'
        },
        {
          'title_fr': 'Trouver l\'article idéal',
          'title_en': 'Find the perfect article',
          'title_es': 'Encuentra el artículo perfecto',
          'content_fr':
              'Pour trouver l\'article idéal, il suffit de parcourir les articles dans nos différents conteneurs. Utilisez les filtres pour affiner votre recherche. Ajoutez les articles en favoris pour les retrouver plus facilement.',
          'content_en':
              'To find the perfect article, just browse the articles in our different containers. Use the filters to refine your search. Add articles to your favorites to find them more easily.',
          'content_es':
              'Para encontrar el artículo perfecto, solo tienes que explorar los artículos en nuestros diferentes contenedores. Usa los filtros para refinar tu búsqueda. Agrega los artículos a tus favoritos para encontrarlos más fácilmente.'
        },
        {
          'title_fr': 'Comment configurer votre compte ?',
          'title_en': 'How to set up your account ?',
          'title_es': '¿Cómo configurar tu cuenta?',
          'content_fr':
              'Pour configurer votre compte, il suffit de vous rendre dans le menu burger en haut à droite, puis appuyez sur "détails du profil" ou bien, allez dans "Profil", puis "Paaramètres", puis "Voir les détails du profil". Vous pourrez y modifier vos informations personnelles, vos préférences de notifications, votre thème de l\'application et votre langue.',
          'content_en':
              'To set up your account, just go to the burger menu at the top right, then press "profile details" or, go to "Profile", then "Settings", then "View profile details". You can modify your personal information, your notification preferences, your application theme and your language.',
          'content_es':
              'Para configurar tu cuenta, solo ve al menú de hamburguesa en la parte superior derecha, luego presiona "detalles del perfil" o, ve a "Perfil", luego "Configuración", y después "Ver detalles del perfil". Podrás modificar tu información personal, tus preferencias de notificaciones, el tema de la aplicación y tu idioma.'
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentLocale = Localizations.localeOf(context);

    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        textTitle: AppLocalizations.of(context)!.faq,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text(
                    key: const Key('faq-title-text'),
                    userInformation?.firstName != null &&
                            userInformation!.firstName!.isNotEmpty
                        ? AppLocalizations.of(context)!
                            .faqTitle(userInformation?.firstName ?? '')
                        : AppLocalizations.of(context)!.faqTitleOffline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ...questions.map((question) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AnswerPage(
                              question: question,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Row(
                            key: Key('faq-question-${question['title_fr']}'),
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.help_outline, size: 24.0),
                              const SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  question[
                                      'title_${currentLocale.languageCode}'],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Icon(Icons.chevron_right, size: 24.0),
                            ],
                          ),
                          const Divider(
                            thickness: 1.5,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 50),
                  Text(
                    key: const Key('need-to-join-us-text'),
                    AppLocalizations.of(context)!.needToJoinUs,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: themeProvider.currentTheme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    key: const Key('some-questions-faq-text'),
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
                      key: const Key('contact-us-button-text'),
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
