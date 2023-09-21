import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/router.dart';
import 'package:risu/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isDarkTheme = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  isDarkTheme = prefs.getBool('isDarkTheme') ?? false;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(isDarkTheme),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Risu',
      theme: context
          .select((ThemeProvider themeProvider) => themeProvider.currentTheme),
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
