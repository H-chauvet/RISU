import 'package:flutter/material.dart';

/// Représente un utilisateur mobile.
class UserMobile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;

  /// Crée une nouvelle instance de [UserMobile].
  ///
  /// [id] : Contient l'id de l'utilisateur
  /// [email] : Contient l'email de l'utilisateur
  /// [firstName] : Contient le prénom de l'utilisateur
  /// [lastName] : Contient le nom de l'utilsateur
  UserMobile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  /// Crée une instance de [UserMobile] à partir d'un objet JSON.
  factory UserMobile.fromJson(Map<String, dynamic> json) {
    return UserMobile(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  /// Convertit l'utilisateur en une carte JSON.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}

/// Widget réprésentant la carte d'un utilisateur mobile
class UserMobileCard extends StatelessWidget {
  final UserMobile user;
  final Function(UserMobile) onDelete;

  /// Crée une nouvelle instance de [UserMobileCard].
  /// 
  /// [user] : informations de l'utilsateur stockées.
  /// [onDelete] : permet de supprimer un utilisateur
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
