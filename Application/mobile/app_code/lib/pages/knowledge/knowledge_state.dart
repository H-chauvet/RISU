import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risu/components/outlined_button.dart';

import 'dart:math';

import 'knowledge_page.dart';

class KnowledgePageState extends State<KnowledgePage> {
  final List<Color> _colors = [Colors.blue, Colors.red, Colors.green, Colors.yellow,
    Colors.black, Colors.white, Colors.amber, Colors.deepOrange, Colors.pink];
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _colors[_index % _colors.length],
      body : Center(
          child: MyOutlinedButton(
            text: 'Changer la couleur'
          , onPressed: () {
              setState(() {
                _index = Random().nextInt(_colors.length);
              });
          },)
        ),
    );
  }
}