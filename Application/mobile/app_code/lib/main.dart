import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/home/home_page.dart';
import 'package:risu/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

//bool isDarkTheme = false;
String appTheme = 'Clair';

void main() async {
  await dotenv.load(fileName: "lib/.env");

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  // Continue with SharedPreferences and ThemeProvider
  final prefs = await SharedPreferences.getInstance();
  //isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
  appTheme = prefs.getString('appTheme') ?? 'Clair';

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(appTheme),
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
    return MaterialApp(
      title: 'Risu',
      theme: context
          .select((ThemeProvider themeProvider) => themeProvider.currentTheme),
      home: const HomePage(),
    );
  }
}
