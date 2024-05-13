import 'package:flutter/material.dart';

/// Représente un utilisateur web.
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String company;
  final String email;

  /// Crée une nouvelle instance de [User].
  ///
  /// [id] : Contient l'id de l'utilisateur
  /// [firstName] : Contient le prénom de l'utilisateur
  /// [lastName] : Contient le nom de l'utilsateur
  /// [company] : entreprise à laquelle appartient l'utilisateur
  /// [email] : Contient l'email de l'utilisateur
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.company,
    required this.email,
  });

  /// Crée une instance de [User] à partir d'un objet JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      company: json['company'],
      email: json['email'],
    );
  }

  /// Convertit l'utilisateur en une carte JSON.
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

/// Widget réprésentant la carte d'un utilisateur web
class UserCard extends StatelessWidget {
  final User user;
  final Function(User) onDelete;

  /// Crée une nouvelle instance de [UserCard].
  /// 
  /// [user] : informations de l'utilsateur stockées.
  /// [onDelete] : permet de supprimer un utilisateur
  const UserCard({super.key, required this.user, required this.onDelete});

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
                if (user.company != null) Text(" Entreprise : " + user.company),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
