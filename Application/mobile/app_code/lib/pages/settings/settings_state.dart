import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/settings/settings_pages/language/modal.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'settings_page.dart';

class SettingsPageState extends State<SettingsPage> {
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> apiDeleteAccount() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final userId = userInformation!.ID;
      final response = await http.delete(
        Uri.parse('$baseUrl/api/mobile/user/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        return true;
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'apiDeleteAccount',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringAccountDeletion);
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringAccountDeletion);
        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select(
          (ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor,
        ),
        showBackButton: true,
        showLogo: true,
        onBackButtonPressed: () {
          Navigator.pop(context, true);
        },
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.settings,
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: context.select((ThemeProvider themeProvider) =>
                            themeProvider.currentTheme.primaryColor),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.myAccount,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    MyParameter(
                      goToPage: const ProfileInformationsPage(),
                      title: AppLocalizations.of(context)!.seeProfileDetails,
                      paramIcon: const Icon(Icons.person),
                    ),
                    const SizedBox(height: 8),
                    MyParameter(
                      goToPage: const LoginPage(),
                      title: AppLocalizations.of(context)!.paymentMethods,
                      paramIcon: const Icon(Icons.payments_outlined),
                      locked: true,
                    ),
                    const SizedBox(height: 8),
                    MyParameter(
                      goToPage: const NotificationsPage(),
                      title: AppLocalizations.of(context)!.notifications,
                      paramIcon: const Icon(Icons.notifications),
                      locked: false,
                    ),
                    const SizedBox(height: 8),
                    MyParameterModal(
                      title: AppLocalizations.of(context)!.theme,
                      modalContent: const ThemeChangeModalContent(),
                      paramIcon: const Icon(Icons.brush),
                    ),
                    const SizedBox(height: 8),
                    MyParameterModal(
                      title: AppLocalizations.of(context)!.language,
                      modalContent: const LanguageChangeModalContent(),
                      paramIcon: const Icon(Icons.language),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLocalizations.of(context)!.other,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    MyParameter(
                      goToPage: const ContactPage(),
                      title: AppLocalizations.of(context)!.contactUs,
                      paramIcon: const Icon(Icons.message_outlined),
                    ),
                    const SizedBox(height: 8),
                    MyParameter(
                      goToPage: const LoginPage(),
                      title: AppLocalizations.of(context)!.aboutUs,
                      paramIcon: const Icon(Icons.question_mark),
                      locked: true,
                    ),
                    const SizedBox(
                        height: 16, key: Key('settings-sized_box-bottom')),
                    TextButton(
                      key: const Key('settings-textbutton_delete-account'),
                      onPressed: () {
                        MyAlertDialog.showChoiceAlertDialog(
                          context: context,
                          title: AppLocalizations.of(context)!.confirmation,
                          message:
                              AppLocalizations.of(context)!.accountAskDeletion,
                          onOkName: AppLocalizations.of(context)!.delete,
                        ).then(
                          (value) {
                            if (value) {
                              apiDeleteAccount().then(
                                (response) => {
                                  if (response)
                                    {
                                      MyAlertDialog.showInfoAlertDialog(
                                        context: context,
                                        title: AppLocalizations.of(context)!
                                            .accountDeleted,
                                        message: AppLocalizations.of(context)!
                                            .accountHasBeenDeleted,
                                      ).then(
                                        (x) {
                                          userInformation = null;
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const LoginPage();
                                              },
                                            ),
                                            (route) => false,
                                          );
                                        },
                                      )
                                    }
                                },
                              );
                            }
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.accountDelete,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
