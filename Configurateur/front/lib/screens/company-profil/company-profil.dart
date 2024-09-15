// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/container.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/dialog/handle_member/handle_member.dart';
import 'package:front/components/dialog/save_dialog.dart';
import 'package:front/components/footer.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:front/network/informations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
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

  Map<String, dynamic> toJson() {
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
  bool isManager = false;

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
      showCustomToast(context, response.body, false);
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
      showCustomToast(
          context, AppLocalizations.of(context)!.modifySuccess, true);
      checkToken();
    } else {
      showCustomToast(context, response.body, false);
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
          title: Text(AppLocalizations.of(context)!.modify),
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
                    labelText: AppLocalizations.of(context)!.informationNew,
                    hintText: initialContactInformation,
                  ),
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
              child: Text(
                AppLocalizations.of(context)!.cancel,
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
              child: Text(
                AppLocalizations.of(context)!.modify,
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
      showCustomToast(
          context, AppLocalizations.of(context)!.modifySuccess, true);
      checkToken();
    } else {
      showCustomToast(context, response.body, false);
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
          title: Text(AppLocalizations.of(context)!.modify),
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
                      labelText: AppLocalizations.of(context)!.typeNew,
                      hintText: initialType),
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
              child: Text(
                AppLocalizations.of(context)!.cancel,
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
              child: Text(
                AppLocalizations.of(context)!.modify,
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
      showCustomToast(
          context, AppLocalizations.of(context)!.containerDeleted, true);
      checkToken();
    } else {
      showCustomToast(context, response.body, false);
    }
  }

  void openTeamMemberHandling() async {
    await showDialog(
      context: context,
      builder: (context) => HandleMember(
        organization: organization,
      ),
    );
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
          AppLocalizations.of(context)!
              .errorFetchingUserDetailsCodeData(response.statusCode),
        );
      }
    } catch (error) {
      debugPrint(
          AppLocalizations.of(context)!.errorFetchingUserDetailsData(error));
    }
  }

  /// [Function] : Check if the token is still available
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token!;
      dynamic decodedToken = JwtDecoder.tryDecode(jwtToken);

      isManager = decodedToken['manager'];
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
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
        body: FooterView(
            footer: Footer(
              padding: EdgeInsets.zero,
              child: const CustomFooter(),
            ),
            children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.companyHandling,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
                  ? desktopBigFontSize
                  : tabletBigFontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
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
                              padding: const EdgeInsets.all(10.0),
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
                                        AppLocalizations.of(context)!
                                            .companyNameData(
                                                organization.name!),
                                        style: const TextStyle(
                                          color: Color(0xff4682B4),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Verdana',
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .companyNameEmpty,
                                        style: const TextStyle(
                                          color: Color(0xff4682B4),
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Verdana',
                                        ),
                                      ),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    organization.contactInformation != null &&
                                            organization.contactInformation !=
                                                ''
                                        ? Text(
                                            AppLocalizations.of(context)!
                                                .informationData(organization
                                                    .contactInformation!),
                                            style: const TextStyle(
                                              color: Color(0xff4682B4),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Verdana',
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .informationEmpty,
                                            style: const TextStyle(
                                              color: Color(0xff4682B4),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Verdana',
                                            ),
                                          ),
                                    const SizedBox(width: 5.0),
                                    InkWell(
                                      key: const Key('edit-information'),
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
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    organization.type != null &&
                                            organization.type != ''
                                        ? Text(
                                            AppLocalizations.of(context)!
                                                .companyTypeData(
                                                    organization.type!),
                                            style: const TextStyle(
                                              color: Color(0xff4682B4),
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Verdana',
                                            ),
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .typeEmpty,
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
                                        await showEditPopupType(context, type,
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
                            AppLocalizations.of(context)!.companyNotLinked,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 211, 11, 11),
                            ),
                          ),
                        ),
                      ),
                isManager
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          openTeamMemberHandling();
                        },
                        child: Text(
                          "Gérer les membres",
                          style: TextStyle(
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.ourContainers,
                  style: const TextStyle(
                    color: Color.fromRGBO(70, 130, 180, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
                const SizedBox(
                  height: 65,
                ),
                containersList.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.containerNotFound,
                          style: const TextStyle(
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
