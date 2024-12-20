import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:risu/components/appbar.dart';
import 'package:risu/components/loader.dart';
import 'package:risu/components/pop_scope_parent.dart';
import 'package:risu/components/staggered_list.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/rent/rentals/rentals_list_card.dart';
import 'package:risu/utils/check_signin.dart';
import 'package:risu/utils/errors.dart';
import 'package:risu/utils/providers/theme.dart';

import 'rentals_page.dart';

class RentalPageState extends State<RentalPage> {
  List<dynamic> rentals = [];
  List<dynamic> rentalsInProgress = [];
  List<dynamic> pastRentals = [];
  bool showRentalsInProgress = true;
  late bool appbar;
  final LoaderManager _loaderManager = LoaderManager();

  @override
  void initState() {
    super.initState();

    appbar = widget.appbar;
    if (widget.testRentals.isEmpty) {
      getRentals();
    } else {
      setState(() {
        rentals = widget.testRentals;
      });
    }
  }

  void getRentals() async {
    try {
      setState(() {
        _loaderManager.setIsLoading(true);
      });
      final token = userInformation!.token;
      final response = await http.get(
        Uri.parse('$baseUrl/api/mobile/rent/listAll'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      setState(() {
        _loaderManager.setIsLoading(false);
      });
      switch (response.statusCode) {
        case 200:
          setState(() {
            rentals = jsonDecode(response.body)['rentals'];
          });
          getRentalsInProgress();
          return;
        case 401:
          await tokenExpiredShowDialog(context);
          break;
        default:
          if (mounted) {
            printServerResponse(context, response, 'getRentals',
                message: AppLocalizations.of(context)!
                    .errorOccurredDuringGettingRents);
          }
      }
    } catch (err, stacktrace) {
      if (mounted) {
        setState(() {
          _loaderManager.setIsLoading(false);
        });
        printCatchError(context, err, stacktrace);
        return;
      }
      return;
    }
  }

  /// isRentalInProgress is a function that returns true if the rental is in progress
  /// params:
  /// [rental] - the rental
  bool isRentalInProgress(dynamic rental) {
    if (rental['createdAt'] != null &&
        rental['duration'] != null &&
        rental['ended'] == false) {
      DateTime rentalStart = DateTime.parse(rental['createdAt']);
      int rentalDuration = rental['duration'];
      DateTime rentalEnd = rentalStart.add(Duration(hours: rentalDuration));
      return rentalEnd.isAfter(DateTime.now());
    }
    return false;
  }

  void getRentalsInProgress() async {
    try {
      setState(() {
        rentalsInProgress = rentals.where(isRentalInProgress).toList();
      });
    } catch (err, stacktrace) {
      printCatchError(context, err, stacktrace,
          message: AppLocalizations.of(context)!
              .errorOccurredDuringGettingRentsInProgress);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MyPopScope(
      child: Scaffold(
        appBar: (appbar)
            ? MyAppBar(
                curveColor: themeProvider.currentTheme.secondaryHeaderColor,
                showBackButton: false,
                textTitle: AppLocalizations.of(context)!.myRents,
              )
            : null,
        resizeToAvoidBottomInset: false,
        backgroundColor: themeProvider.currentTheme.colorScheme.surface,
        body: (_loaderManager.getIsLoading())
            ? Center(child: _loaderManager.getLoader())
            : Center(
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (appbar == false) ...[
                        const SizedBox(height: 30),
                        Text(
                          AppLocalizations.of(context)!.myRents,
                          key: const Key('my-rents-titles'),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: themeProvider.currentTheme.primaryColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              getRentalsInProgress();
                              setState(() {
                                showRentalsInProgress = true;
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
                                  color: showRentalsInProgress
                                      ? themeProvider.currentTheme.primaryColor
                                      : themeProvider
                                          .currentTheme.secondaryHeaderColor,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.inProgress,
                                    style: TextStyle(
                                      color: showRentalsInProgress
                                          ? themeProvider
                                              .currentTheme.secondaryHeaderColor
                                          : themeProvider.currentTheme
                                                      .brightness ==
                                                  Brightness.light
                                              ? Colors.grey[800]
                                              // Gris foncé pour le mode clair
                                              : Colors.grey[400],
                                      // Gris clair pour le mode sombre
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
                                showRentalsInProgress = false;
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
                                  color: !showRentalsInProgress
                                      ? themeProvider.currentTheme.primaryColor
                                      : themeProvider
                                          .currentTheme.secondaryHeaderColor,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.allE,
                                    style: TextStyle(
                                      color: !showRentalsInProgress
                                          ? themeProvider
                                              .currentTheme.secondaryHeaderColor
                                          : themeProvider.currentTheme
                                                      .brightness ==
                                                  Brightness.light
                                              ? Colors.grey[
                                                  800] // Gris foncé pour le mode clair
                                              : Colors.grey[400],
                                      // Gris clair pour le mode sombre
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
                        key: const Key('rentals-list'),
                        child: (showRentalsInProgress
                                    ? rentalsInProgress
                                    : rentals)
                                .isEmpty
                            ? Center(
                                child: Text(
                                  AppLocalizations.of(context)!.rentsListEmpty,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : StaggeredList(
                                itemCount: showRentalsInProgress
                                    ? rentalsInProgress.length
                                    : rentals.length,
                                itemBuilder: (BuildContext context, int index) {
                                  dynamic rental = showRentalsInProgress
                                      ? rentalsInProgress[index]
                                      : rentals[index];
                                  return RentalCard(rental: rental);
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
