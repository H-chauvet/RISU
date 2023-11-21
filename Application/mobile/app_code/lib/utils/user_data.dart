import 'package:flutter/material.dart';

/// This class is the UserData class.
/// It contains all information about an UserData
class UserData {
  String? token;
  String email;
  String? firstName;
  String? lastName;
  String? ID;

  /// Constructor of the UserData class
  UserData({
    required this.email,
    this.token,
    required this.firstName,
    required this.lastName,
    this.ID,
  });

  /// Function to display user email
  Widget? displayUserEmail() {
    return Column(
      children: [
        Text(email),
      ],
    );
  }

  /// Convert a json map into the class
  factory UserData.fromJson(Map<String, dynamic> json) {
    late bool isToken;
    try {
      json['token'];
      isToken = true;
    } catch (err) {
      isToken = false;
    }

    return UserData(
      email: json['user']['email'],
      token: (isToken ? json['token'] : null),
      firstName: json['user']['firstName'],
      lastName: json['user']['lastName'],
      ID: json['user']['id'],
    );
  }
}
