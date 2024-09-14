import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:footer/footer_view.dart';
import 'package:footer/footer.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/company-creation/company-creation_style.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// CompanyCreationPage
///
/// Home page for the web application
class CompanyCreationPage extends StatefulWidget {
  const CompanyCreationPage({super.key, required this.params});

  final String params;

  @override
  State<CompanyCreationPage> createState() => CompanyCreationPageState();
}

/// CompanyCreationPageState
///
class CompanyCreationPageState extends State<CompanyCreationPage> {
  String companyName = '';
  String companyContact = '';
  String collaboratorContact = '';
  List<String> collaboratorList = [];
  String jwtToken = '';

  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      jwtToken = "";
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void inviteTeamMember(dynamic companyInfo) async {
    var header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = {
      "teamMember": jsonEncode(collaboratorList),
      "company": companyInfo,
    };
    await HttpService().request(
      'http://$serverIp:3000/api/organization/invite-member',
      header,
      body,
    );
  }

  void createCompany() async {
    var body = {
      "name": companyName,
      "contactInformation": companyContact,
    };
    var header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $jwtToken'
    };
    var response = await HttpService()
        .request('http://$serverIp:3000/api/organization/create', header, body);

    if (response.statusCode == 200) {
      body = {
        "email": widget.params,
        "company": response.body,
        "manager": false.toString(),
      };
      await HttpService().putRequest(
          'http://$serverIp:3000/api/auth/update-company', header, body);
      inviteTeamMember(response.body);
    } else {
      showCustomToast(context, response.body, false);
    }
    context.go("/register-confirmation", extra: widget.params);
  }

  /// [Function] : Build the CompanyCreation page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      body: FooterView(
        footer: Footer(
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          const SizedBox(
            height: 50,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Création d'entreprise",
                style: TextStyle(
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopBigFontSize
                      : tabletBigFontSize,
                  fontWeight: FontWeight.bold,
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                ),
              ),
              SizedBox(
                width: screenFormat == ScreenFormat.desktop
                    ? desktopCompanyWidthFactor
                    : tabletCompanyWidthFactor,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      key: const Key('name'),
                      decoration: InputDecoration(
                        hintText: "Entrez le nom de l'entreprise",
                        labelText: 'Nom',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        companyName = value!;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      key: const Key('contact'),
                      decoration: InputDecoration(
                        hintText: "Entrez un mail pour contacter l'entreprise",
                        labelText: 'Contact',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onChanged: (String? value) {
                        companyContact = value!;
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Souhaitez-vous inviter des collaborateurs ?",
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                        fontWeight: FontWeight.bold,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.secondaryHeaderColor
                            : lightTheme.secondaryHeaderColor,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: const Key('collaboratorContact'),
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText:
                                  "Entrez un mail pour inviter le collaborateur",
                              labelText: 'Mail',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onChanged: (String? value) {
                              collaboratorContact = value!;
                            },
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez remplir ce champ';
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () => {
                            if (collaboratorContact != '')
                              {
                                setState(() {
                                  collaboratorList.add(collaboratorContact);
                                  collaboratorContact = '';
                                  _controller.text = '';
                                })
                              }
                          },
                          icon: Icon(Icons.send),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: collaboratorList.length,
                      itemBuilder: (_, i) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(collaboratorList[i]),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  collaboratorList.removeAt(i);
                                });
                              },
                              icon: Icon(Icons.delete),
                            )
                          ],
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      key: const Key('terminate'),
                      onPressed: () {
                        createCompany();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Text("Créer",
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.colorScheme.background,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
