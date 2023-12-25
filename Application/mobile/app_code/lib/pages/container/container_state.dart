import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/bottomnavbar.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/list_page.dart';
import 'package:risu/pages/map/map_page.dart';
import 'package:risu/pages/profile/profile_page.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/theme.dart';
import 'package:http/http.dart' as http;

import 'container_page.dart';
import 'container_list.dart';
import 'dart:convert';

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
        Uri.parse('http://$serverIp:3000/api/container/listAll'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> containersData = responseData["container"];
        setState(() {
          containers = containersData.map((data) => ContainerList.fromJson(data)).toList();
        });
      } else {
        print('Error getContainer(): ${response.statusCode}');
      }
    } catch (e) {
      print('Error getContainer(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: false,
      ),
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
                    ListView.builder(
                      shrinkWrap:
                          true,
                      itemCount: containers.length,
                      itemBuilder: (context, index) {
                        final product = containers[index];
                        return ContainerCard(
                          container: product,
                        );
                      },
                    ),
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
