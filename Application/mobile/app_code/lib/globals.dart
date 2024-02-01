import 'package:http/io_client.dart';
import 'package:risu/utils/user_data.dart';

// Variable globale pour stocker l'adresse IP du serveur

// String? serverIp = 'https://risu-epitech.com'; // A garder en local

String? serverIp = '20.111.37.124'; // A mettre quand push github

/// Global variable referencing the user network data
UserData? userInformation;

IOClient ioClient = IOClient();
