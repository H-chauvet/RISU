import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/pages/login/login_refresh_token.dart';
import 'package:risu/pages/reset_password/reset_password_page.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart';

import 'globals.dart';

String theme = appTheme['clair'];
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  final refreshToken = prefs.getString('refreshToken');
  if (refreshToken != null && refreshToken != '') {
    loginRefreshToken(refreshToken);
  }

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

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          _handleDeepLink(uri);
        }
      },
      onError: (err) {
        print('Deep link error: $err');
      },
    );

    if (!_isInitialized) {
      _getInitialUri();
      _isInitialized = true;
    }
  }

  void _getInitialUri() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (err) {
      print('Failed to get initial URI: $err');
    }
  }

  void _handleDeepLink(Uri uri) {
    print('Deep link: $uri');
    if (uri.path.startsWith('/resetToken/')) {
      final token = uri.queryParameters['token'];
      if (token != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState!.push(
            MaterialPageRoute(
              builder: (context) => ResetPasswordPage(token: token),
            ),
          );
        });
      }
    }
  }

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
      navigatorKey: navigatorKey,
    );
  }
}
