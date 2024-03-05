import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';

class ShapeScreen extends StatefulWidget {
  const ShapeScreen({super.key});

  @override
  State<ShapeScreen> createState() => ShapeScreenState();
}

class ShapeScreenState extends State<ShapeScreen> {
  int row = 5;
  int column = 12;
  double width = 0;
  double height = 0;
  int nbLockers = 0;
  bool isRemoveClicked = false;

  @override
  void initState() {
    super.initState();
    //MyAlertTest.checkSignInStatus(context);
    calculateDimension();
  }

  void calculateDimension() {
    width = column / 2;
    height = row / 2;
    nbLockers = row * column * 2;
  }

  List<Widget> removeButtons() {
    List<Widget> buttons = [];

    if (isRemoveClicked == false) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              isRemoveClicked = true;
            });
          },
          child: const Text("Retirer un casier"),
        ),
      );
    } else {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              nbLockers -= 2;
              isRemoveClicked = false;
            });
          },
          child: const Text("Supprimer"),
        ),
      );
      buttons.add(
        ElevatedButton(
          onPressed: () {
            setState(() {
              isRemoveClicked = false;
            });
          },
          child: const Text('Annuler'),
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomAppBar(
        "Forme",
        context: context,
      ),
      body: Form(
        key: formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                const Text('Nombres de lignes'),
                TextFormField(
                  key: const Key('test'),
                  decoration: InputDecoration(
                    hintText: 'Entrez votre nom',
                    labelText: 'Nom',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    row = int.parse(value!);
                    calculateDimension();
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez remplir ce champ';
                    }
                    return null;
                  },
                ),
                const Text('Nombres de colonnes'),
                /*TextFormField(
                    onChanged: (String? value) {
                      setState(() {
                        column = int.parse(value!);
                        calculateDimension();
                      });
                    },
                  ),*/
              ],
            ),
            /*Row(
              children: removeButtons(),
            ),
            Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text('Largeur: $width mètres'),
                  Text('Hauteur: $height mètres'),
                  Text('Nombre de casiers: $nbLockers'),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
