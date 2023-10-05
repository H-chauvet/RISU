import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/screens/container-creation/design_creation.dart';
import 'package:front/screens/landing-page/landing_page.dart';

class ContainerCreation extends StatefulWidget {
  const ContainerCreation({super.key});

  @override
  State<ContainerCreation> createState() => ContainerCreationState();
}

///
/// ContainerCreation
///
/// page d'inscription pour le configurateur
class ContainerCreationState extends State<ContainerCreation> {
  void goNext() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const DesignCreation()));
  }

  void goPrevious() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Configurateur',
          context: context,
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 2,
              progress: 0,
              previous: 'Précédent',
              next: 'Suivant',
              previousFunc: goPrevious,
              nextFunc: goNext,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
        body: Row(
          children: const [
            SizedBox(
              width: 50,
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                    widthFactor: 0.35,
                    heightFactor: 0.7,
                    child: InteractivePanel()),
              ),
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                    widthFactor: 0.35,
                    heightFactor: 0.7,
                    child: RecapPanel(
                      price: 1000,
                      articles: ['Casier 1', 'Casier 2'],
                    )),
              ),
            ),
            SizedBox(
              width: 50,
            )
          ],
        ));
  }
}
