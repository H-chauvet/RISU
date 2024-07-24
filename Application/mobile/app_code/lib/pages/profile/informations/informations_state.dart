import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:risu/utils/user_data.dart';
import 'package:risu/utils/validators.dart';

import 'informations_page.dart';

class ProfileInformationsPageState extends State<ProfileInformationsPage> {
  String newFirstName = '';
  String newLastName = '';
  String newEmail = '';
  final TextEditingController currentPasswordController =
      TextEditingController(text: '');
  final TextEditingController newPasswordController =
      TextEditingController(text: '');
  final TextEditingController newPasswordConfirmationController =
      TextEditingController(text: '');
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();
    fetchUserData(context);
  }

  @override
  void dispose() {
    super.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    newPasswordConfirmationController.dispose();
  }

  Future<void> fetchUserData(BuildContext context) async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.get(
          Uri.parse('$baseUrl/api/mobile/user/${userInformation!.ID}'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token',
          });
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        final userData = json.decode(response.body)['user'];
        final String? userToken = userInformation!.token;
        userInformation = UserData.fromJson(userData, userToken!);
        newFirstName = '';
        newLastName = '';
      } else {
        if (context.mounted) {
          printServerResponse(context, response, 'fetchUserData');
        }
      }
    } catch (err, stacktrace) {
      if (context.mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
        return;
      }
      return;
    }
  }

  Future<void> updateEmail() async {
    try {
      final token = userInformation!.token;
      Map<String, dynamic> body = {};
      if (newEmail != '') {
        if (Validators().email(context, newEmail) != null) {
          if (mounted) {
            await MyAlertDialog.showErrorAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.error,
              message: AppLocalizations.of(context)!.emailInvalid,
            );
          }
          return;
        }
        body['newEmail'] = newEmail;
      } else {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.fieldsEmpty,
          );
        }
        return;
      }
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$baseUrl/api/mobile/user/newEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        if (mounted) {
          await MyAlertDialog.showInfoAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.newEmailVerify,
            message: AppLocalizations.of(context)!
                .accountEmailConfirmationSent(newEmail),
          );
        }
      } else {
        if (mounted) {
          printServerResponse(context, response, 'updateUser',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringUpdateUserInformation);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSavingData);
        return;
      }
      return;
    }
  }

  Future<void> updateUser() async {
    try {
      final token = userInformation!.token;
      Map<String, dynamic> body = {};
      if (newFirstName != '') {
        body['firstName'] = newFirstName;
      }
      if (newLastName != '') {
        body['lastName'] = newLastName;
      }
      if (newEmail != '') {
        if (Validators().email(context, newEmail) != null) {
          if (mounted) {
            await MyAlertDialog.showErrorAlertDialog(
              context: context,
              title: AppLocalizations.of(context)!.error,
              message: AppLocalizations.of(context)!.emailInvalid,
            );
          }
          return;
        }
        body['email'] = newEmail;
      }
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$baseUrl/api/mobile/user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        if (mounted) {
          await fetchUserData(context);
        }
        if (mounted) {
          MyToastMessage.show(
            context: context,
            message: AppLocalizations.of(context)!.profileUpdated,
          );
        }
      } else {
        if (mounted) {
          printServerResponse(context, response, 'updateUser',
              message: AppLocalizations.of(context)!
                  .errorOccurredDuringUpdateUserInformation);
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSavingData);
        return;
      }
      return;
    }
  }

  Future<void> updatePassword(
      String currentPassword, String newPassword) async {
    try {
      final newPasswordConfirmation = newPasswordConfirmationController.text;
      if (currentPassword == '' ||
          newPassword == '' ||
          newPasswordConfirmation == '') {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.fieldsEmpty,
          );
        }
        return;
      }
      if (newPassword != newPasswordConfirmation) {
        if (mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: AppLocalizations.of(context)!.passwordsDoNotMatch,
          );
        }
        return;
      }

      final token = userInformation!.token;
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final response = await http.put(
        Uri.parse('$baseUrl/api/mobile/user/password'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      if (response.statusCode == 200) {
        json.decode(response.body);
        currentPasswordController.clear();
        newPasswordController.clear();
        newPasswordConfirmationController.clear();
        if (mounted) {
          MyToastMessage.show(
            context: context,
            message: AppLocalizations.of(context)!.passwordUpdated,
          );
        }
      } else {
        if (response.statusCode == 401) {
          if (mounted) {
            printServerResponse(context, response, 'updatePassword',
                message:
                    AppLocalizations.of(context)!.passwordCurrentIncorrect);
          }
        } else {
          if (mounted) {
            printServerResponse(context, response, 'updatePassword',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringPasswordUpdate);
          }
        }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace,
            message:
                AppLocalizations.of(context)!.errorOccurredDuringSavingData);
        return;
      }
      return;
    }
  }

  Widget buildField(String label,
      {Key? key,
      String? initialValue,
      Function(String)? onChanged,
      TextEditingController? controller,
      bool isPassword = false}) {
    return TextFormField(
      key: key,
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: isPassword,
      controller: controller,
      style: TextStyle(
        color: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.inputDecorationTheme.labelStyle!.color),
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: context.select((ThemeProvider themeProvider) => themeProvider
              .currentTheme.inputDecorationTheme.labelStyle!.color),
          fontSize: 16.0,
        ),
        enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: context.select((ThemeProvider themeProvider) =>
                    themeProvider.currentTheme.primaryColor))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: true,
        onBackButtonPressed: () {
          Navigator.pop(context, true);
        },
        textTitle: AppLocalizations.of(context)!.profileInformation,
      ),
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.surface),
      body: (_loaderManager.getIsLoading())
          ? Center(child: _loaderManager.getLoader())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 32, bottom: 16),
                child: Center(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.myInformation,
                          key: const Key('profile_info-text_informations'),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor)),
                        ),
                      ),
                      buildField(
                        AppLocalizations.of(context)!.firstName,
                        key: const Key('profile_info-text_field_firstname'),
                        initialValue: userInformation!.firstName ?? '',
                        onChanged: (value) {
                          setState(() => newFirstName = value);
                        },
                      ),
                      buildField(
                        AppLocalizations.of(context)!.lastName,
                        key: const Key('profile_info-text_field_lastname'),
                        initialValue: userInformation!.lastName ?? '',
                        onChanged: (value) {
                          setState(() => newLastName = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        key: const Key('profile_info-button_update'),
                        text: AppLocalizations.of(context)!.saveChanges,
                        onPressed: () async {
                          await updateUser();
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.email,
                          key: const Key('profile_info-text_email'),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: context.select(
                                  (ThemeProvider themeProvider) =>
                                      themeProvider.currentTheme.primaryColor)),
                        ),
                      ),
                      buildField(
                        AppLocalizations.of(context)!.email,
                        key: const Key('profile_info-text_field_email'),
                        initialValue: userInformation!.email,
                        onChanged: (value) {
                          setState(() => newEmail = value);
                        },
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        key: const Key('profile_email-button_update'),
                        text: AppLocalizations.of(context)!.saveEmail,
                        onPressed: () async {
                          await updateEmail();
                        },
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context)!.password,
                          key: const Key('profile_info-text_password'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: context.select(
                                (ThemeProvider themeProvider) =>
                                    themeProvider.currentTheme.primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildField(
                        AppLocalizations.of(context)!.passwordCurrent,
                        key: const Key(
                            'profile_info-text_field_current_password'),
                        isPassword: true,
                        controller: currentPasswordController,
                      ),
                      buildField(
                        AppLocalizations.of(context)!.new_,
                        key: const Key('profile_info-text_field_new_password'),
                        isPassword: true,
                        controller: newPasswordController,
                      ),
                      buildField(
                        AppLocalizations.of(context)!.passwordConfirmation,
                        key: const Key(
                            'profile_info-text_field_new_password_confirmation'),
                        isPassword: true,
                        controller: newPasswordConfirmationController,
                      ),
                      const SizedBox(height: 16),
                      MyButton(
                        key: const Key('profile_info-button_update_password'),
                        text: AppLocalizations.of(context)!.passwordSave,
                        onPressed: () async {
                          await updatePassword(currentPasswordController.text,
                              newPasswordController.text);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
