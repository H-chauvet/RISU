import 'package:flutter/material.dart';

/// Représente un avis.
class Feedbacks {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;
  final String mark;

  /// Crée une nouvelle instance de [Feedbacks].
  ///
  /// [id] : Contient l'id d'un avis
  /// [firstName] : Contient le prénom de l'utilisateur
  /// [lastName] : Contient le nom de l'utilsateur
  /// [email] : Contient l'email de l'utilisateur
  /// [message] : Contenu du message de l'utilisateur
  /// [mark] : Contient le nombre de marque de l'utilisateur
  Feedbacks({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
    required this.mark,
  });

  /// Crée une instance de [Feedbacks] à partir d'un objet JSON.
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

  /// Convertit l'avis en une carte JSON.
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

/// Widget représentant une carte d'avis.
class FeedbacksCard extends StatelessWidget {
  final Feedbacks fb;

  /// Crée une nouvelle instance de [Feedbacks].
  ///
  /// [fb] : informations de l'avis stockées.
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
