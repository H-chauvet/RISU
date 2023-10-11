import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:go_router/go_router.dart';

class DesignCreation extends StatefulWidget {
  const DesignCreation({super.key});

  @override
  State<DesignCreation> createState() => DesignCreationState();
}

///
/// DesignCreation
///
/// page d'inscription pour le configurateur
class DesignCreationState extends State<DesignCreation> {
  void goNext() {
    context.go("/");
  }

  void goPrevious() {
    Navigator.pushNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Design',
          context: context,
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 2,
              progress: 1,
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
        body: const SizedBox(
          height: 20,
        ));
  }
}
