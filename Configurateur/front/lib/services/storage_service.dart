import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

StorageService storageService = StorageService();

/// StorageService
///
/// Service to store values
class StorageService {
  /// [Function] : Put a value in the storage
  /// [key] : Name of the value
  /// [value] : Value who will be stored
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

  /// [Function] : Get a value from the storage
  /// [key] : Name of the value
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

  /// [Function] : Delete a value in the storage
  /// [key] : Name of the value
  Future<bool> removeStorage(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.remove(key);
  }

  /// [Function] : Get the user email in the storage
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

  /// [Function] : Get the user uuid in the storage
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

  /// [Function] : Get the user role in the storage
  Future<String> getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString('token');

    if (token == null) {
      return '';
    }
    dynamic decodedToken = JwtDecoder.decode(token);

    return decodedToken?['role'];
  }

  /// [Function] : Check if the user is verified
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
