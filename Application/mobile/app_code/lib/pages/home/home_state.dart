import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:risu/utils/user_data.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/history_location/history_page.dart';
import 'package:risu/pages/map/map_page.dart';

import 'home_functional.dart';
import 'home_page.dart';
import 'dart:async';
import 'dart:convert';

class HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  final List<Widget> _pages = [
    HistoryLocationPage(),
    const MapPage(),
    const ProfilePage(),
  ];
  bool didAskForProfile = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!didAskForProfile) {
        configProfile();
      }
    });
  }

  void configProfile() async {
    try {
      String? firstName = userInformation?.firstName;
      String? lastName = userInformation?.lastName;
      if (firstName == null || lastName == null) {
        await Future.delayed(Duration.zero, () {
          MyAlertDialog.showChoiceAlertDialog(
            context: context,
            title: 'Profil incomplet',
            message: 'Veuillez compléter votre profil avant de continuer.',
            onOkName: 'Compléter le profil',
            onOk: () {
              Navigator.pop(context, 'OK');
              setState(() {
                _currentIndex = 2;
              });
            },
            onCancelName: 'Annuler',
          );
        });
      }
      setState(() {
        didAskForProfile = true;
      });
    } catch (e) {
      print('Error configProfile(): $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
      return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
              child: Center(
                  child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('HomePage'),
                  ElevatedButton(
                    onPressed: () {
                      // Rediriger vers la route /profile
                      context.go('/profile');
                    },
                    child: const Text('Aller au profil'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Rediriger vers la route /profile
                      context.go('/contact');
                    },
                    child: const Text('Page de contact'),
                  ),
                ],
              ),
            ),
          ))));
    }
  }
}
