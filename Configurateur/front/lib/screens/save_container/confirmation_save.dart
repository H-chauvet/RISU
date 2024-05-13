import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

/// Widget représentant le page de confirmation de la sauvegarde dans le configurateur.
class ConfirmationSave extends StatefulWidget {
  const ConfirmationSave({super.key});

  @override
  State<ConfirmationSave> createState() => ConfirmationSaveState();
}

/// État de la page de confirmation de sauvegarde du conteneur.
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
