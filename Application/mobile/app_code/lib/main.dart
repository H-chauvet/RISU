import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/contact/contact_page.dart';
import 'package:risu/pages/container/container_page.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/map/map_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/pages/settings/settings_pages/notifications/notifications_page.dart';
import 'package:risu/pages/signup/signup_page.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

String theme = appTheme['clair'];

void main() async {
  await dotenv.load(fileName: 'lib/.env');

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  final prefs = await SharedPreferences.getInstance();
  theme = prefs.getString('appTheme') ?? appTheme['clair'];
  language = prefs.getString('language') ?? defaultLanguage;

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
        theme: context.select(
            (ThemeProvider themeProvider) => themeProvider.currentTheme),
        home: const HomePage(),
        locale: context.select((LanguageProvider languageProvider) =>
            languageProvider.currentLocale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case ContactPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const ContactPage());
            case ContainerPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const ContainerPage());
            case HomePage.routeName:
              return MaterialPageRoute(builder: (context) => const HomePage());
            case LoginPage.routeName:
              return MaterialPageRoute(builder: (context) => const LoginPage());
            case MapPage.routeName:
              return MaterialPageRoute(builder: (context) => const MapPage());
            case NotificationsPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const NotificationsPage());
            case ProfilePage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const ProfilePage());
            case ProfileInformationsPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const ProfileInformationsPage());
            case SettingsPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const SettingsPage());
            case SignupPage.routeName:
              return MaterialPageRoute(
                  builder: (context) => const SignupPage());
            default:
              return null;
          }
        });
  }
}
