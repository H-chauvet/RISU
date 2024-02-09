import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/user_data.dart';

Widget initPage(Widget page, {String appTheme = 'Clair'}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(appTheme),
      ),
      ChangeNotifierProvider(
          create: (context) => LanguageProvider(const Locale('fr'))),
    ],
    child: MaterialApp(
      home: page,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
}

UserData initExampleUser(
    {String? email,
    String? firstName,
    String? lastName,
    List<bool>? notifications}) {
  return UserData(
    email: email ?? 'example@gmail.com',
    firstName: firstName ?? 'Example',
    lastName: lastName ?? 'Gmail',
    notifications: notifications ??
        [
          false,
          false,
          false,
        ],
  );
}

UserData initNullUser({String? email, List<bool>? notifications}) {
  return UserData(
    email: email ?? 'example@gmail.com',
    firstName: null,
    lastName: null,
    notifications: notifications ??
        [
          false,
          false,
          false,
        ],
  );
}

Future<void> waitForLoader(
    {required WidgetTester tester, required Widget testPage}) async {
  await tester.pumpWidget(testPage);
  while (true) {
    try {
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpWidget(testPage, const Duration(milliseconds: 100));
    } catch (e) {
      break;
    }
  }
}
