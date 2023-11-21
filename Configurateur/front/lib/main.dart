import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './app_routes.dart';
import 'styles/themes.dart';
import 'services/theme_service.dart';

void main() async {
  runApp(
    ChangeNotifierProvider<ThemeService>(
      create: (context) => ThemeService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationProvider: AppRouter.router.routeInformationProvider,
      routeInformationParser: AppRouter.router.routeInformationParser,
      routerDelegate: AppRouter.router.routerDelegate,
      title: 'Risu',
      theme: Provider.of<ThemeService>(context).isDark ? darkTheme : lightTheme,
    );
  }
}
