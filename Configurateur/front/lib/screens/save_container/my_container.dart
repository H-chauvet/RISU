import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';

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

  /// [Function] : Get all the containers in the database
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

  /// [Widget] : Build my containers page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Mes conteneurs",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Mes conteneurs sauvegardés",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
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
                            context.go('/container-creation',
                                extra: jsonEncode({
                                  'id': displayedContainers[i]['id'],
                                  'container':
                                      jsonEncode(displayedContainers[i]),
                                }));
                          },
                          child: Text(displayedContainers[i]['saveName']),
                        ),
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
