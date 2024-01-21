import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

class ConfirmationSave extends StatefulWidget {
  const ConfirmationSave({super.key});

  @override
  State<ConfirmationSave> createState() => ConfirmationSaveState();
}

///
/// Password change screen
///
/// page de confirmation d'enregistrement pour le configurateur
class ConfirmationSaveState extends State<ConfirmationSave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        "Confirmation de sauvegarde",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Votre conteneur a bien été sauvegardé",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                context.go('/');
              },
              child: const Text("Retour à l'accueil"),
            ),
          ],
        ),
      ),
    );
  }
}
