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

  const UserMobileCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(user.firstName),
            // subtitle: Text(user.email),
            // leading: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text(userMobile.company),
            //     Text(userMobile.password),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
