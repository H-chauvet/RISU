import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeModalContent extends StatelessWidget {
  const LanguageChangeModalContent({super.key});

  Future<String> getCurrentLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> items = ['fr', 'en'];
    final currentLanguage = prefs.getString('language') ?? defaultLanguage;
    return items[items.indexOf(currentLanguage)];
  }

  void changeLanguage(BuildContext context, String languageCode) {
    Provider.of<LanguageProvider>(context, listen: false)
        .changeLanguage(Locale(languageCode));
  }

  Widget displayLanguage(
      BuildContext context, String languageCode, String languageName) {
    return RadioListTile<String>(
      key: Key('language_modal-radio_button_$languageCode'),
      title: Row(
        children: [
          CountryFlag.fromLanguageCode(
            languageCode,
            width: 32,
            height: 32,
          ),
          const SizedBox(width: 8),
          Text(languageName),
        ],
      ),
      value: languageCode,
      groupValue:
          Provider.of<LanguageProvider>(context).currentLocale.languageCode,
      onChanged: (value) async {
        if (value != null &&
            value !=
                Provider.of<LanguageProvider>(context, listen: false)
                    .currentLocale
                    .languageCode) {
          changeLanguage(context, value);
          await Future.delayed(const Duration(milliseconds: 80));
          if (context.mounted) {
            MyToastMessage.show(
              context: context,
              message:
                  AppLocalizations.of(context)!.languageChangedTo(languageName),
            );
          }
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder<String>(
          future: getCurrentLanguage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  displayLanguage(context, 'fr', 'Français'),
                  displayLanguage(context, 'en', 'English'),
                ],
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
