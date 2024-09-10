import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'alert_dialog.dart';
import 'divider.dart';

enum DIVIDERPLACE {
  top,
  bottom,
}

/// This class is used to create a divider that redirects to another page.
/// It is used in the settings page.
/// params:
/// [title] - is the title of the divider.
/// [goToPage] - is the page where the user will be redirected.
/// [paramIcon] - is the icon of the divider.
/// [disconnect] - is a boolean that indicates if the user will be disconnected.
/// [chosenPlace] - is the place where the divider is placed.
class MyRedirectDivider extends StatelessWidget {
  final String title;
  final Widget goToPage;
  final IconData paramIcon;
  final bool disconnect;
  final DIVIDERPLACE chosenPlace;

  const MyRedirectDivider({
    super.key,
    required this.title,
    required this.goToPage,
    required this.paramIcon,
    this.disconnect = false,
    this.chosenPlace = DIVIDERPLACE.bottom,
  });

  /// This function is called when the user clicks on the divider.
  /// If the user is not connected, it will ask him to connect.
  /// params:
  /// [context] - is the context of the application.
  void onChanging(BuildContext context) {
    if (userInformation == null) {
      checkSignin(context);
      return;
    } else {
      if (disconnect) {
        MyAlertDialog.showChoiceAlertDialog(
          context: context,
          title: AppLocalizations.of(context)!.confirmation,
          message: AppLocalizations.of(context)!.accountAskDisconnection,
          onOkName: AppLocalizations.of(context)!.disconnect,
        ).then(
          (value) {
            if (value) {
              userInformation = null;
              final prefs = SharedPreferences.getInstance();
              prefs.then((value) {
                value.setString('refreshToken', '');
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return goToPage;
                  },
                ),
                (route) => false,
              );
            }
          },
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return goToPage;
            },
          ),
        );
      }
    }
  }

  /// This function is used to place a divider at the top or at the bottom of the
  /// widget.
  /// params:
  /// [currPlace] - is the place where the divider is placed.
  Widget placeDivider(DIVIDERPLACE currPlace) {
    if (chosenPlace == currPlace) {
      return const MyDivider();
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          onChanging(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            placeDivider(DIVIDERPLACE.top),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Icon(
                    paramIcon,
                    color: context.select((ThemeProvider themeProvider) =>
                        themeProvider.currentTheme.secondaryHeaderColor),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            placeDivider(DIVIDERPLACE.bottom),
          ],
        ),
      ),
    );
  }
}

/// This class is used to create a parameter that redirects to another page.
/// It is used in the settings page.
/// params:
/// [title] - is the title of the parameter.
/// [goToPage] - is the page where the user will be redirected.
/// [paramIcon] - is the icon of the parameter.
/// [locked] - is a boolean that indicates if the parameter is locked.
/// If it is locked, the user will not be able to click on it.
/// [correspondingIcon] is the icon that will be displayed on the right of the
/// parameter when it is locked.
class MyParameter extends StatelessWidget {
  final String title;
  final Widget goToPage;
  final IconData paramIcon;
  final bool locked;

  const MyParameter({
    super.key,
    required this.title,
    required this.goToPage,
    required this.paramIcon,
    this.locked = false,
  });

  /// This function is called when the user clicks on the parameter.
  Widget correspondingIcon() {
    if (locked) {
      return const Icon(Icons.lock);
    }
    return const Icon(Icons.chevron_right);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (locked) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return goToPage;
            },
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  paramIcon,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Expanded(child: SizedBox()),
              correspondingIcon()
            ],
          ),
          const MyDivider()
        ],
      ),
    );
  }
}

/// This class is used to create a parameter that opens a modal.
/// It is used in the settings page.
/// params:
/// [title] - is the title of the parameter.
/// [modalContent] - is the content of the modal.
/// [paramIcon] - is the icon of the parameter.
/// [locked] - is a boolean that indicates if the parameter is locked.
/// If it is locked, the user will not be able to click on it.
class MyParameterModal extends StatelessWidget {
  final String title;
  final Widget modalContent;
  final IconData paramIcon;
  final bool locked;

  const MyParameterModal({
    super.key,
    required this.title,
    required this.modalContent,
    required this.paramIcon,
    this.locked = false,
  });

  /// This function is called when the user clicks on the parameter.
  /// params:
  /// [context] - is the context of the application.
  Widget correspondingIcon(BuildContext context) {
    if (locked) {
      return Icon(
        Icons.lock,
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.primaryColor),
      );
    }
    return Icon(Icons.chevron_right,
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.primaryColor));
  }

  /// This function is called when the user clicks on the parameter.
  /// It opens a modal.
  /// params:
  /// [context] - is the context of the application.
  void _showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color: context.select((ThemeProvider themeProvider) =>
                  themeProvider.currentTheme.primaryColor),
            ),
          ),
          content: modalContent,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.close),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (locked) {
          return;
        }
        _showModal(context);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  paramIcon,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.primaryColor),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Expanded(child: SizedBox()),
              correspondingIcon(context),
            ],
          ),
          const MyDivider(),
        ],
      ),
    );
  }
}
