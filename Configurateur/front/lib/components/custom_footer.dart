// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// [StatefulWidget] : CustomFooter
///
/// Footer for the web pages
class CustomFooter extends StatefulWidget {
  const CustomFooter({super.key});

  @override
  State<CustomFooter> createState() => CustomFooterState();
}

/// CustomFooterState
///
class CustomFooterState extends State<CustomFooter> {
  String? token = '';
  String? userMail = '';
  bool isHoveringContact = false;
  bool isHoveringFeedback = false;
  bool isHoveringFaq = false;
  bool isHoveringCompany = false;
  bool isHoveringContactUs = false;
  bool isHoveringProfil = false;
  bool isHoveringContainers = false;
  bool isHoveringCreateContainers = false;

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    token = await storageService.readStorage('token');
    storageService.getUserMail().then((value) => userMail = value);
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

  void goToTickets() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/contact");
    }
  }

  void goToProfile() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/profil");
    }
  }

  void goToCompanyProfile() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/company-profil");
    }
  }

  void goToCompany() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/company");
    }
  }

  void goToFaq() async {
    if (await storageService.readStorage('token') == '') {
      context.go("/login");
    } else {
      context.go("/faq");
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : build Footer Component
  @override
  Widget build(BuildContext context) {
    return Footer(
      backgroundColor: Provider.of<ThemeService>(context, listen: false).isDark
          ? lightTheme.primaryColor
          : darkTheme.primaryColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.community,
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context,
                                          listen: false)
                                      .isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringContact = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringContact = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToTickets(),
                              child: Text(
                                AppLocalizations.of(context)!.contactUs,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringContact
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringFaq = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringFaq = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToFaq(),
                              child: Text(
                                AppLocalizations.of(context)!.questions,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringFaq
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringCompany = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringCompany = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToCompany(),
                              child: Text(
                                AppLocalizations.of(context)!.risuCompany,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringCompany
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 100),
                      Image.asset(
                        'assets/logo.png',
                        height: 100,
                      ),
                      const SizedBox(width: 100),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.accountMy,
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context,
                                          listen: false)
                                      .isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(height: 6),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringProfil = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringProfil = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToProfile(),
                              child: Text(
                                AppLocalizations.of(context)!.profileMy,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringProfil
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringContainers = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringContainers = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToCompanyProfile(),
                              child: Text(
                                AppLocalizations.of(context)!.containerMy,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringContainers
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                          MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                isHoveringCreateContainers = true;
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                isHoveringCreateContainers = false;
                              });
                            },
                            child: GestureDetector(
                              onTap: () => goToCreation(),
                              child: Text(
                                AppLocalizations.of(context)!.containerCreate,
                                style: TextStyle(
                                  color: Provider.of<ThemeService>(context,
                                              listen: false)
                                          .isDark
                                      ? darkTheme.primaryColor
                                      : lightTheme.primaryColor,
                                  decoration: isHoveringCreateContainers
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            AppLocalizations.of(context)!.copyright,
            style: TextStyle(
              color: Provider.of<ThemeService>(context, listen: false).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context)!.developedByRisu,
            style: TextStyle(
              color: Provider.of<ThemeService>(context, listen: false).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
              fontWeight: FontWeight.w300,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
