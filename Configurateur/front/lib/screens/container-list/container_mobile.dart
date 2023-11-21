import 'package:flutter/material.dart';

class UserMobile {
  final String id;
  final String localisation;
  final dynamic items;
  final String owner;

  UserMobile({
    required this.id,
    required this.localisation,
    required this.items,
    required this.owner,
  });

  factory UserMobile.fromJson(Map<String, dynamic> json) {
    return UserMobile(
      id: json['id'],
      localisation: json['localisation'],
      items: json['items'],
      owner: json['owner'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'localisation': localisation,
      'items': items,
      'owner': owner,
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
            title: Text(user.id),
            // subtitle: Text(user.localisation),
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
