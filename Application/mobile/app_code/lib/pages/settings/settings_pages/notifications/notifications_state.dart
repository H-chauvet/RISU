import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/divider.dart';
import 'package:risu/components/filled_button.dart';
import 'package:risu/components/toast.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/theme.dart';

import 'notifications_page.dart';

class NotificationsPageState extends State<NotificationsPage> {
  static bool isFavoriteItemsAvailableChecked =
      userInformation!.notifications?[0] ?? false;

  static bool isEndOfRentingChecked =
      userInformation!.notifications?[1] ?? false;
  static bool isNewsOffersChecked = userInformation!.notifications?[2] ?? false;
  static bool isAllChecked = false;

  @override
  void initState() {
    super.initState();
  }

  Future<http.Response?> saveNotifications() async {
    try {
      final response = await http.put(
        Uri.parse('http://$serverIp:8080/api/user/notifications'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${userInformation!.token}',
        },
        body: jsonEncode({
          'favoriteItemsAvailable': isFavoriteItemsAvailableChecked,
          'endOfRenting': isEndOfRentingChecked,
          'newsOffersRisu': isNewsOffersChecked,
        }),
      );
      if (response.statusCode == 200) {
        setState(() {
          userInformation!.notifications = [
            isFavoriteItemsAvailableChecked,
            isEndOfRentingChecked,
            isNewsOffersChecked
          ];
        });
        return response;
      } else {
        print('Error saveNotifications: ${response.statusCode}');
        if (context.mounted) {
          await MyAlertDialog.showErrorAlertDialog(
            context: context,
            title: 'Notifications',
            message:
                'A server error occurred when trying to save notifications.',
          );
        }
      }
    } catch (err) {
      print('Error saveNotifications: $err');
      if (context.mounted) {
        await MyAlertDialog.showErrorAlertDialog(
          context: context,
          title: 'Notifications',
          message: 'An error occurred when tying to save notifications.',
        );
      }
    }
    return null;
  }

  static Widget createSwitch(
      Key key, String text, bool value, Function(bool) onChanged) {
    const Color activeColor = Colors.green;
    final MaterialStateProperty<Icon?> thumbIcon =
        MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );
    final MaterialStateProperty<Color?> trackOutlineColor =
        MaterialStateProperty.resolveWith<Color?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return activeColor.withOpacity(0.5);
        }
        return Colors.red.withOpacity(0.5);
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
        const Expanded(child: SizedBox()),
        Switch(
          key: key,
          value: value,
          onChanged: onChanged,
          inactiveThumbColor: Colors.red,
          inactiveTrackColor: Colors.red[200],
          activeColor: activeColor,
          thumbIcon: thumbIcon,
          trackOutlineColor: trackOutlineColor,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    isAllChecked = isFavoriteItemsAvailableChecked &&
        isEndOfRentingChecked &&
        isNewsOffersChecked;
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select(
          (ThemeProvider themeProvider) =>
              themeProvider.currentTheme.secondaryHeaderColor,
        ),
        showBackButton: true,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: context.select(
        (ThemeProvider themeProvider) =>
            themeProvider.currentTheme.colorScheme.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Gestion des notifications',
              style: TextStyle(
                fontSize: 32, // Taille de la police
                fontWeight: FontWeight.bold, // Gras
                color: Color(0xFF4682B4),
              ),
            ),
            const SizedBox(height: 20),
            createSwitch(
              const Key('notifications-switch_disponibility_favorite'),
              "Disponibilité d'un article favoris",
              isFavoriteItemsAvailableChecked,
              (newValue) =>
                  setState(() => isFavoriteItemsAvailableChecked = newValue),
            ),
            createSwitch(
              const Key('notifications-switch_end_renting'),
              "Fin de ma location",
              isEndOfRentingChecked,
              (newValue) => setState(() => isEndOfRentingChecked = newValue),
            ),
            const MyDivider(),
            createSwitch(
              const Key('notifications-switch_news_offers_risu'),
              "Actus, offres et conseils de Risu",
              isNewsOffersChecked,
              (newValue) => setState(() => isNewsOffersChecked = newValue),
            ),
            const MyDivider(),
            createSwitch(
              const Key('notifications-switch_all'),
              "Tous",
              isAllChecked,
              (newValue) => {
                setState(() {
                  isAllChecked = newValue;
                  isFavoriteItemsAvailableChecked = newValue;
                  isEndOfRentingChecked = newValue;
                  isNewsOffersChecked = newValue;
                })
              },
            ),
            // Put the button at the bottom of the screen
            const Expanded(child: SizedBox()),
            MyButton(
              key: const Key('notifications-button_save'),
              text: "Enregistrer",
              onPressed: () => saveNotifications().then(
                (response) => {
                  if (response != null && response.statusCode == 200)
                    {
                      MyToastMessage.show(
                        context: context,
                        message: 'Notifications enregistrées.',
                      ),
                    },
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}