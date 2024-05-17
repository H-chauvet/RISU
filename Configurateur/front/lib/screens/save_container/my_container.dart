import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';

class MyContainer extends StatefulWidget {
  const MyContainer({super.key});

  @override
  State<MyContainer> createState() => MyContainerState();
}

///
/// Password change screen
///
/// page de confirmation d'enregistrement pour le configurateur
class MyContainerState extends State<MyContainer> {
  List<dynamic> containers = [];
  List<dynamic> displayedContainers = [];
  dynamic body;

  void getContainers() async {
    String? token = await storageService.readStorage('token');
    HttpService().getRequest(
      'http://$serverIp:3000/api/container/listAll',
      <String, String>{
        'Authorization': token!,
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    ).then((value) => {
          if (value.statusCode == 200)
            {
              setState(() {
                body = jsonDecode(value.body);
                containers = body['container'];

                for (int i = 0; i < containers.length; i++) {
                  if (containers[i]['paid'] == false) {
                    displayedContainers.add(containers[i]);
                  }
                }
              }),
            }
          else
            {
              debugPrint('error'),
            }
        });
  }

  @override
  void initState() {
    getContainers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      appBar: CustomAppBar(
        "Mes conteneurs",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Mes conteneurs sauvegardés",
              style: TextStyle(
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
