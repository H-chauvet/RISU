import 'package:flutter/material.dart';
import 'package:front/main.dart';

class RegisterConfirmation extends StatefulWidget {
  const RegisterConfirmation({super.key});

  @override
  State<RegisterConfirmation> createState() => RegisterConfirmationState();
}

class RegisterConfirmationState extends State<RegisterConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Confirmation d'inscription",
            style: TextStyle(fontSize: 40),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xff4682B4),
          toolbarHeight: MediaQuery.of(context).size.height / 8,
          leading: Container(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(1920, 56.0),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Image.asset("logo.png"),
              iconSize: 80,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(title: 'tile')));
              },
            ),
          ],
        ),
        body: Center(
            child: FractionallySizedBox(
                widthFactor: 0.3,
                heightFactor: 0.7,
                child: Column(
                  children: [
                    const Text(
                      "Afin de finaliser l'inscription de votre compte, merci de confirmer cette dernière grâce au lien que vous avez reçu par mail.",
                      style: TextStyle(fontSize: 26),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 80.0,
                    ),
                    const Text(
                      "Vous n'avez pas reçu le mail de confirmation ?",
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 35.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MyHomePage(title: 'tile')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4682B4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        child: const Text(
                          "Renvoyer le mail de confirmation",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: 'tile')));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Text(
                                "Retour à l'acceuil",
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
