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
  int iteration = 0;
  late List<Widget> container = initContainer();
  List<bool> isClicked = List.generate(60, (index) => false);

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
              isClicked = List.generate(60, (index) => false);
              isRemoveClicked = false;
            });
          },
          child: const Text('Annuler'),
        ),
      );
    }

    return buttons;
  }

  List<Widget> initContainer() {
    List<Widget> rows = [];
    List<Widget> line = [];

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        j == 0
            ? line.add(
                Container(
                  width: 2.0,
                  height: 52.0,
                  color: Colors.black,
                ),
              )
            : Container();
        line.add(
          Column(
            children: [
              i == 0
                  ? Container(
                      width: 52.0,
                      height: 2.0,
                      color: Colors.black,
                    )
                  : Container(),
              InkWell(
                onTap: () => {
                  debugPrint('test'),
                  debugPrint((i * column + j).toString()),
                  if (isRemoveClicked == true)
                    {
                      setState(() {
                        isClicked[(i * column) + j] =
                            !isClicked[(i * column) + j];
                      })
                    }
                },
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  alignment: Alignment.topRight,
                  child: isRemoveClicked
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 5.0,
                                ),
                              ),
                              color: isClicked[(i * column) + j]
                                  ? Colors.red
                                  : Colors.grey[200],
                              width: 15,
                              height: 15,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              Container(width: 52.0, height: 2.0, color: Colors.black),
            ],
          ),
        );

        line.add(
          Container(
            width: 2.0,
            height: 52.0,
            color: Colors.black,
          ),
        );
      }
      rows.add(Row(
        children: line,
      ));
      line = [];
    }
    return rows;
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
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('Nombres de lignes'),
                  Flexible(
                    child: SizedBox(
                      width: 200,
                      child: TextFormField(
                        key: const Key('Row'),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Lignes',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        initialValue: row.toString(),
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
                    ),
                  ),
                  const Text('Nombres de colonnes'),
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      key: const Key('Column'),
                      initialValue: column.toString(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Colonnes',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onSaved: (String? value) {
                        setState(
                          () {
                            column = int.parse(value!);
                            calculateDimension();
                          },
                        );
                      },
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez remplir ce champ';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 650,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: removeButtons(),
                  ),
                  Column(
                    children: initContainer(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 250,
              child: Container(
                color: Colors.grey[200],
                child: Column(
                  children: [
                    Text('Largeur: $width mètres'),
                    Text('Hauteur: $height mètres'),
                    Text('Nombre de casiers: $nbLockers'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
