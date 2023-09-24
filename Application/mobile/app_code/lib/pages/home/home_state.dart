import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:risu/network/informations.dart';
import 'package:risu/pages/login/login_page.dart';

import 'home_functional.dart';
import 'home_page.dart';

class HomePageState extends State<HomePage> {
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
