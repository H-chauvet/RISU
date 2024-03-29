import 'package:flutter/material.dart';

class Feedbacks {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final String mark;

  Feedbacks({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.mark,
  });

  factory Feedbacks.fromJson(Map<String, dynamic> json) {
    return Feedbacks(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      message: json['message'],
      mark: json['mark'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'message': message,
      'mark': mark,
    };
  }
}

class FeedbacksCard extends StatelessWidget {
  final Feedbacks fb;

  const FeedbacksCard({super.key, required this.fb});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(child: Text("${fb.mark} / 5")),
            title: Text("Avis posté par ${fb.firstName} ${fb.lastName}"),
            subtitle: Text(fb.message),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
