import 'package:flutter/material.dart';

/// This class is the UserData class.
/// It contains all information about an UserData
class UserData {
  String? token;
  String? refreshToken;
  String email;
  String? firstName;
  String? lastName;
  String? ID;
  List<bool>? notifications = [
    true,
    true,
    true,
  ];

  /// Constructor of the UserData class
  UserData({
    required this.email,
    this.token,
    this.refreshToken,
    required this.firstName,
    required this.lastName,
    this.ID,
    this.notifications,
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
      refreshToken: user['refreshToken'],
      firstName: user['firstName'],
      lastName: user['lastName'],
      ID: user['id'],
      notifications: [
        user['Notifications']['favoriteItemsAvailable'],
        user['Notifications']['endOfRenting'],
        user['Notifications']['newsOffersRisu'],
      ],
    );
  }
}
