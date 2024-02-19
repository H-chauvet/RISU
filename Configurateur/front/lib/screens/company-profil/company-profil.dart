import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/footer.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:front/components/custom_app_bar.dart';
// import 'package:front/screens/container-list/container_web.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';
import 'package:intl/intl.dart';
// CtnList

class OrganizationList {
  final int? id;
  final String? name;
  final String? type;
  final dynamic? affiliate;
  final dynamic? containers;
  final String? contactInformation;

  OrganizationList({
    required this.id,
    required this.name,
    required this.type,
    required this.affiliate,
    required this.containers,
    required this.contactInformation,
  });

  factory OrganizationList.fromJson(Map<String, dynamic> json) {
    return OrganizationList(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      affiliate: json['affiliate'],
      containers: json['containers'],
      contactInformation: json['contactInformation'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'affiliate': affiliate,
      'containers': containers,
      'contactInformation': contactInformation,
    };
  }
}

class CompanyProfilPage extends StatefulWidget {
  const CompanyProfilPage({Key? key}) : super(key: key);

  @override
  State<CompanyProfilPage> createState() => CompanyProfilPageState();
}

class CompanyProfilPageState extends State<CompanyProfilPage> {
  late OrganizationList organization;
  List<CtnList> containersList = [];

  String userMail = '';

  late String name = '';
  late String type = '';
  late DateTime createdDate;
  late String contactInformation = '';
  late String company;
  late int organizationId;

  Future<void> fetchContainers(orgaId) async {
    // debugPrint("c'est l'orga 22: $orgaId");
    // print("c'est l'orga 2 : $orgaId");
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/container/list/$organizationId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      debugPrint('Container details: $containersData');
      setState(() {
        containersList =
            containersData.map((data) => CtnList.fromJson(data)).toList();
      });
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la récupération: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> deleteContainer(CtnList message) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/container/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': message.id}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Message supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      fetchContainers(organizationId);
    } else {
      Fluttertoast.showToast(
        msg: 'Erreur lors de la suppression du message: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchOrganizationDetails(String email) async {
    final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = json.decode(response.body);
        debugPrint('User details: $userDetails');
        final dynamic organizationData = userDetails["organization"];
        final dynamic organizationIdData = userDetails["organizationId"];
        organizationId = organizationIdData;
        fetchContainers(organizationId);
        setState(() {
          organization = OrganizationList.fromJson(organizationData);
        });
      } else {
        debugPrint(
          'Failed to fetch user details. Status code: ${response.statusCode}',
        );
      }
    } catch (error) {
      debugPrint('Error fetching user details: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    storageService.getUserMail().then((value) {
      userMail = value;
      fetchOrganizationDetails(userMail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Entreprise',
        context: context,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 300,
                height: 200,
                child: Card(
                  child: Row(
                    children: [
                      Image.asset("assets/logo.png"),
                      Column(
                        children: [
                          if (organization != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nom de l\'entreprise : ${organization.name ?? 'N/A'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                Text(
                                  'Type de l\'entreprise : ${organization.type ?? 'N/A'}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          if (organization == null)
                            Text(
                              'Les informations de l\'entreprise ne sont pas disponibles.',
                              style: TextStyle(fontSize: 18),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Text("Nos Conteneurs :",
                  style: TextStyle(
                    color: Color.fromRGBO(70, 130, 180, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    decorationStyle: TextDecorationStyle.solid,
                  )),
              SizedBox(
                height: 65,
              ),
              containersList.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun conteneur trouvé.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 211, 11, 11),
                        ),
                      ),
                    )
                  : Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: List.generate(
                        containersList.length,
                        (index) => ContainerCards(
                          container: containersList[index],
                          onDelete: deleteContainer,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
