import 'package:flutter/material.dart';

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
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Prénom : " + user.firstName),
            subtitle: Text("Nom : " + user.lastName),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Email : " + user.email),
                    if (user.company != null)
                      Text("Entreprise : " + user.company),
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
