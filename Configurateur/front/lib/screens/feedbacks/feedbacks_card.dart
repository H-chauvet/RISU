import 'package:flutter/material.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';

/// [Feedbacks]
/// [id] : Id of the feedback
/// [firstName] : User's name
/// [lastName] : User's last name
/// [email] : User's mail
/// [message] : User's message
/// [mark] : Number of stars for the rating (1 to 5)
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

/// FeedBacksCard
///
/// Creation of card for feednack
/// [fb] : Feedback's informations
class FeedbacksCard extends StatelessWidget {
  final Feedbacks fb;

  const FeedbacksCard({super.key, required this.fb});

  /// [Widget] : Build card for a feedback
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(
                "${fb.mark} / 5",
                style: TextStyle(
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize),
              ),
            ),
            title: Text(
              "Avis posté par ${fb.firstName} ${fb.lastName}",
              style: TextStyle(
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize),
            ),
            subtitle: Text(fb.message),
          ),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
