import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';
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
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
      appBar: CustomAppBar(
        "Confirmation de sauvegarde",
        context: context,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Votre conteneur a bien été sauvegardé",
              style: TextStyle(
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopBigFontSize
                    : tabletBigFontSize,
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
              child: Text(
                "Retour à l'accueil",
                style: TextStyle(
                  fontSize: screenFormat == ScreenFormat.desktop
                      ? desktopFontSize
                      : tabletFontSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
