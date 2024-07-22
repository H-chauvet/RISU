import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/footer.dart';
import 'package:front/screens/company-profil/container-profil.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// OrganizationList
///
/// Define the data of organization in back end
/// [id] : Organization's id
/// [name] : Organization's name
/// [type] : Organization's type
/// [affiliate] : Users afiliate to the organization
/// [containers] : Containers created by the organization
/// [contactInformation] : More informations about the organization
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

/// CompanyProfilPage
///
/// Profil page for the organization of the user
class CompanyProfilPage extends StatefulWidget {
  const CompanyProfilPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CompanyProfilPage> createState() => CompanyProfilPageState();
}

/// CompanyProfilPageState
///
class CompanyProfilPageState extends State<CompanyProfilPage> {
  OrganizationList organization = OrganizationList(
      id: null,
      name: null,
      type: null,
      affiliate: null,
      containers: null,
      contactInformation: null);
  List<ContainerListData> containersList = [];

  String userMail = '';

  late String name = '';
  late String type = '';
  late DateTime createdDate;
  late String contactInformation = '';
  late String company;
  int organizationId = 0;
  String jwtToken = '';

  /// [Function] : get all the containers created by the organization
  Future<void> fetchContainersById() async {
    final response = await http.get(
      Uri.parse(
          'http://${serverIp}:3000/api/container/listByOrganization/$organizationId'),
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      setState(() {
        containersList = containersData
            .map((data) => ContainerListData.fromJson(data))
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

  /// [Function] : Update contact information of the organization
  /// [contactInformationController] : Controller to modify the contactInformation value
  Future<void> apiUpdateContactInfoOrganization(
      TextEditingController contactInformationController) async {
    final String apiUrl =
        "http://$serverIp:3000/api/organization/update-information/$organizationId";
    var body = {
      'contactInformation': contactInformationController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Modification effectuée avec succès',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
      );
      checkToken();
    } else {
      Fluttertoast.showToast(
        msg: "Erreur durant l'envoi de modification des informations",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
      );
    }
  }

  /// [Function] : Display pop up where you can modify the contactInformation
  /// [initialContactInformation] : Contact information of the organization
  Future<void> showEditPopupContactInformation(BuildContext context,
      String initialContactInformation, Function(String) onEdit) async {
    TextEditingController contactInformationController =
        TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier"),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key('information'),
                  controller: contactInformationController,
                  decoration: InputDecoration(
                      labelText: "Nouvelles informations",
                      hintText: initialContactInformation),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "Annuler",
                key: const Key('cancel-edit-information'),
              ),
            ),
            ElevatedButton(
              key: const Key('button-information'),
              onPressed: () async {
                apiUpdateContactInfoOrganization(contactInformationController);
                onEdit(contactInformationController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "Modifier",
              ),
            ),
          ],
        );
      },
    );
  }

  /// [Function] : Update type of the organization
  /// [typeController] : Controller to modify the type value
  Future<void> apiUpdateType(TextEditingController typeController) async {
    final String apiUrl =
        "http://$serverIp:3000/api/organization/update-type/$organizationId";
    var body = {
      'type': typeController.text,
    };

    var response = await http.post(
      Uri.parse(apiUrl),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Modification effectuée avec succès',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
      );
      checkToken();
    } else {
      Fluttertoast.showToast(
        msg: "Erreur durant l'envoi de modification des informations",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
      );
    }
  }

  /// [Function] : Display pop up where you can modify the type
  /// [initialType] : Type of the organization
  Future<void> showEditPopupType(
      BuildContext context, String initialType, Function(String) onEdit) async {
    TextEditingController typeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Modifier"),
          content: Container(
            height: 120.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10.0),
                TextField(
                  key: const Key('type'),
                  controller: typeController,
                  decoration: InputDecoration(
                      labelText: "Nouveau type", hintText: initialType),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "Annuler",
                key: const Key('cancel-edit-type'),
              ),
            ),
            ElevatedButton(
              key: const Key('button-type'),
              onPressed: () async {
                apiUpdateType(typeController);
                onEdit(typeController.text);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: const Text(
                "Modifier",
              ),
            ),
          ],
        );
      },
    );
  }

  /// [Function] : Delete container
  /// [container] : The container who will be deleted
  Future<void> deleteContainer(ContainerListData container) async {
    late int id;
    if (container.id != null) {
      id = container.id!;
      print("c'est l'id : $id");
    }
    final Uri url = Uri.parse("http://${serverIp}:3000/api/container/delete");
    final response = await http.post(
      url,
      body: json.encode({'id': id}),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $jwtToken',
      },
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: 'Conteneur supprimé avec succès',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      checkToken();
    } else {
      Fluttertoast.showToast(
        msg:
            'Erreur lors de la suppression du container: ${response.statusCode}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  /// [Function] : Get the organization details
  /// [email] : User's mail
  Future<void> fetchOrganizationDetails(String email) async {
    try {
      final String apiUrl =
          "http://$serverIp:3000/api/auth/user-details/$email";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = json.decode(response.body);
        final dynamic organizationData = userDetails["organization"];
        final dynamic organizationIdData = userDetails["organizationId"];
        organizationId = organizationIdData;
        if (organizationId > 0) {
          fetchContainersById();
        } else {
          return;
        }
        setState(() {
          organization = OrganizationList.fromJson(organizationData);
          if (organization.name != null) {
            name = organization.name!;
          }
          if (organization.type != null) {
            type = organization.type!;
          }
          if (organization.contactInformation != null) {
            contactInformation = organization.contactInformation!;
          }
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

  /// [Function] : Check if the token is still available
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token!;
      storageService.getUserMail().then((value) {
        userMail = value;
        if (userMail.isNotEmpty) {
          fetchOrganizationDetails(userMail);
        }
      });
    } else {
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  /// [Widget] : Build the company profil page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Entreprise',
          context: context,
        ),
        body: FooterView(
            footer: Footer(
              child: CustomFooter(context: context),
            ),
            children: [
              Center(
                child: Column(
                  children: [
                    organization.id != null
                        ? Container(
                            height: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: Image.asset(
                                      "assets/logo.png",
                                      width: 90.0,
                                      height: 90.0,
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    organization.name != null &&
                                            organization.name != ''
                                        ? Text(
                                            "Nom de l'entreprise : ${organization.name!}",
                                            style: const TextStyle(
                                              color: Color(0xff4682B4),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Verdana',
                                            ),
                                          )
                                        : Text(
                                            "L'entreprise n'a pas de nom",
                                            style: const TextStyle(
                                              color: Color(0xff4682B4),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Verdana',
                                            ),
                                          ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        organization.contactInformation !=
                                                    null &&
                                                organization
                                                        .contactInformation !=
                                                    ''
                                            ? Text(
                                                "Information : ${organization.contactInformation!}",
                                                style: const TextStyle(
                                                  color: Color(0xff4682B4),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Verdana',
                                                ),
                                              )
                                            : Text(
                                                "Aucune information disponible",
                                                style: const TextStyle(
                                                  color: Color(0xff4682B4),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Verdana',
                                                ),
                                              ),
                                        const SizedBox(width: 5.0),
                                        InkWell(
                                          key: Key('edit-information'),
                                          onTap: () async {
                                            await showEditPopupContactInformation(
                                                context, contactInformation,
                                                (String newContactInformation) {
                                              setState(() {
                                                contactInformation =
                                                    newContactInformation;
                                              });
                                            });
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5.0),
                                    Row(
                                      children: [
                                        organization.type != null &&
                                                organization.type != ''
                                            ? Text(
                                                "Type d'entreprise : ${organization.type!}",
                                                style: const TextStyle(
                                                  color: Color(0xff4682B4),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Verdana',
                                                ),
                                              )
                                            : Text(
                                                "Pas de type disponible",
                                                style: const TextStyle(
                                                  color: Color(0xff4682B4),
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Verdana',
                                                ),
                                              ),
                                        const SizedBox(width: 5.0),
                                        InkWell(
                                          key: const Key('edit-type'),
                                          onTap: () async {
                                            await showEditPopupType(
                                                context, type,
                                                (String newtype) {
                                              setState(() {
                                                type = newtype;
                                              });
                                            });
                                          },
                                          child: const Icon(
                                            Icons.edit,
                                            color: Colors.grey,
                                            size: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Container(
                              height: 250,
                              alignment: Alignment.center,
                              child: Text(
                                "Pas d'entreprise associée",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 211, 11, 11),
                                ),
                              ),
                            ),
                          ),
                    const Text(
                      "Nos Conteneurs :",
                      style: TextStyle(
                        color: Color.fromRGBO(70, 130, 180, 1),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        decorationThickness: 2.0,
                        decorationStyle: TextDecorationStyle.solid,
                      ),
                    ),
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
                            spacing: 10.0,
                            runSpacing: 8.0,
                            children: List.generate(
                              containersList.length,
                              (index) => ContainerCards(
                                container: containersList[index],
                                onDelete: deleteContainer,
                                page: "/container-profil",
                                key: ValueKey<String>(
                                    'delete_${containersList[index].id}'),
                              ),
                            ),
                          ),
                  ],
                ),
              )
            ])

        // bottomNavigationBar: const CustomBottomNavigationBar(),
        );
  }
}
