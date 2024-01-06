import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
        appBar: CustomAppBar(
          "Confirmation de commande",
          context: context,
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.7,
                child: Column(
                  children: [
                    const Text(
                      "Votre commande a bien été confirmée, vous pouvez maintenant retournez à l'accueil et nous vous contacterons dès que votre commande sera prête",
                      style: TextStyle(fontSize: 26),
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
