import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/services/theme_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../styles/themes.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen(
      {super.key, this.lockers, this.amount, this.containerMapping, this.id});

  final String? lockers;
  final int? amount;
  final String? containerMapping;
  final String? id;

  @override
  State<RecapScreen> createState() => RecapScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class RecapScreenState extends State<RecapScreen> {
  List<Locker> lockerss = [];

  void previousFunc() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': jsonEncode(lockerss),
    };
    context.go('/container-creation/design', extra: jsonEncode(data));
  }

  void nextFunc() {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'id': widget.id,
    };
    context.go('/container-creation/payment', extra: jsonEncode(data));
  }

  void decodeLockers() {
    final decode = jsonDecode(widget.lockers!);

    for (int i = 0; i < decode.length; i++) {
      lockerss.add(Locker(decode[i]['type'], decode[i]['price']));
    }
    debugPrint(lockerss.toString());
  }

  @override
  void initState() {
    super.initState();

    if (widget.lockers != null) {
      decodeLockers();
    }
  }

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
            length: 4,
            progress: 2,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
