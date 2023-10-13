import 'package:risu/utils/user_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Variable globale pour stocker l'adresse IP du serveur
String? serverIp = dotenv.env['SERVER_IP'];

/// Global variable referencing the user network data
UserData? userInformation;
