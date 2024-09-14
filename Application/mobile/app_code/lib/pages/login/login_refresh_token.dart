import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../globals.dart';
import 'package:http/http.dart' as http;
import 'package:risu/utils/user_data.dart';

/// Function to refresh the token.
/// This function is used to login the user using the refresh token.
/// params:
/// [refreshToken] - refresh token of the user.
void loginRefreshToken(refreshToken) async {
  try {
    http.Response response = await http.post(
      Uri.parse('$baseUrl/api/mobile/auth/login/refreshToken'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refreshToken': refreshToken,
      }),
    );
    final jsonData = jsonDecode(response.body);
    if (response.statusCode == 201) {
      userInformation = UserData.fromJson(jsonData['user'], jsonData['token']);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('refreshToken', jsonData['user']['refreshToken']);
    }
  } catch (err) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshToken', '');
  }
}
