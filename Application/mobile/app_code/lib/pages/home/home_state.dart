import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:risu/utils/user_data.dart';
import 'package:risu/components/alert_dialog.dart';

import 'home_functional.dart';
import 'home_page.dart';
import 'dart:async';
import 'dart:convert';

class HomePageState extends State<HomePage> {
  bool isProfileConfigured = false;

  void configProfile() async {
    try {
      final firstName = userInformation!.firstName;
      final lastName = userInformation!.lastName;
      print('firstName : $firstName');
      print('lastName : $lastName');
      if (firstName.isEmpty && lastName.isEmpty) {
        await Future.delayed(Duration.zero);
        await MyAlertDialog.showChoiceAlertDialog(
            context: context,
            title: 'Profil incomplet',
            message: 'Veuillez compléter votre profil avant de continuer.',
            onOkName: 'Compléter le profil',
            onOk: () {
              context.go('/profile');
            },
            onCancelName: 'Annuler',
            onCancel: () {
            }
        );
      }
      setState(() {
        isProfileConfigured = true;
      });
    } catch (e) {
      print('Error configProfile(): $e');
    }
  }

  /// Update state function
  void update() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updatePage = update;
  }

  /// Re sync all flutter object
  void homeSync() async {
    update();
  }

  @override
  Widget build(BuildContext context) {
    if (logout || userInformation == null) {
      userInformation = null;
      return const LoginPage();
    } else {
      if (!isProfileConfigured) {
        configProfile();
      }
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
                ],
              ),
            ),
          ))));
    }
  }
}
