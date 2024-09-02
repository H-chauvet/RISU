import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The bottom navigation bar that appears at the bottom of the screen
/// It contains three icons: search, map and profile
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
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.profile,
        ),
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
