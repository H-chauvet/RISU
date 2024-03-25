import 'package:flutter/foundation.dart';
import 'package:risu/utils/user_data.dart';

// Variable globale pour stocker l'adresse IP du serveur

String protocol = kDebugMode ? 'http://' : 'http://';
String serverIp = kDebugMode ? '10.0.2.2' : 'risu.dns-dynamic.net';
String port = ':3000';
String baseUrl = protocol + serverIp + port;

/// Global variable referencing the user network data
UserData? userInformation;

String defaultLanguage = 'fr';
String language = defaultLanguage;
