import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';
import 'package:risu/utils/user_data.dart';

Widget initPage(Widget page, {String appTheme = 'Clair'}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(appTheme),
      ),
    ],
    child: MaterialApp(
      home: page,
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
