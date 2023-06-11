import 'package:flutter/material.dart';

class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 40,
      decoration: const BoxDecoration(
          color: Color.fromARGB(255, 214, 214, 214),
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              // decoration: BoxDecoration(color: Colors.blue),
              child: Image.asset(
            'assets/google-logo.png',
            height: 20,
          )),
          const SizedBox(
            width: 5.0,
          ),
          const Text('Google')
        ],
      ),
    );
  }
}
