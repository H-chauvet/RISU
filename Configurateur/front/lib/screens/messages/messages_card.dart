import 'package:flutter/material.dart';

/// Représente un utilisateur web.
class Message {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;

  /// Crée une nouvelle instance de [Message].
  ///
  /// [id] : Contient l'id du message
  /// [firstName] : Contient le prénom de l'utilisateur
  /// [lastName] : Contient le nom de l'utilisateur
  /// [email] : Contient l'email de l'utilisateur
  /// [message] : Contenu du message
  Message({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
  });

  /// Crée une instance de [Message] à partir d'un objet JSON.
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      message: json['message'],
    );
  }

  /// Convertit l'utilisateur en une carte JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'message': message,
    };
  }
}

/// Widget représentant une carte de message.
class MessageCard extends StatelessWidget {
  final Message message;
  final Function(Message) onDelete;

  /// Crée une nouvelle instance de [MessageCard].
  ///
  /// [message] : informations du message stockées.
  /// [onDelete] : permet de supprimer un message.
  const MessageCard({super.key, required this.message, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text("${message.firstName} ${message.lastName}"),
            subtitle: Text(message.email),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDelete(message),
                ),
              ],
            ),
          ),
          Text(message.message),
        ],
      ),
    );
  }
}
