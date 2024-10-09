import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

/// Web user class
///
/// Store all the user's information from the database
/// [id] : User's id
/// [firstName] : User's firstname
/// [lastName] : User's lastname
/// [company] : User's company
/// [email] : User's mail
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String company;
  final String email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      company: json['company'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'company': company,
      'email': email,
    };
  }
}

/// UserCard
///
/// Card for a web user informations
/// [user] : User's informations
/// [onDelete] : To delete a user
class UserCard extends StatelessWidget {
  final User user;
  final Function(User) onDelete;
  const UserCard({super.key, required this.user, required this.onDelete});

  /// [Widget] : Build the card for a web user
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.firstNameData(user.firstName),
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
            subtitle: Text(
              AppLocalizations.of(context)!.lastNameData(user.lastName),
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.emailData(user.email),
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                      ),
                    ),
                    if (user.company != null)
                      Text(
                        AppLocalizations.of(context)!.companyData(user.company),
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.delete,
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor),
                  onPressed: () => onDelete(user),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
