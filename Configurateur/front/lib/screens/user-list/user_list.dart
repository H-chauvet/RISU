// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/user-list/user-component-web.dart';
import 'package:front/screens/user-list/user-component.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

/// UserPage
///
/// Page for the user's management in the database
class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

/// UserPageState
///
class _UserPageState extends State<UserPage> {
  List<User> users = [];
  List<UserMobile> users_mobile = [];
  bool jwtToken = false;

  @override
  void initState() {
    super.initState();
    fetchUser();
    fetchUserMobile();
    MyAlertTest.checkSignInStatusAdmin(context);
  }

  /// [Function] : Delete web user
  /// [user] : User who will be deleted
  Future<void> deleteUserWeb(User user) async {
    final Uri url = Uri.parse("http://${serverIp}:3000/api/auth/delete");
    final response = await http.post(
      url,
      body: json.encode({'email': user.email}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      showCustomToast(
          context, AppLocalizations.of(context)!.userDeleteSuccess, true);
      fetchUser();
    } else {
      showCustomToast(context, response.body, false);
    }
  }

  /// [Function] : Delete mboile user
  /// [user] : User who will be deleted
  Future<void> deleteUserMobile(UserMobile user) async {
    final Uri url = Uri.parse("http://localhost:8080/api/dev/user/delete");
    final response = await http.post(
      url,
      body: json.encode({'email': user.email}),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      showCustomToast(
          context, AppLocalizations.of(context)!.userDeleteSuccess, true);
      fetchUserMobile();
    } else {
      showCustomToast(context,
          AppLocalizations.of(context)!.errorDuringUserDeletion, false);
    }
  }

  /// [Function] : Get all the web users in the database
  Future<void> fetchUser() async {
    final response =
        await http.get(Uri.parse('http://${serverIp}:3000/api/auth/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> usersData = responseData["user"];
      setState(() {
        users = usersData.map((data) => User.fromJson(data)).toList();
      });
    } else {
      showCustomToast(context, response.body, false);
    }
  }

  /// [Function] : Get all the mobile users in the database
  Future<void> fetchUserMobile() async {
    final response = await http
        .get(Uri.parse('http://${serverIp}:3000/api/mobile/user/listAll'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> usersData = responseData["user"];
      setState(() {
        users_mobile =
            usersData.map((data) => UserMobile.fromJson(data)).toList();
      });
    } else {
      showCustomToast(context,
          AppLocalizations.of(context)!.errorDuringInformationRetrieval, false);
    }
  }

  /// [Widget] : Build the user's management page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          AppLocalizations.of(context)!.userHandling,
          context: context,
        ),
        body: FooterView(
          flex: 8,
          footer: Footer(
            child: const CustomFooter(),
          ),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              height: MediaQuery.of(context).size.height * 0.85,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      floating: true,
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.userWeb,
                              style: TextStyle(
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor),
                            ),
                          ),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!.userMobile,
                              style: TextStyle(
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.secondaryHeaderColor
                                          : lightTheme.secondaryHeaderColor),
                            ),
                          ),
                        ],
                        indicatorColor:
                            Provider.of<ThemeService>(context).isDark
                                ? darkTheme.secondaryHeaderColor
                                : lightTheme.secondaryHeaderColor,
                      ),
                      pinned: true,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final product = users[index];
                              return UserCard(
                                user: product,
                                onDelete: deleteUserWeb,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: users_mobile.length,
                            itemBuilder: (context, index) {
                              final product = users_mobile[index];
                              return UserMobileCard(
                                user: product,
                                onDelete: deleteUserMobile,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
