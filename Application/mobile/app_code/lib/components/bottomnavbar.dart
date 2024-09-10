import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:risu/globals.dart';

/// The bottom navigation bar that appears at the bottom of the screen.
/// It contains three icons: search, map and profile.
/// params:
/// [currentIndex] - the index of the current selected item.
/// [onTap] - the function that is called when an item is tapped.
/// [theme] - the theme of the app.
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ThemeData? theme;

  const BottomNavBar({
    super.key,
    this.theme,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    BottomNavigationBarItem item = BottomNavigationBarItem(
      icon: const Icon(Icons.person),
      label: AppLocalizations.of(context)!.profile,
    );
    if (userInformation == null) {
      item = BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: AppLocalizations.of(context)!.settings,
      );
    }
    return BottomNavigationBar(
      key: key,
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: AppLocalizations.of(context)!.search,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.map),
          label: AppLocalizations.of(context)!.map,
        ),
        item,
      ],
      backgroundColor: theme!.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: theme!.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme!.bottomNavigationBarTheme.unselectedItemColor,
      unselectedIconTheme: const IconThemeData(size: 28),
      selectedIconTheme: const IconThemeData(size: 28),
      unselectedFontSize: 14,
      selectedFontSize: 14,
      type: BottomNavigationBarType.fixed,
    );
  }
}
