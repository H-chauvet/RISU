import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'globals.dart';
import 'package:http/http.dart' as http;
import 'package:risu/utils/user_data.dart';

String theme = appTheme['clair'];

void main() async {
  await dotenv.load(fileName: 'lib/.env');

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  void loginRefreshToken(refreshToken) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$baseUrl/api/mobile/auth/login/refreshToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'refreshToken': refreshToken,
        }),
      );
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 201) {
        userInformation =
            UserData.fromJson(jsonData['user'], jsonData['token']);
      }
    } catch (err) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('refreshToken', '');
    }
  }

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
