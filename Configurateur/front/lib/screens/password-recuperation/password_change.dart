// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/network/informations.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'password_change_style.dart';

/// PasswordChange
///
/// Page where the user can change is password
/// [params] : uuid of the user
class PasswordChange extends StatefulWidget {
  const PasswordChange({super.key, required this.params});

  final String params;

  @override
  State<PasswordChange> createState() => PasswordChangeState();
}

/// PasswordChangeState
///
class PasswordChangeState extends State<PasswordChange> {
  /// [Widget] : Build the password change page
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String password = '';
    String validedPassword = '';
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      appBar: CustomAppBar(
        AppLocalizations.of(context)!.passwordNew,
        context: context,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: screenFormat == ScreenFormat.desktop
              ? desktopWidthFactor
              : tabletWidthFactor,
          heightFactor: 0.7,
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                TextFormField(
                  key: const Key('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.passwordFill,
                    labelText: AppLocalizations.of(context)!.password,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    password = value!;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.askCompleteField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  key: const Key('confirm-password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.passwordConfirmation,
                    labelText: AppLocalizations.of(context)!.passwordConfirm,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    validedPassword = value!;
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.askCompleteField;
                    }
                    if (value != password) {
                      return AppLocalizations.of(context)!.passwordDontMatch;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: screenFormat == ScreenFormat.desktop
                      ? desktopSendButtonWidth
                      : tabletSendButtonWidth,
                  child: ElevatedButton(
                    key: const Key('change-password'),
                    onPressed: () async {
                      if (formKey.currentState!.validate() &&
                          password == validedPassword) {
                        var response = await http.post(
                          Uri.parse(
                              'http://$serverIp:3000/api/auth/update-password'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Access-Control-Allow-Origin': '*',
                          },
                          body: jsonEncode(<String, String>{
                            'uuid': widget.params,
                            'password': password,
                          }),
                        );
                        if (response.statusCode == 200) {
                          showCustomToast(
                              context,
                              AppLocalizations.of(context)!
                                  .passwordModifySuccess,
                              true);
                        } else {
                          showCustomToast(context, response.body, false);
                        }
                        context.go("/");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.passwordModify,
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
