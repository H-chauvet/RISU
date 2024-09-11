import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/footer.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/company/company_style.dart';
import 'package:front/screens/company/container-company.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';

/// [StatefulWidget] : CompanyPage
///
/// Page of the Risu Company and the containers created with the configurator
class CompanyPage extends StatefulWidget {
  const CompanyPage({Key? key}) : super(key: key);

  @override
  State<CompanyPage> createState() => CompanyPageState();
}

/// CompanyPageState
///
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
  String? token = '';

  /// [Function] to get the containers in the database
  /// return list of containers
  void fetchContainers() async {
    final response = await HttpService().getRequest(
      'http://$serverIp:3000/api/container/listAll',
      <String, String>{
        'Authorization': 'Bearer ${token!}',
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> containersData = responseData["container"];
      setState(() {
        containers = containersData
            .map((data) => MyContainerList.fromJson(data))
            .toList();
      });
    } else {
      showCustomToast(context, response.body, false);
    }
  }

  Future<void> checkToken() async {
    token = await storageService.readStorage('token');
    if (token == "") {
      context.go('/login');
    } else {
      fetchContainers();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkToken();
    });
  }

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
            AppLocalizations.of(context)!.risuTeam,
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
          const SizedBox(
            height: 50,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  AppLocalizations.of(context)!.ourTeam2,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.secondaryHeaderColor
                        : lightTheme.secondaryHeaderColor,
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopBigFontSize
                        : tabletBigFontSize,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 2.0,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
                const SizedBox(
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
                            width: screenFormat == ScreenFormat.desktop
                                ? desktopMemberImageSize
                                : tabletMemberImageSize,
                            height: screenFormat == ScreenFormat.desktop
                                ? desktopMemberImageSize
                                : tabletMemberImageSize,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            members[index]
                                .substring(members[index].indexOf('/') + 1,
                                    members[index].indexOf('.'))
                                .toUpperCase(),
                            style: TextStyle(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              fontSize: screenFormat == ScreenFormat.desktop
                                  ? desktopFontSize
                                  : tabletFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  AppLocalizations.of(context)!.ourContainers,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.secondaryHeaderColor
                        : lightTheme.secondaryHeaderColor,
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopBigFontSize
                        : tabletBigFontSize,
                    fontWeight: FontWeight.bold,
                    decorationThickness: 2.0,
                    decorationStyle: TextDecorationStyle.solid,
                  ),
                ),
                const SizedBox(
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
        ],
      ),
    );
  }
}
