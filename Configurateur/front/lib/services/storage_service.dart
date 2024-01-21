import 'package:shared_preferences/shared_preferences.dart';

String userMail = "";

class StorageService {
  late SharedPreferences prefs;

  Future<void> initializePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  void writeStorage(key, value) async {
    await prefs.setString(key, value);
  }

  String? readStorage(key) {
    return prefs.getString(key);
  }

  Future<bool> removeStorage(key) async {
    return await prefs.remove(key);
  }
}
