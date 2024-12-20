import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/dialog/confirmation_dialog.dart';
import 'package:front/components/dialog/handle_member/handle_member_style.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable

/// [StatefulWidget] : SaveDialogState
///
/// Create a new dialog to save container with specific [name]
class HandleMember extends StatefulWidget {
  HandleMember({
    super.key,
    this.organization,
  });

  dynamic organization;

  @override
  State<HandleMember> createState() => HandleMemberState();
}

/// HandleMemberState
///
class HandleMemberState extends State<HandleMember> {
  TextEditingController _controller = TextEditingController();
  String collaboratorContact = '';
  List<dynamic> collaboratorList = [];
  String jwtToken = '';
  String currentMail = '';

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != null) {
      jwtToken = token;
      dynamic decodedToken = JwtDecoder.tryDecode(jwtToken);
      currentMail = decodedToken['userMail'];
      getCompanyMember();
    }
  }

  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void addMember() async {
    var header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $jwtToken'
    };
    List<String> tmp = [];
    tmp.add(collaboratorContact);
    var body = {
      "teamMember": jsonEncode(tmp),
      "company": jsonEncode(widget.organization),
    };
    await HttpService().request(
      'http://$serverIp:3000/api/organization/invite-member',
      header,
      body,
    );
  }

  void getCompanyMember() async {
    var header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $jwtToken'
    };
    var response = await HttpService().getRequest(
      'http://$serverIp:3000/api/organization/${widget.organization.id}/members',
      header,
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      setState(() {
        for (int i = 0; i < jsonResponse['data'].length; i++) {
          collaboratorList.add(jsonResponse['data'][i]);
        }
      });
    }
  }

  void deleteUser(int i) async {
    var header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer $jwtToken'
    };
    var body = {
      'email': collaboratorList[i]['email'],
    };
    await HttpService().request(
      'http://$serverIp:3000/api/auth/delete',
      header,
      body,
    );
  }

  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return AlertDialog(
      content: SizedBox(
        height: 500,
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.addMember,
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              AppLocalizations.of(context)!.addMemberInfo,
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopInfoTextFontSize
                    : tabletInfoTextFontSize,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('collaboratorContact'),
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.enterMailCollaborator,
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
                          return AppLocalizations.of(context)!.askCompleteField;
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return AppLocalizations.of(context)!.emailNotValid;
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    key: const Key('send-button'),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        addMember();
                        showCustomToast(context, AppLocalizations.of(context)!.handleAddMember , true);
                        _controller.clear();
                        setState(() {
                          collaboratorContact = '';
                        });
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              AppLocalizations.of(context)!.actualMember,
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: collaboratorList.length,
                itemBuilder: (_, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(collaboratorList[i]['email']),
                      currentMail == collaboratorList[i]['email']
                          ? Container()
                          : IconButton(
                              onPressed: () async {
                                var confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => ConfirmationDialog(),
                                );

                                if (confirm == true) {
                                  deleteUser(i);
                                  setState(() {
                                    collaboratorList.removeAt(i);
                                  });
                                }
                              },
                              icon: const Icon(Icons.delete),
                            )
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
