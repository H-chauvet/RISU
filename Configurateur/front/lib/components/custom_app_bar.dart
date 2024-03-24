import 'package:flutter/material.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

///
/// Custom rounded AppBar
///
/// @param title: title of the page
///
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  CustomAppBar(this.title, {Key? key, required BuildContext context})
      : preferredSize = Size.fromHeight(MediaQuery.of(context).size.height / 8),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 40,
          color: Provider.of<ThemeService>(context).isDark ? darkTheme.secondaryHeaderColor : lightTheme.secondaryHeaderColor
        ),
      ),
      centerTitle: true,
      leading: Container(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(1920, 56.0),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset("assets/logo.png"),
          iconSize: 80,
          onPressed: () {
            context.go('/');
          },
        ),
      ],
    );
  }
}
