import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

StorageService storageService = StorageService();

class StorageService {
  void writeStorage(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime expirationTime =
        DateTime.now().add(const Duration(minutes: 60));

    await prefs.setString(key, value);
    if (key == 'token') {
      await prefs.setString(
          'tokenExpiration', expirationTime.toIso8601String());
    }
  }

  Future<String?> readStorage(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (key == 'token') {
      final String? expirationTime = prefs.getString('tokenExpiration');
      if (expirationTime == null) {
        removeStorage('token');
        return '';
      }
      final DateTime expTime = DateTime.parse(expirationTime);
      if (expTime.isBefore(DateTime.now())) {
        removeStorage('token');
        removeStorage('tokenExpiration');
        return '';
      }
    }

    return prefs.getString(key);
  }

  Future<bool> removeStorage(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.remove(key);
  }

  Future<String> getUserMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token == null) {
      return '';
    }
    dynamic decodedToken = JwtDecoder.decode(token);

    if (decodedToken != null) {
      return decodedToken['userMail'];
    } else {
      return '';
    }
  }

  Future<String> getUserUuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token == null) {
      return '';
    }
    dynamic decodedToken = JwtDecoder.decode(token);

    if (decodedToken != null) {
      return decodedToken['userUuid'];
    } else {
      return '';
    }
  }

  Future<bool> isUserVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    dynamic decodedToken = JwtDecoder.decode(token!);

    if (decodedToken != null) {
      return decodedToken['confirmed'];
    } else {
      return false;
    }
  }
}
