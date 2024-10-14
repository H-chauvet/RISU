import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// CustomBottomNavigationBar
///
/// Customization of the navigation bar
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  /// [Widget] : build the Footer Component
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              context.go("/");
            },
            child: Text(
              AppLocalizations.of(context)!.home,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.secondaryHeaderColor
                    : lightTheme.secondaryHeaderColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: () {
              context.go("/confidentiality");
            },
            child: Text(
              AppLocalizations.of(context)!.confidentalityPolicy,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.secondaryHeaderColor
                    : lightTheme.secondaryHeaderColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: () {
              context.go("/contact");
            },
            child: Text(
              AppLocalizations.of(context)!.contact,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.secondaryHeaderColor
                    : lightTheme.secondaryHeaderColor,
              ),
            ),
          ),
          const SizedBox(width: 20),
          TextButton(
            onPressed: () async {
              if (await storageService.readStorage('token') == '') {
                context.go("/login");
              } else {
                context.go("/feedbacks");
              }
            },
            child: Text(
              AppLocalizations.of(context)!.opinion,
              style: TextStyle(
                fontSize: 16,
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.secondaryHeaderColor
                    : lightTheme.secondaryHeaderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
