import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/components/burger_drawer.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/details_page.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/pages/container/container_page.dart';
import 'package:risu/pages/map/map_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:uni_links/uni_links.dart';

import '../profile/informations/informations_page.dart';
import 'home_page.dart';

/// HomePageState
/// This class is the state of the HomePage class
/// It contains the logic of the HomePage class
class HomePageState extends State<HomePage> {
  late StreamSubscription _sub;
  int _currentIndex = 1;
  late List<Widget> _pages;
  bool didAskForProfile = false;
  int? containerId;

  @override
  void initState() {
    super.initState();
    _handleUri();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!didAskForProfile) {
        configProfile(context);
      }
    });
    _pages = [
      ContainerPage(
        onDirectionClicked: (id) {
          setState(() {
            _currentIndex = 1;
            containerId = id;
          });
        },
      ),
      const MapPage(),
      const ProfilePage(),
    ];
  }

  void redirectFromUri(Uri uri, String link) {
    if (link.contains('signup')) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SignupPage(),
        ),
      );
    }
    if (link.contains('article')) {
      final articleId = uri.queryParameters["id"]!;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleDetailsPage(
            articleId: int.parse(articleId),
          ),
        ),
      );
    }
    if (link.contains('container')) {
      final containerId = uri.queryParameters["id"]!;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArticleListPage(
            containerId: int.parse(containerId),
          ),
        ),
      );
    }
  }

  void _handleUri() async {
    final Uri? uri = await getInitialUri();
    if (uri != null) {
      final link = uri.toString();
      redirectFromUri(uri, link);
    }

    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        final link = uri.toString();
        redirectFromUri(uri, link);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  /// configProfile
  /// This function checks if the user has completed his profile
  /// If not, it will ask the user to complete it
  /// params:
  /// [context] - the BuildContext
  void configProfile(BuildContext context) async {
    try {
      String? firstName = userInformation?.firstName;
      String? lastName = userInformation?.lastName;
      if (userInformation?.email != null &&
          (firstName == null || lastName == null)) {
        await MyAlertDialog.showChoiceAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.profileIncomplete,
          message: AppLocalizations.of(context)!.profileAskCompletion,
          onOkName: AppLocalizations.of(context)!.profileGoComplete,
          onCancelName: AppLocalizations.of(context)!.cancel,
        ).then(
          (value) => {
            if (value)
              {
                setState(() {
                  _currentIndex = 2;
                }),
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const ProfileInformationsPage();
                    },
                  ),
                ).then(
                  (value) {
                    if (value != null && value == true) {
                      setState(() {
                        userInformation = userInformation;
                      });
                    }
                  },
                ),
              }
          },
        );
      }
      setState(() {
        didAskForProfile = true;
      });
    } catch (err, stacktrace) {
      if (context.mounted) {
        printCatchError(context, err, stacktrace,
            message: AppLocalizations.of(context)!
                .errorOccurredDuringSettingProfile);
        return;
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (containerId != null) {
      _pages[1] = MapPage(
        containerId: containerId,
      );
    }
    return WillPopScope(
      onWillPop: () {
        return Future<bool>.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: MyAppBar(
          curveColor: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor),
          showBackButton: false,
        ),
        endDrawer: const BurgerDrawer(),
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavBar(
          theme: context.select(
              (ThemeProvider themeProvider) => themeProvider.currentTheme),
          currentIndex: _currentIndex,
          onTap: (index) async {
            setState(() {
              if (index == 2 && userInformation == null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const SettingsPage();
                  }),
                );
              } else {
                _currentIndex = index;
              }
            });
          },
        ),
      ),
    );
  }
}
