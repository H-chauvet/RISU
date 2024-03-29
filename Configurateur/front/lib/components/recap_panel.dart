import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

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

class LockerList {
  String type;
  int price;
  int quantity;

  LockerList(this.type, this.price, this.quantity);
}

///
/// RecapPanel
///
// ignore: must_be_immutable
class RecapPanel extends StatelessWidget {
  RecapPanel({super.key, this.articles, required this.onSaved});

  int sumPrice() {
    int price = 0;
    for (int i = 0; i < articles!.length; i++) {
      price += articles![i].price;
    }
    return price;
  }

  final List<Locker>? articles;
  late List<LockerList> parsedArticles = parseArticles();
  late int? price = sumPrice();
  final Function() onSaved;

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
        100 * littleCount,
        littleCount,
      ));
    }
    if (mediumCount > 0) {
      parsedLockers.add(LockerList(
        "Moyen Casier",
        200 * mediumCount,
        mediumCount,
      ));
    }
    if (bigCount > 0) {
      parsedLockers.add(LockerList(
        "Grand Casier",
        300 * bigCount,
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

  Widget articlesContent() {
    if (parsedArticles.isEmpty) {
      return const Center(
        child: Text(
          "Aucun article dans le panier",
          style: TextStyle(
            color: Colors.black,
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
                constraints: const BoxConstraints(minWidth: 140, maxWidth: 140),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    parsedArticles[i].type,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 10),
                child: Text(
                  parsedArticles[i].quantity.toString(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 100),
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, bottom: 10),
                  child: Text(
                    "${parsedArticles[i].price.toString()}€",
                    style: const TextStyle(color: Colors.black),
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
            const Center(
              child: Text(
                'Panier',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints:
                          const BoxConstraints(minWidth: 140, maxWidth: 140),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          'Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'Quantité',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      constraints: const BoxConstraints(minWidth: 100),
                      child: const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text(
                          'Prix',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
              indent: 30,
              endIndent: 30,
            ),
            const SizedBox(
              height: 10,
            ),
            articlesContent(),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 1,
              indent: 30,
              endIndent: 30,
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: Text('Total: ${price!}€'),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
