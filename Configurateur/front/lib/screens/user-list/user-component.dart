import 'package:flutter/material.dart';

class MyContainerList {
  final int id;
  final String? containerMapping;

  MyContainerList({required this.id, required this.containerMapping});

  factory MyContainerList.fromJson(Map<String, dynamic> json) {
    return MyContainerList(
      id: json['id'],
      containerMapping: json['containerMapping'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmProcess;
  final bool mailVerification;
  final dynamic createdAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      email: json['email'],
      lastName: json['lastName'],
      password: json['password'],
      createdAt: json['createdAt'],
      confirmProcess: json['confirmProcess'],
      mailVerification: json['mailVerification'],
    );
  }

  User({
    required this.id,
    required this.firstName,
    required this.email,
    required this.lastName,
    required this.password,
    required this.createdAt,
    required this.confirmProcess,
    required this.mailVerification,
  });
}

class MessageCard extends StatelessWidget {
  final User message;
  final Function(User) onDelete;

  const MessageCard({super.key, required this.message, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            // title: Text("${message.firstName} ${message.lastName}"),
            // subtitle: Text(message.email),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message.firstName),

                // IconButton()
                  // icon: const Icon(Icons.delete),
                  // onPressed: () => onDelete(message),
                // ),
              ],
            ),
          ),
          // Text(message.email),
        ],
      ),
    );
  }
}