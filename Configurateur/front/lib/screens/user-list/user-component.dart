import 'package:flutter/material.dart';

class UserMobile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  UserMobile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  factory UserMobile.fromJson(Map<String, dynamic> json) {
    return UserMobile(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

class UserMobileCard extends StatelessWidget {
  final UserMobile user;
  final Function(UserMobile) onDelete;

  const UserMobileCard({super.key, required this.user, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("Prénom : " + user.firstName),
            subtitle: Text("Nom : " + user.lastName),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(user),
                ),
                Text("Email : " + user.email),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
