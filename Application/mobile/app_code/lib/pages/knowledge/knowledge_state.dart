import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/outlined_button.dart';

import 'dart:math';

import '../../utils/theme.dart';
import 'knowledge_page.dart';

class KnowledgePageState extends State<KnowledgePage> {
  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.black,
    Colors.white,
    Colors.amber,
    Colors.deepOrange,
    Colors.pink
  ];
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: _colors[_index % _colors.length],
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MyOutlinedButton(
            text: 'Changer la couleur',
            onPressed: () {
              setState(() {
                _index = Random().nextInt(_colors.length);
              });
            },
          ),
          const SizedBox(height: 16),
          MyOutlinedButton(
            text: 'Contacter l\'API',
            onPressed: () {
              setState(() {
                // TO DO
              });
            },
          )
        ],
      )),
    );
  }
}
