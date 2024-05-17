import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../styles/themes.dart';

/// RecapScreen
///
/// Screen of the summary in the container (lockers, price, container's informations)
/// [lockers] : All the lockers of the container
/// [amount] : Price of the container
/// [containerMapping] : ???
/// [container] : Informations about the container
/// [id] : User's Id
class RecapScreen extends StatefulWidget {
  const RecapScreen(
      {super.key,
      this.lockers,
      this.amount,
      this.containerMapping,
      this.id,
      this.container});

  final String? lockers;
  final int? amount;
  final String? containerMapping;
  final String? id;
  final String? container;

  @override
  State<RecapScreen> createState() => RecapScreenState();
}

/// RecapScreenState
///
class RecapScreenState extends State<RecapScreen> {
  List<Locker> lockerss = [];

  /// [Function] : Go to the previous page
  void previousFunc() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': jsonEncode(lockerss),
      'container': widget.container,
      'id': widget.id,
    };
    context.go('/container-creation/design', extra: jsonEncode(data));
  }

  /// [Function] : Go to the next page
  void nextFunc() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': jsonEncode(lockerss),
      'id': widget.id,
      'container': widget.container,
    };
    context.go('/container-creation/maps', extra: jsonEncode(data));
  }

  /// [Function] : Decode the lockers' informations in json
  void decodeLockers() {
    final decode = jsonDecode(widget.lockers!);

    for (int i = 0; i < decode.length; i++) {
      lockerss.add(Locker(decode[i]['type'], decode[i]['price']));
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.lockers != null) {
      decodeLockers();
    }
  }

  /// [Widget] : Build of the container's summary page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        'Récapitulatif',
        context: context,
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            length: 6,
            progress: 3,
            previous: 'Précédent',
            next: 'Suivant',
            previousFunc: previousFunc,
            nextFunc: nextFunc,
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.5,
          heightFactor: 0.7,
          child: Container(
            alignment: Alignment.center,
            decoration: Provider.of<ThemeService>(context).isDark
                ? boxDecorationDarkTheme
                : boxDecorationLightTheme,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Récapitulatif de la commande",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                const SizedBox(
                  width: 200,
                  child: Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FractionallySizedBox(
                  widthFactor: 0.3,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: lockerss.length,
                    itemBuilder: (_, i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              lockerss[i].type,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Text(
                              "${lockerss[i].price.toString()}€",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  width: 200,
                  child: Divider(
                    color: Colors.grey,
                    height: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Prix total: ${widget.amount}€",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
