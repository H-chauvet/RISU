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
  factory UserData.fromJson(Map<String, dynamic> user, String token) {
    return UserData(
      email: user['email'],
      token: token,
      firstName: user['firstName'],
      lastName: user['lastName'],
      ID: user['id'],
    );
  }
}
