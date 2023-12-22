import 'package:flutter/material.dart';

import 'divider.dart';

class MyParameter extends StatelessWidget {
  final String iconPath;
  final String title;
  final Widget goToPage;

  const MyParameter({
    super.key,
    required this.iconPath,
    required this.title,
    required this.goToPage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return goToPage;
              },
            ),
          );
        },
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Image(image: AssetImage(iconPath)),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Expanded(child: SizedBox()),
            const Image(image: AssetImage('assets/chevron-droit.png')),
          ]),
          const MyDivider()
        ]));
  }
}
