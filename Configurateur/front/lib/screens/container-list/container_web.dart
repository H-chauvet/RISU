// import 'dart:ffi';

import 'package:flutter/material.dart';

class User {
  final int? id;
  final dynamic? createdAt;
  final dynamic? organization;
  final int? organizationId;
  final dynamic? containerMapping;
  final double? price;

  User({
    required this.id,
    required this.createdAt,
    required this.organization,
    required this.organizationId,
    required this.containerMapping,
    required this.price,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      createdAt: json['createdAt'],
      organization: json['organization'],
      organizationId: json['organizationId'],
      containerMapping: json['containerMapping'],
      price: json['price'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt,
      'organization': organization,
      'organizationId': organizationId,
      'containerMapping': containerMapping,
      'price': price,
    };
  }
}

class UserCard extends StatelessWidget {
  final User user;

  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('${user.id}'),
            subtitle: Text('${user.price}'),
            // leading: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     Text(user.organizationId),
            //     Text(user.password),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}
