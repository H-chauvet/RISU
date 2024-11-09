import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_refresh_token.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

String theme = appTheme['clair'];

/// Main function.
/// This function is the entry point of the application.
/// It loads the .env file and the Stripe publishable key.
/// It initializes the Stripe settings.
/// It gets the theme and the language from the shared preferences.
/// It gets the refresh token from the shared preferences.
void main() async {
  try {
    await dotenv.load(fileName: 'lib/.env');
  } catch (e) {
    print('Error .env: $e');
  }

  if (dotenv.env['STRIPE_PUBLISHABLE_KEY'] == null) {
    print('Error: STRIPE_PUBLISHABLE_KEY is not defined in .env');
    return;
  }

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  final prefs = await SharedPreferences.getInstance();
  theme = prefs.getString('appTheme') ?? appTheme['clair'];
  language = prefs.getString('language') ?? defaultLanguage;
  final refreshToken = prefs.getString('refreshToken');
  if (refreshToken != null && refreshToken != '') {
    loginRefreshToken(refreshToken);
  }

  await Future.delayed(const Duration(seconds: 2));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider(theme)),
        ChangeNotifierProvider(
            create: (context) => LanguageProvider(Locale(language))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    themeProvider.startSystemThemeListener();

    return MaterialApp(
      theme: context
          .select((ThemeProvider themeProvider) => themeProvider.currentTheme),
      home: const HomePage(),
      locale: context.select((LanguageProvider languageProvider) =>
          languageProvider.currentLocale),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
