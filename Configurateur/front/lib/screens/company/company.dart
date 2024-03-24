import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// import 'package:front/screens/company-company.dart';

class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => CompanyPageState();
}

class CompanyPageState extends State<CompanyPage> {
  late List<String> members = [
    'assets/Henri.png',
    'assets/Louis.png',
    'assets/Hugo.png',
    'assets/Quentin.png',
    'assets/Tanguy.png',
    'assets/Cédric.png',
  ];

  List<MyContainerList> containers = [];

  @override
  void initState() {
    super.initState();
    fetchContainers();
  }

  Future<void> fetchContainers() async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/container/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      setState(() {
        containers = containersData
            .map((data) => MyContainerList.fromJson(data))
            .toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Entreprise',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Text("Notre équipe :",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark ? darkTheme.secondaryHeaderColor : lightTheme.secondaryHeaderColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2.0,
                  decorationStyle: TextDecorationStyle.solid,
                )),
            SizedBox(
              height: 70,
            ),
            Center(
              child: Wrap(
                spacing: 70.0,
                runSpacing: 20.0,
                children: List.generate(
                  members.length,
                  (index) => Column(
                    children: [
                      Image.asset(
                        members[index],
                        key: Key('member_image_$index'),
                        width: 95,
                        height: 95,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        members[index]
                            .substring(members[index].indexOf('/') + 1,
                                members[index].indexOf('.'))
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Color.fromRGBO(70, 130, 180, 1),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            Text("Nos Conteneurs :",
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark ? darkTheme.secondaryHeaderColor : lightTheme.secondaryHeaderColor,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decorationThickness: 2.0,
                  decorationStyle: TextDecorationStyle.solid,
                )),
            SizedBox(
              height: 65,
            ),
            Wrap(
              spacing: 16.0,
              runSpacing: 16.0,
              children: List.generate(
                containers.length,
                (index) => ContainerCard(
                  container: containers[index],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
