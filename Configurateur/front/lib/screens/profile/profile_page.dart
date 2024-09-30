// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_popup.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/pw_validator_strings.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/profile/profile_page_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// ProfilePage
///
/// Page of the user's profil
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

/// ProfileState
///
class _ProfilePageState extends State<ProfilePage> {
  late String firstName = '';
  late String lastName = '';
  late DateTime createdDate = DateTime.now();
  late String formattedDate = '';
  late String company = '';
  String userMail = '';

  /// [Function] : Get the user's details in the database
  Future<void> fetchUserDetails(String email) async {
    final String apiUrl = "http://$serverIp:3000/api/auth/user-details/$email";

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> userDetails = json.decode(response.body);

        setState(() {
          firstName = userDetails['firstName'];
          lastName = userDetails['lastName'];
          createdDate = DateTime.parse(userDetails['createdAt']);
          formattedDate = DateFormat('dd/MM/yyyy').format(createdDate);
          company = userDetails['company'];
        });
      } else {
        debugPrint(
          AppLocalizations.of(context)!
              .errorDuringUserInformationRetrievalData(response.statusCode),
        );
      }
    } catch (error) {
      debugPrint(AppLocalizations.of(context)!
          .errorDuringUserInformationRetrievalData(error));
    }
  }

  @override
  void initState() {
    super.initState();

    /// Récupère l'email de l'utilisateur dans le stockage local
    storageService.getUserMail().then((value) {
      userMail = value;
      MyAlertTest.checkSignInStatus(context);
      fetchUserDetails(userMail);
    });
  }

  /// [Function] : Show pop up to modify the user's name
  /// [initialFirstName] : User's first name
  /// [initialLastName] : User's last name
  Future<void> showEditPopupName(BuildContext context, String initialFirstName,
      String initialLastName, Function(String, String) onEdit) async {
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          title: AppLocalizations.of(context)!.userIdentityModify,
          content: Column(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.userNameModify,
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize - 5
                      : tabletFontSize - 5,
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              TextField(
                key: const Key("first-name"),
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.firstNameNew,
                  hintText: AppLocalizations.of(context)!
                      .actualData(initialFirstName),
                ),
              ),
              const SizedBox(height: 10.0),
              TextField(
                key: const Key("last-name"),
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.laststNameNew,
                  hintText:
                      AppLocalizations.of(context)!.actualData(initialLastName),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                key: const Key("button-name"),
                onPressed: () async {
                  final String apiUrl =
                      "http://$serverIp:3000/api/auth/update-details/$userMail";
                  var body = {
                    'firstName': firstNameController.text,
                    'lastName': lastNameController.text,
                  };
                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: body,
                  );

                  if (response.statusCode == 200) {
                    showCustomToast(context,
                        AppLocalizations.of(context)!.modifySuccess, true);
                    onEdit(firstNameController.text, lastNameController.text);
                    Navigator.of(context).pop();
                  } else {
                    showCustomToast(context, response.body, false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// [Function] : Check the token in the storage service
  /// [initialCompany] : Initial user's company
  Future<void> showEditPopupCompany(BuildContext context, String initialCompany,
      Function(String) onEdit) async {
    TextEditingController companyController = TextEditingController();
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return CustomPopup(
              title: AppLocalizations.of(context)!.companyNameEdit,
              content: Column(
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.companyNameUpdate,
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize - 5
                          : tabletFontSize - 5,
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  TextField(
                    key: const Key("company"),
                    controller: companyController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.companyNewName,
                      hintText: AppLocalizations.of(context)!
                          .actualData(initialCompany),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    key: const Key("button-company"),
                    onPressed: () async {
                      final String apiUrl =
                          "http://$serverIp:3000/api/auth/update-company/$userMail";
                      var body = {
                        'company': companyController.text,
                      };

                      var response = await http.post(
                        Uri.parse(apiUrl),
                        body: body,
                      );

                      if (response.statusCode == 200) {
                        showCustomToast(
                            context,
                            AppLocalizations.of(context)!.companyInfoEdited,
                            true);
                        onEdit(companyController.text);
                        Navigator.of(context).pop();
                      } else {
                        showCustomToast(context, response.body, false);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.update,
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize
                            : tabletFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// [Function] : Show pop up to modify the user's mail
  Future<void> showEditPopupMail(BuildContext context, String? initialMail,
      Function(String) onEdit) async {
    TextEditingController mailController = TextEditingController();
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomPopup(
          title: AppLocalizations.of(context)!.emailEdit,
          content: Column(
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.emailUpdate,
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize - 5
                      : tabletFontSize - 5,
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              TextField(
                key: const Key("user-mail"),
                controller: mailController,
                decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.emailNew,
                    hintText:
                        AppLocalizations.of(context)!.actualData(initialMail!)),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String apiUrl =
                      "http://$serverIp:3000/api/auth/update-mail";
                  var body = {
                    'oldMail': userMail,
                    'newMail': mailController.text,
                  };

                  var response = await http.post(
                    Uri.parse(apiUrl),
                    body: body,
                  );

                  if (response.statusCode == 200) {
                    showCustomToast(context,
                        AppLocalizations.of(context)!.emailEdited, true);
                    onEdit(mailController.text);
                    Navigator.of(context).pop();
                  } else {
                    showCustomToast(context, response.body, false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.update,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// [Function] : Show pop up to modify the user's password
  Future<void> showEditPopupPassword(BuildContext context,
      String initialPassword, Function(String) onEdit) async {
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;
    bool isPasswordValid = false;
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return CustomPopup(
              title: AppLocalizations.of(context)!.passwordEdit,
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.passwordUpdate,
                      style: TextStyle(
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopFontSize - 5
                            : tabletFontSize - 5,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      key: const Key('password'),
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.passwordFill,
                        labelText: AppLocalizations.of(context)!.password,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.askCompleteField;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    FlutterPwValidator(
                      controller: passwordController,
                      minLength: 8,
                      uppercaseCharCount: 1,
                      numericCharCount: 1,
                      specialCharCount: 1,
                      failureColor: const Color(0xFF990000),
                      successColor: const Color(0xFF009900),
                      width: 320,
                      height: 120,
                      strings: PasswordStrings(context),
                      onSuccess: () {
                        setState(
                          () {
                            isPasswordValid = true;
                          },
                        );
                      },
                      onFail: () {
                        setState(
                          () {
                            isPasswordValid = false;
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      key: const Key('confirm-password'),
                      controller: confirmPasswordController,
                      obscureText: obscureConfirmPassword,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.passwordConfirmation,
                        labelText:
                            AppLocalizations.of(context)!.passwordConfirm,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.askCompleteField;
                        }
                        if (value != passwordController.text) {
                          return AppLocalizations.of(context)!
                              .passwordDontMatch;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      key: const Key("button-password"),
                      onPressed: () async {
                        if (passwordController.text ==
                                confirmPasswordController.text &&
                            isPasswordValid) {
                          final String apiUrl =
                              "http://$serverIp:3000/api/auth/update-password/$userMail";
                          var body = {'password': passwordController.text};

                          var response = await http.post(
                            Uri.parse(apiUrl),
                            body: body,
                          );

                          if (response.statusCode == 200) {
                            showCustomToast(
                                context,
                                AppLocalizations.of(context)!
                                    .passwordModifySuccess,
                                true);
                            onEdit(passwordController.text);
                            Navigator.of(context).pop();
                          } else {
                            showCustomToast(context, response.body, false);
                          }
                        } else {
                          showCustomToast(
                              context,
                              AppLocalizations.of(context)!.passwordDontMatch,
                              false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.update,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// [Widget] : Build the user's profil page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FooterView(
          flex: 10,
          footer: Footer(
            padding: EdgeInsets.zero,
            child: const CustomFooter(),
          ),
          children: [
            Column(
              children: [
                LandingAppBar(context: context),
                Text(
                  AppLocalizations.of(context)!.profileEditText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 35,
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
                const SizedBox(height: 100),
                Center(
                  child: Container(
                    width: 700.0,
                    height: 600.0,
                    decoration: BoxDecoration(
                      color: Provider.of<ThemeService>(context).isDark
                          ? const Color.fromARGB(255, 70, 69, 69)
                          : const Color.fromARGB(255, 236, 234, 234),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.25),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              firstName,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Verdana',
                              ),
                            ),
                            const SizedBox(width: 10),
                            Row(
                              children: [
                                Text(
                                  lastName,
                                  style: TextStyle(
                                    color: Provider.of<ThemeService>(context)
                                            .isDark
                                        ? darkTheme.primaryColor
                                        : lightTheme.primaryColor,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Verdana',
                                  ),
                                ),
                                const SizedBox(width: 5.0),
                                InkWell(
                                  key: const Key('edit-name'),
                                  onTap: () async {
                                    await showEditPopupName(
                                      context,
                                      firstName,
                                      lastName,
                                      (String newFirstName,
                                          String newLastName) {
                                        setState(() {
                                          firstName = newFirstName;
                                          lastName = newLastName;
                                        });
                                      },
                                    );
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.grey,
                                    size: 26.0,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 90),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.email,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Verdana',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    userMail,
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  InkWell(
                                    key: const Key('edit-mail'),
                                    onTap: () async {
                                      await showEditPopupMail(context, userMail,
                                          (String newMail) {
                                        setState(() {
                                          userMail = newMail;
                                        });
                                      });
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.company,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Verdana',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    company,
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  InkWell(
                                    key: const Key('edit-company'),
                                    onTap: () async {
                                      await showEditPopupCompany(
                                          context, company,
                                          (String newCompany) {
                                        setState(() {
                                          company = newCompany;
                                        });
                                      });
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          thickness: 2,
                          indent: 20,
                          endIndent: 20,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                AppLocalizations.of(context)!.password,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Verdana',
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: Row(
                                children: [
                                  Text(
                                    '*********',
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Verdana',
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  InkWell(
                                    key: const Key('edit-password'),
                                    onTap: () async {
                                      await showEditPopupPassword(context, "",
                                          (String newPassword) {
                                        setState(() {});
                                      });
                                    },
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                      size: 18.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.go("/");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.backToHome,
                                    style: TextStyle(
                                      color: Provider.of<ThemeService>(context)
                                              .isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .createdTimeData(formattedDate),
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Verdana',
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    storageService.removeStorage('token');
                                    storageService
                                        .removeStorage('tokenExpiration');
                                    showCustomToast(
                                        context,
                                        AppLocalizations.of(context)!.loggedOff,
                                        true);
                                    context.go("/");
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.logOff,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
