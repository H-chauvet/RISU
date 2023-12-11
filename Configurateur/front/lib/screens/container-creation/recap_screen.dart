import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/services/theme_service.dart';
import 'package:provider/provider.dart';

import '../../components/recap_panel.dart';
import '../../styles/themes.dart';

class RecapScreen extends StatefulWidget {
  const RecapScreen({super.key, this.lockers});

  final List<Locker>? lockers;

  @override
  State<RecapScreen> createState() => RecapScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class RecapScreenState extends State<RecapScreen> {
  void previousFunc() {
    Navigator.pop(context);
  }

  void nextFunc() {
    Navigator.pushNamed(context, '/container-creation/confirmation');
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
            length: 5,
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
                    itemCount: widget.lockers!.length,
                    itemBuilder: (_, i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10, bottom: 10),
                            child: Text(
                              widget.lockers![i].type,
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10, bottom: 10),
                            child: Text(
                              "${widget.lockers![i].price.toString()}€",
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
