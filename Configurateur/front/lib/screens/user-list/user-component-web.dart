import 'package:flutter/material.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';

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

class UserCard extends StatelessWidget {
  final User user;
  final Function(User) onDelete;

  const UserCard({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              "Prénom : " + user.firstName,
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
            subtitle: Text(
              "Nom : " + user.lastName,
              style: TextStyle(
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
                      "Email : " + user.email,
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                      ),
                    ),
                    if (user.company != null)
                      Text(
                        "Entreprise : " + user.company,
                        style: TextStyle(
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
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
