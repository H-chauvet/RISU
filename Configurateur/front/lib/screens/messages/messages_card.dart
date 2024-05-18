import 'package:flutter/material.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';

/// Message
///
/// [id] : Message's id
/// [firstName] : User's name
/// [lastName] : User's last name
/// [email] : User's mail
/// [message] : Message's content
class Message {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String message;

  Message({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.message,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      message: json['message'],
    );
  }

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

/// MessageCard
///
/// Creation of Card for message
/// [message] : Selected message
/// [onDelete] : To delete a message
class MessageCard extends StatelessWidget {
  final Message message;
  final Function(Message) onDelete;

  const MessageCard({super.key, required this.message, required this.onDelete});

  /// [Widget] : Build the message's card
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              "${message.firstName} ${message.lastName}",
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
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
