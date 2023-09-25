import 'package:flutter/material.dart';

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
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      backgroundColor: theme!.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: theme!.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme!.bottomNavigationBarTheme.unselectedItemColor,
    );
  }
}
