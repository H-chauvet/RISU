import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/text_input.dart';
import 'package:risu/globals.dart';
import 'package:risu/utils/theme.dart';
import 'package:intl/intl.dart';

import 'rental_page.dart';

class RentalPageState extends State<RentalPage> {
  List<dynamic> rentals = [];
  List<dynamic> rentalsInProgress = [];
  bool showAllRentals = true;

  String formatDateTime(String dateTimeString) {
    DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  void getRentals() async {
    try {
      final token = userInformation!.token;
      final response = await http.get(
        Uri.parse('http://$serverIp:8080/api/rent'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '$token',
        },
      );
      if (response.statusCode == 201) {
        setState(() {
          rentals = jsonDecode(response.body)['rentals'];
          print(rentals);
        });
      } else {
        print('Error getRentals(): ${response.statusCode}');
      }
    } catch (e) {
      print('Error getRentals(): $e');
    }
  }

  String calculateRemainingTime(dynamic rental) {
    DateTime rentalStart = DateTime.parse(rental['createdAt']);
    int rentalDuration = rental['duration'];
    DateTime rentalEnd = rentalStart.add(Duration(hours: rentalDuration));
    Duration remainingTime = rentalEnd.difference(DateTime.now());

    int hours = remainingTime.inHours;
    int minutes = remainingTime.inMinutes.remainder(60);

    return '$hours heures et $minutes minutes';
  }

  bool isRentalInProgress(dynamic rental) {
    if (rental['createdAt'] != null && rental['duration'] != null) {
      DateTime rentalStart = DateTime.parse(rental['createdAt']);
      int rentalDuration = rental['duration'];
      DateTime rentalEnd = rentalStart.add(Duration(hours: rentalDuration));

      return rentalEnd.isAfter(DateTime.now());
    }

    return false;
  }

  void getRentalsInProgress() {
    try {
      setState(() {
        this.rentalsInProgress = rentals.where(isRentalInProgress).toList();
      });
    } catch (e) {
      print('Error getRentalsInProgress(): $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getRentals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        curveColor: context.select((ThemeProvider themeProvider) =>
            themeProvider.currentTheme.secondaryHeaderColor),
        showBackButton: false,
        showLogo: true,
        showBurgerMenu: false,
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: context.select((ThemeProvider themeProvider) =>
          themeProvider.currentTheme.colorScheme.background),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                'Mes locations',
                key: const Key('my-rentals-title'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: context.select((ThemeProvider themeProvider) =>
                      themeProvider.currentTheme.secondaryHeaderColor),
                  shadows: [
                    Shadow(
                      color: context.select((ThemeProvider themeProvider) =>
                          themeProvider.currentTheme.secondaryHeaderColor),
                      blurRadius: 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      getRentalsInProgress();
                      setState(() {
                        showAllRentals = true;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints.expand(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 30, // hauteur du bouton
                        ),
                        decoration: BoxDecoration(
                          color: showAllRentals
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).secondaryHeaderColor,
                        ),
                        child: Center(
                          child: Text(
                            'Toutes',
                            style: TextStyle(
                              color: showAllRentals
                                  ? Colors.white
                                  : Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[
                                          400] // Gris foncé pour le mode clair
                                      : Colors.grey[
                                          800], // Gris clair pour le mode sombre
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getRentalsInProgress();
                      setState(() {
                        showAllRentals = false;
                      });
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints.expand(
                          width: MediaQuery.of(context).size.width / 3,
                          height: 30, // hauteur du bouton
                        ),
                        decoration: BoxDecoration(
                          color: !showAllRentals
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).secondaryHeaderColor,
                        ),
                        child: Center(
                          child: Text(
                            'En cours',
                            style: TextStyle(
                              color: !showAllRentals
                                  ? Colors.white
                                  : Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[
                                          400] // Gris foncé pour le mode clair
                                      : Colors.grey[
                                          800], // Gris clair pour le mode sombre
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: (showAllRentals ? rentals : rentalsInProgress).isEmpty
                    ? const Center(
                        child: Text(
                          'Aucune location',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: showAllRentals
                            ? rentals.length
                            : rentalsInProgress.length,
                        itemBuilder: (BuildContext context, int index) {
                          dynamic rental = showAllRentals
                              ? rentals[index]
                              : rentalsInProgress[index];
                          return Card(
                            elevation: 5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Theme.of(context).cardColor,
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16.0),
                              title: const Text(
                                'Ballon de volley' +
                                    '  |  La Baule - Casier N°A4',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  Text('Prix : ${rental['price']} €'),
                                  Text(
                                    'Début de location : ${formatDateTime(rental['createdAt'])}',
                                  ),
                                  Text(
                                    'Durée de location : ${rental['duration']} heures\n'
                                    'Status : ${isRentalInProgress(rental) ? 'En cours' : 'Terminé'}'
                                    '${isRentalInProgress(rental) ? '\nTemps restant : ${calculateRemainingTime(rental)}' : ''}',
                                  ),
                                ],
                              ),
                            ),
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
