import 'package:flutter/material.dart';
import 'package:risu/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Risu',
      theme: ThemeData(
          fontFamily: 'Roboto-Bold',
          brightness: Brightness.dark,
          secondaryHeaderColor: Colors.white),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
