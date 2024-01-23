import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:risu/globals.dart';

import 'container_list.dart';
import 'container_page.dart';

class ContainerPageState extends State<ContainerPage> {
  List<ContainerList> containers = [];

  @override
  void initState() {
    super.initState();
    getContainer();
  }

  void getContainer() async {
    try {
      final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/container/listAll'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dynamic responseData = json.decode(response.body);
        final List<dynamic> containersData = responseData;
        setState(() {
          containers = containersData
              .map((data) => ContainerList.fromJson(data))
              .toList();
        });
      } else {
        print('Error getContainer(): ${response.statusCode}');
      }
    } catch (err) {
      print('Error getContainer(): $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.only(
                left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Liste des conteneurs',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4682B4),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    if (containers.isEmpty)
                      const Text(
                        'Aucun conteneur trouvé.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4682B4),
                        ),
                      )
                    else ...[
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: containers.length,
                        itemBuilder: (context, index) {
                          final product = containers.elementAt(index);
                          return ContainerCard(
                            container: product,
                          );
                        },
                      ),
                    ]
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
