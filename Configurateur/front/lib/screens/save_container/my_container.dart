import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
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
  dynamic body;

  @override
  void initState() {
    HttpService().getRequest(
      'http://$serverIp:3000/api/container/listAll',
      <String, String>{
        'Authorization': token,
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    ).then((value) => {
          if (value.statusCode == 200)
            {
              setState(() {
                body = jsonDecode(value.body);
                containers = body['container'];
              }),
            }
          else
            {
              debugPrint('error'),
            }
        });
    super.initState();
  }

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
            const Text("Mes conteneurs"),
            const SizedBox(height: 20),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: containers.length,
                itemBuilder: (_, i) {
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/container-creation',
                                  extra: jsonEncode({
                                    'id': containers[i]['id'],
                                    'container': jsonEncode(containers[i]),
                                  }));
                            },
                            child: Text(i.toString()),
                          ),
                        ),
                      ]);
                }),
          ],
        ),
      ),
    );
  }
}
