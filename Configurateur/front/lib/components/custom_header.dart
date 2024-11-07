// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/language_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

/// [StatefulWidget] : LandingAppBar
///
/// Header for the web pages
class LandingAppBar extends StatefulWidget {
  const LandingAppBar({super.key, required BuildContext context});

  @override
  State<LandingAppBar> createState() => LandingAppBarState();
}

/// LandingAppBarState
///
class LandingAppBarState extends State<LandingAppBar> {
  String? token = '';
  String? userRole = '';
  String currentLanguage = language;

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserRole().then((value) => userRole = value);
    setState(() {});
  }

  /// [Function] : Check in storage service is the token is available
  /// Change the path of page if you are connected or not
  void goToCreation() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      await storageService.removeStorage('containerData');
      context.go("/container-creation/shape");
    }
  }

  void goToCompany() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/company");
    }
  }

  void goToFeedbacks() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/feedbacks");
    }
  }

  /// [Function] : Download the mobile application from the website
  void downloadApk() async {
    try {
      final response =
          await http.get(Uri.parse('http://$serverIp:3000/api/apk/download'));

      if (response.statusCode == 200) {
        final Uri url = Uri.parse('http://$serverIp:3000/api/apk/download');
        if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
        } else {
          showCustomToast(
            context,
            AppLocalizations.of(context)!.applicationDownloaded,
            true,
          );
        }
      } else {
        showCustomToast(context, response.body, false);
      }
    } catch (e) {
      showCustomToast(context, e.toString(), false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : Build the widget
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isNarrowScreen = constraints.maxWidth < 1480;

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logonew.png',
                    width: 100,
                    height: 100,
                  ),
                  isNarrowScreen
                      ? PopupMenuButton<String>(
                          icon: Icon(
                            Icons.menu,
                            color: Provider.of<ThemeService>(context,
                                        listen: false)
                                    .isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
                          onSelected: (value) {
                            _handleMenuSelection(value, context);
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'home',
                              child: ListTile(
                                leading: Icon(
                                  Icons.home,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.home,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'team',
                              child: ListTile(
                                leading: Icon(
                                  Icons.group,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.ourTeam,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'create',
                              child: ListTile(
                                leading: Icon(
                                  Icons.create_new_folder,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.containerCreate,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'download',
                              child: ListTile(
                                leading: Icon(
                                  Icons.download,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!
                                      .downloadApplication,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'feedback',
                              child: ListTile(
                                leading: Icon(
                                  Icons.feedback,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.giveFeedback,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: "connexion",
                              child: ListTile(
                                leading: Icon(
                                  Icons.login,
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                ),
                                title: Text(
                                  AppLocalizations.of(context)!.logIn,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context,
                                                listen: false)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                              value: "inscription",
                              child: ListTile(
                                leading: Icon(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  Icons.add,
                                ),
                                title:
                                    Text(AppLocalizations.of(context)!.register,
                                        style: TextStyle(
                                          color: Provider.of<ThemeService>(
                                                      context,
                                                      listen: false)
                                                  .isDark
                                              ? darkTheme.primaryColor
                                              : lightTheme.primaryColor,
                                        )),
                              ),
                            ),
                          ],
                        )
                      : Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildMenuItems(context),
                          ),
                        ),
                  if (!isNarrowScreen) _buildLanguageAndProfile(context),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 100, right: 100),
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 50),
          ],
        );
      },
    );
  }

  void _handleMenuSelection(String value, BuildContext context) {
    switch (value) {
      case 'home':
        context.go("/");
        break;
      case 'team':
        goToCompany();
        break;
      case 'create':
        goToCreation();
        break;
      case 'download':
        downloadApk();
        break;
      case 'feedback':
        goToFeedbacks();
        break;
      case 'connexion':
        context.go("/login");
        break;
      case 'inscription':
        context.go("/register");
        break;
    }
  }

  List<Widget> _buildMenuItems(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          context.go("/");
        },
        style: TextButton.styleFrom(
          foregroundColor: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.home,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          thickness: 2,
          color: Color.fromARGB(255, 172, 167, 167),
        ),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () => goToCompany(),
        style: TextButton.styleFrom(
          foregroundColor: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.ourTeam,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          thickness: 2,
          color: Color.fromARGB(255, 172, 167, 167),
        ),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () => goToCreation(),
        style: TextButton.styleFrom(
          foregroundColor: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.containerCreate,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          thickness: 2,
          color: Color.fromARGB(255, 172, 167, 167),
        ),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () => downloadApk(),
        style: TextButton.styleFrom(
          foregroundColor: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.downloadApplication,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          thickness: 2,
          color: Color.fromARGB(255, 172, 167, 167),
        ),
      ),
      const SizedBox(width: 10),
      TextButton(
        onPressed: () => goToFeedbacks(),
        style: TextButton.styleFrom(
          foregroundColor: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          AppLocalizations.of(context)!.giveFeedback,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
          ),
        ),
      ),
      const SizedBox(width: 10),
      const SizedBox(
        height: 24,
        child: VerticalDivider(
          thickness: 2,
          color: Color.fromARGB(255, 172, 167, 167),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        AppLocalizations.of(context)!.darkTheme,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: Provider.of<ThemeService>(context).isDark
              ? darkTheme.secondaryHeaderColor
              : lightTheme.secondaryHeaderColor,
        ),
      ),
      Switch(
        value: Provider.of<ThemeService>(context).isDark,
        onChanged: (bool value) {
          Provider.of<ThemeService>(context, listen: false).switchTheme();
          setState(() {});
        },
        activeColor: darkTheme.primaryColor,
        inactiveTrackColor: lightTheme.primaryColor,
      ),
    ];
  }

  Widget _buildLanguageAndProfile(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<String>(
          tooltip: AppLocalizations.of(context)!.language,
          icon: CountryFlag.fromLanguageCode(
            language,
            height: 16,
            width: 32,
          ),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'fr',
                child: Row(
                  children: [
                    CountryFlag.fromLanguageCode(
                      'fr',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 16),
                    Text(AppLocalizations.of(context)!.french),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    CountryFlag.fromLanguageCode(
                      'en',
                      height: 32,
                      width: 32,
                    ),
                    const SizedBox(width: 16),
                    Text(AppLocalizations.of(context)!.english),
                  ],
                ),
              ),
            ];
          },
          onSelected: (String value) {
            setState(() {
              currentLanguage = value;
            });
            Provider.of<LanguageService>(context, listen: false)
                .changeLanguage(Locale(value));
          },
        ),
        const SizedBox(width: 32),
        PopupMenuButton<String>(
          tooltip: token != ''
              ? AppLocalizations.of(context)!.profile
              : AppLocalizations.of(context)!.authentification,
          icon: Icon(
            size: 28,
            Icons.account_circle,
            color: Provider.of<ThemeService>(context, listen: false).isDark
                ? darkTheme.primaryColor
                : lightTheme.primaryColor,
          ),
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<String>> items = [];
            if (token == '') {
              items.addAll(
                [
                  PopupMenuItem(
                    value: "connexion",
                    child: ListTile(
                      leading: Icon(
                        Icons.login,
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.logIn,
                        style: TextStyle(
                          color:
                              Provider.of<ThemeService>(context, listen: false)
                                      .isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: "inscription",
                    child: ListTile(
                      leading: Icon(
                        Icons.login,
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.register,
                        style: TextStyle(
                          color:
                              Provider.of<ThemeService>(context, listen: false)
                                      .isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              items.add(
                PopupMenuItem<String>(
                  value: 'profil',
                  child: ListTile(
                    leading: Icon(
                      Icons.account_box,
                      color: Provider.of<ThemeService>(context, listen: false)
                              .isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.profile,
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
              items.add(
                PopupMenuItem<String>(
                  value: 'company-profil',
                  child: ListTile(
                    leading: Icon(
                      Icons.business,
                      color: Provider.of<ThemeService>(context, listen: false)
                              .isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.companyMy,
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
              items.add(
                PopupMenuItem<String>(
                  value: 'my-save',
                  child: ListTile(
                    leading: Icon(
                      Icons.save,
                      color: Provider.of<ThemeService>(context, listen: false)
                              .isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                    ),
                    title: Text(
                      'Mes sauvegardes',
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              );
              if (userRole == "admin") {
                items.add(
                  PopupMenuItem<String>(
                    value: 'admin',
                    child: ListTile(
                      leading: Icon(
                        Icons.admin_panel_settings,
                        color: Provider.of<ThemeService>(context, listen: false)
                                .isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                      title: Text(
                        AppLocalizations.of(context)!.administration,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(
                            context,
                            listen: false,
                          ).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                );
              }
              items.add(
                PopupMenuItem<String>(
                  value: 'disconnect',
                  child: ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.logOff,
                      style: const TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              );
            }
            return items;
          },
          onSelected: (String value) {
            if (value == 'connexion') {
              context.go("/login");
            } else if (value == 'inscription') {
              context.go("/register");
            } else if (value == 'admin') {
              context.go("/admin");
            } else if (value == 'profil') {
              context.go("/profil");
            } else if (value == 'company-profil') {
              context.go("/company-profil");
            } else if (value == 'my-save') {
              context.go("/my-container");
            } else if (value == "disconnect") {
              setState(() {
                storageService.removeStorage('token');
                storageService.removeStorage('tokenExpiration');
                token = '';
                showCustomToast(
                  context,
                  AppLocalizations.of(context)!.loggedOff,
                  true,
                );
                context.go("/");
              });
            }
          },
        ),
      ],
    );
  }
}
