import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:front/services/language_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'app_routes.dart';
import 'services/theme_service.dart';
import 'styles/themes.dart';

/// [Function] : Launch the web application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey =
      "pk_test_51OKkt3HkBPo6kqvSNnGpz15uJSXmrgXOK3eUv8CIw9dwp3q7nibb39ktqw6FLdEulS3kXfWlEKqW4og1KmBLhPdh00DSNgjev3";
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  language = await storageService.readStorage('language') ?? defaultLanguage;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeService>(
          create: (context) => ThemeService(),
        ),
        ChangeNotifierProvider<LanguageService>(
          create: (context) => LanguageService(Locale(language)),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// [Widget] : Build the web application
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          routeInformationProvider: AppRouter.router.routeInformationProvider,
          routeInformationParser: AppRouter.router.routeInformationParser,
          routerDelegate: AppRouter.router.routerDelegate,
          title: 'Risu',
          theme: Provider.of<ThemeService>(context).isDark
              ? darkTheme
              : lightTheme,
          locale: Provider.of<LanguageService>(context).currentLocale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
