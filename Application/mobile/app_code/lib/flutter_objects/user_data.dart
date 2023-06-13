import 'package:flutter/material.dart';

/// This class is the UserData class.
/// It contains all information about an UserData
class UserData {
  String? token;
  String email;

  /// Constructor of the UserData class
  UserData({
    required this.email,
    this.token,
  });

  /// Function to display user email
  Widget? displayUserEmail() {
    return Column(
      children: <Widget>[
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
        email: json['user']['email'], token: (isToken ? json['token'] : null));
  }
}
