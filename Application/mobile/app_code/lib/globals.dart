import 'package:flutter/foundation.dart';
import 'package:risu/utils/user_data.dart';

// Variable globale pour stocker l'adresse IP du serveur

String? serverIp = kReleaseMode ? '51.103.94.191' : '10.0.2.2';

/// Global variable referencing the user network data
UserData? userInformation;

String defaultLanguage = 'fr';
String language = defaultLanguage;
