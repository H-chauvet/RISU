import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/services/size_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:go_router/go_router.dart';

import 'confirmation_screen_style.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => ConfirmationScreenState();
}

///
/// Password change screen
///
/// page de confirmation d'enregistrement pour le configurateur
class ConfirmationScreenState extends State<ConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    return Scaffold(
        appBar: CustomAppBar(
          "Confirmation de commande",
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: screenFormat == ScreenFormat.desktop
                    ? desktopWidthFactor
                    : tabletWidthFactor,
                heightFactor: 0.7,
                child: Column(
                  children: [
                    Text(
                      "Votre commande a bien été confirmée, vous pouvez maintenant retournez à l'accueil et nous vous contacterons dès que votre commande sera prête",
                      style: TextStyle(
                        fontSize: screenFormat == ScreenFormat.desktop
                            ? desktopBigFontSize
                            : tabletBigFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    InkWell(
                      key: const Key('go-home'),
                      onTap: () {
                        context.go("/");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Retour à l'accueil",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ))));
  }
}
