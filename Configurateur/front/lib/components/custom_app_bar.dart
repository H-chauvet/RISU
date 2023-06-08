import 'package:flutter/material.dart';
import 'package:front/main.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
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
        style: const TextStyle(fontSize: 40),
      ),
      centerTitle: true,
      backgroundColor: const Color(0xff4682B4),
      leading: Container(),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(1920, 56.0),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Image.asset("logo.png"),
          iconSize: 80,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'tile')));
          },
        ),
      ],
    );
  }
}
