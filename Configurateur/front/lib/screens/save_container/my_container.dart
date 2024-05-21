import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

/// MyContainer
///
/// Page to show all the user's containers
class MyContainer extends StatefulWidget {
  const MyContainer({super.key});

  @override
  State<MyContainer> createState() => MyContainerState();
}

/// MyContainerState
///
class MyContainerState extends State<MyContainer> {
  List<dynamic> containers = [];
  List<dynamic> displayedContainers = [];
  dynamic body;
  String? token = '';
  String userMail = '';
  int organizationId = 0;

  /// [Function] : Get all the containers in the database
  void getContainers() async {
    HttpService().getRequest(
      'http://$serverIp:3000/api/container/listByOrganization/$organizationId',
      <String, String>{
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    ).then(
      (value) => {
        if (value.statusCode == 200)
          {
            setState(() {
              debugPrint(value.body);
              body = jsonDecode(value.body);
              containers = body['container'];

              debugPrint(containers.toString());

              for (int i = 0; i < containers.length; i++) {
                if (containers[i]['paid'] == false) {
                  displayedContainers.add(containers[i]);
                }
              }
              debugPrint(displayedContainers.toString());
            }),
          }
        else
          {
            debugPrint('error'),
          }
      },
    );
  }

  Future<void> checkToken() async {
    token = await storageService.readStorage('token');
    if (token == "") {
      context.go('/login');
    } else {
      storageService.getUserMail().then((value) async {
        userMail = value;
        if (userMail.isNotEmpty) {
          final String apiUrl =
              "http://$serverIp:3000/api/auth/user-details/$userMail";

          final response = await http.get(
            Uri.parse(apiUrl),
            headers: <String, String>{
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> userDetails = json.decode(response.body);
            final dynamic organizationIdData = userDetails["organizationId"];
            organizationId = organizationIdData;
          }

          getContainers();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkToken();
    });
  }

  /// [Widget] : Build my containers page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    //debugPrint(displayedContainers[0]['name'].toString());

    return Scaffold(
      appBar: CustomAppBar(
        "Mes conteneurs",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
            Text(
              "Mes conteneurs sauvegardés",
              style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: displayedContainers.length,
                itemBuilder: (_, i) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton(
                          key: Key('container_button_$i'),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            context.go(
                              '/container-creation',
                              extra: jsonEncode(
                                {
                                  'id': displayedContainers[i]['id'],
                                  'container':
                                      jsonEncode(displayedContainers[i]),
                                },
                              ),
                            );
                          },
                          child: Text(
                            displayedContainers[i]['saveName'],
                            style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
