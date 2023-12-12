import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import './app_routes.dart';
import 'styles/themes.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51OKkt3HkBPo6kqvSNnGpz15uJSXmrgXOK3eUv8CIw9dwp3q7nibb39ktqw6FLdEulS3kXfWlEKqW4og1KmBLhPdh00DSNgjev3";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  await dotenv.load(fileName: "../.env");

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
