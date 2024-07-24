import 'package:flutter/material.dart';
import 'package:front/components/recap_panel/recap_panel_style.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

///
/// Locker
///
/// Define the type and the price of a locker
///
/// [type] : Change if the locker is big, medium or small
/// [price] : Price of a locker
class Locker {
  String type;
  int price;

  Locker(this.type, this.price);

  Map<String, dynamic> toJson() {
    return {
      "type": type,
      "price": price,
    };
  }
}

/// LockerList
///
/// List of [Locker]
/// [type] : Change if the locker is big, medium or small
/// [price] : Price of a locker
/// [quantity] : quantity of lockers in container
///
class LockerList {
  String type;
  int price;
  int quantity;

  LockerList(this.type, this.price, this.quantity);
}

///
/// RecapPanel
///
/// Summary of the lockers selected in a container
// ignore: must_be_immutable
class RecapPanel extends StatelessWidget {
  RecapPanel(
      {super.key,
      this.articles,
      required this.screenFormat,
      required this.fullscreen});

  /// [Function] : Calculating the price of lockers
  /// return the total price
  int sumPrice() {
    int price = 0;
    for (int i = 0; i < articles!.length; i++) {
      price += articles![i].price;
    }
    return price;
  }

  final List<Locker>? articles;
  late List<LockerList> parsedArticles = parseArticles();
  final bool fullscreen;
  late int? price = sumPrice();
  final ScreenFormat screenFormat;

  /// [Function] : Parsing all the articles of container
  List<LockerList> parseArticles() {
    List<LockerList> parsedLockers = [];
    int littleCount = 0;
    int mediumCount = 0;
    int bigCount = 0;
    int designCount = 0;

    for (int i = 0; i < articles!.length; i++) {
      if (articles![i].type == "Petit casier") {
        littleCount++;
      } else if (articles![i].type == "Moyen casier") {
        mediumCount++;
      } else if (articles![i].type == "Grand casier") {
        bigCount++;
      } else if (articles![i].type == "Design personnalisé") {
        designCount++;
      }
    }
    if (littleCount > 0) {
      parsedLockers.add(LockerList(
        "Petit Casier",
        50 * littleCount,
        littleCount,
      ));
    }
    if (mediumCount > 0) {
      parsedLockers.add(LockerList(
        "Moyen Casier",
        100 * mediumCount,
        mediumCount,
      ));
    }
    if (bigCount > 0) {
      parsedLockers.add(LockerList(
        "Grand Casier",
        150 * bigCount,
        bigCount,
      ));
    }
    if (designCount > 0) {
      parsedLockers.add(LockerList(
        "Design personnalisé",
        50 * designCount,
        designCount,
      ));
    }
    return parsedLockers;
  }

  /// [Widget] : Show the articles' content
  Widget articlesContent(BuildContext context) {
    if (parsedArticles.isEmpty) {
      return Center(
        child: Text(
          "Aucun article dans le panier",
          style: TextStyle(
            color: Provider.of<ThemeService>(context).isDark
                ? darkTheme.primaryColor
                : lightTheme.primaryColor,
            fontSize: screenFormat == ScreenFormat.desktop
                ? desktopFontSize
                : tabletFontSize,
          ),
        ),
      );
    } else {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: parsedArticles.length,
        itemBuilder: (_, i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                constraints: BoxConstraints(
                    minWidth: fullscreen == true
                        ? fullScreenBoxConstraints
                        : boxConstraints,
                    maxWidth: fullscreen == true
                        ? fullScreenBoxConstraints
                        : boxConstraints),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    parsedArticles[i].type,
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
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Text(
                  parsedArticles[i].quantity.toString(),
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
              Container(
                constraints: BoxConstraints(
                    minWidth: fullscreen == true
                        ? fullScreenLittleBoxConstraints
                        : littleBoxConstraints),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    "${parsedArticles[i].price.toString()}€",
                    style: TextStyle(
                      color: Provider.of<ThemeService>(context).isDark
                          ? darkTheme.primaryColor
                          : lightTheme.primaryColor,
                      fontSize: screenFormat == ScreenFormat.desktop
                          ? desktopFontSize
                          : tabletFontSize,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  /// [Widget] : build the recap panel
  @override
  Widget build(BuildContext context) {
    parseArticles();
    return Container(
        decoration: Provider.of<ThemeService>(context).isDark
            ? boxDecorationDarkTheme
            : boxDecorationLightTheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Panier',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.primaryColor
                      : lightTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                          minWidth: fullscreen == true
                              ? fullScreenBoxConstraints
                              : boxConstraints,
                          maxWidth: fullscreen == true
                              ? fullScreenBoxConstraints
                              : boxConstraints),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Type',
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Text(
                        'Quantité',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(
                          minWidth: fullscreen == true
                              ? fullScreenLittleBoxConstraints
                              : littleBoxConstraints),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          'Prix',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor
                                : lightTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: screenFormat == ScreenFormat.desktop
                                ? desktopFontSize
                                : tabletFontSize,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            articlesContent(context),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text('Total: ${price!}€',
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                    fontSize: screenFormat == ScreenFormat.desktop
                        ? desktopFontSize
                        : tabletFontSize,
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
