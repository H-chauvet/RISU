import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:profile_photo/profile_photo.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/divider.dart';
import 'package:risu/components/outlined_button.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/favorite/favorite_page.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/profile/informations/informations_page.dart';
import 'package:risu/pages/rent/rental_page.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/providers/theme.dart';

import 'profile_page.dart';

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  Widget toComplete() {
    if (userInformation!.lastName == null ||
        userInformation!.firstName == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 20, top: 20),
        child: MyOutlinedButton(
          key: const Key('profile-button-complete_button'),
          text: AppLocalizations.of(context)!.toComplete,
          sizeCoefficient: 0.8,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const ProfileInformationsPage();
                },
              ),
            ).then(
              (value) {
                if (value != null && value == true) {
                  setState(() {
                    userInformation = userInformation;
                  });
                }
              },
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    String email = userInformation!.email;
    var splitEmail = email.split('@');
    var hiddenEmail = email.replaceRange(
        2, splitEmail[0].length, '*' * (splitEmail[0].length - 2));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30, top: 20),
                    child: ProfilePhoto(
                      key: const Key('profile-profile_photo-user_photo'),
                      totalWidth: 56,
                      cornerRadius: 80,
                      color: Colors.blue,
                      image: const AssetImage('assets/avatar-rond.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userInformation!.firstName ?? AppLocalizations.of(context)!.firstName} ${userInformation!.lastName ?? AppLocalizations.of(context)!.lastName}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            hiddenEmail,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  toComplete()
                ],
              ),
              const MyDivider(vertical: 16.0, horizontal: 16.0),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: const Key('profile-button-settings_button'),
                    text: AppLocalizations.of(context)!.settings,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const SettingsPage();
                          },
                        ),
                      ).then(
                        (value) {
                          if (value != null && value == true) {
                            setState(() {
                              userInformation = userInformation;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: const Key('profile-button-my_rentals_button'),
                    text: AppLocalizations.of(context)!.myRents,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const RentalPage();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                child: SizedBox(
                  width: double.infinity,
                  child: MyOutlinedButton(
                    key: const Key('profile-button-my_favorites_button'),
                    text: AppLocalizations.of(context)!.myFavorites,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return const FavoritePage();
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              const MyDivider(vertical: 16.0, horizontal: 16.0),
              SizedBox(
                width: double.infinity,
                child: MyOutlinedButton(
                  key: const Key('profile-button-log_out_button'),
                  text: AppLocalizations.of(context)!.logOut,
                  onPressed: () {
                    userInformation = null;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const LoginPage();
                        },
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
