import 'package:flutter/material.dart';

/// This class is the UserData class.
/// It contains all information about an UserData
class UserData {
  String? token;
  String email;
  String? firstName;
  String? lastName;

  /// Constructor of the UserData class
  UserData({
    required this.email,
    this.token,
    required this.firstName,
    required this.lastName,
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

    print(json['user']);
    try {
      json['user']['firstname'];
      json['user']['lastname'];
    } catch (err) {
      print('Error: $err');
    }

    return UserData(
        email: json['user']['email'],
        token: (isToken ? json['token'] : null),
        firstName: json['user']['firstname'],
        lastName: json['user']['lastname']);
  }
}
