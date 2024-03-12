import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';

import '../../components/progress_bar.dart';

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
  List<Color?> colors = List.generate(60, (index) => Colors.grey[200]);

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
    if (colors.length < row * column) {
      for (int i = colors.length; i < row * column; i++) {
        colors.add(Colors.grey[200]);
      }
    }
    if (isClicked.length < row * column) {
      for (int i = isClicked.length; i < row * column; i++) {
        isClicked.add(false);
      }
    }
  }

  void removeLockers() {
    for (int i = 0; i < isClicked.length; i++) {
      if (isClicked[i] == true) {
        nbLockers -= 2;
        colors[i] = Colors.grey[600];
        isClicked[i] = false;
      }
    }
  }

  List<Widget> removeButtons() {
    List<Widget> buttons = [];

    if (isRemoveClicked == false) {
      buttons.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            setState(() {
              isRemoveClicked = true;
            });
          },
          child: const Text("Retirer un casier"),
        ),
      );
    } else {
      buttons.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              setState(() {
                removeLockers();
                isRemoveClicked = false;
              });
            },
            child: const Text("Supprimer"),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              setState(() {
                isClicked = List.generate(60, (index) => false);
                isRemoveClicked = false;
              });
            },
            child: const Text('Annuler'),
          ),
        ],
      ));
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              i == 0
                  ? Container(
                      width: 50.0,
                      height: 2.0,
                      color: Colors.black,
                    )
                  : Container(),
              InkWell(
                onTap: () => {
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
                  color: colors[i * column + j],
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
                                  width: 1.0,
                                ),
                                color: isClicked[(i * column) + j]
                                    ? Colors.red
                                    : Colors.grey[200],
                              ),
                              width: 15,
                              height: 15,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              Container(width: 50.0, height: 2.0, color: Colors.black),
            ],
          ),
        );

        line.add(
          Container(
            width: 2.0,
            height: 50.0,
            color: Colors.black,
          ),
        );
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: line,
      ));
      line = [];
    }
    return rows;
  }

  void goPrevious() {
    context.go('/');
  }

  void goNext() {
    String containerMapping = '';

    debugPrint(isClicked.length.toString());
    for (int i = 0; i < colors.length; i++) {
      if (colors[i] == Colors.grey[600]) {
        int actualColumn = (i % column);
        int actualRow = (i ~/ column);
        debugPrint('col ' + actualColumn.toString());
        debugPrint('row ' + actualRow.toString());
        int diffToBottom = 0;
        int tmp = i;
        for (; true;) {
          if (tmp > 0) {
            tmp -= column;
            diffToBottom++;
          } else {
            break;
          }
        }

        debugPrint('bottom ' + diffToBottom.toString());

        diffToBottom--;

        int rowToUp = (row - actualRow) - (diffToBottom);

        if (diffToBottom + actualRow == row - 1) {
          rowToUp = 0;
        }

        debugPrint('to up ' + rowToUp.toString());

        int index = actualColumn + (rowToUp * column);

        debugPrint('index ' + index.toString());

        containerMapping += '${index},${index + (row * column)},';
      }
    }
    //debugPrint(containerMapping);
    context.go('/container-creation',
        extra: jsonEncode({'containerMapping': containerMapping}));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: CustomAppBar(
        "Forme",
        context: context,
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            length: 5,
            progress: 0,
            previous: 'Précédent',
            next: 'Payer',
            previousFunc: goPrevious,
            nextFunc: goNext,
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Nombres de lignes'),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          row--;
                          colors = List.generate(
                              column * row, (index) => Colors.grey[200]);
                          isClicked =
                              List.generate(column * row, (index) => false);
                          calculateDimension();
                        });
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[200],
                      ),
                      child: Text(row.toString()),
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          row++;
                          colors = List.generate(
                              column * row, (index) => Colors.grey[200]);
                          isClicked =
                              List.generate(column * row, (index) => false);
                          calculateDimension();
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text('Nombres de colonnes'),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          column--;
                          colors = List.generate(
                              column * row, (index) => Colors.grey[200]);
                          isClicked =
                              List.generate(column * row, (index) => false);
                          calculateDimension();
                        });
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.grey[200],
                      ),
                      child: Text(column.toString()),
                    ),
                    const SizedBox(width: 10.0),
                    InkWell(
                      onTap: () {
                        setState(() {
                          column++;
                          colors = List.generate(
                              column * row, (index) => Colors.grey[200]);
                          isClicked =
                              List.generate(column * row, (index) => false);
                          calculateDimension();
                        });
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: removeButtons(),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: initContainer(),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 250,
              height: 300,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.grey[200],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Largeur:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$width mètres'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Hauteur:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$height mètres'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          "Nombre d'emplacements:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('$nbLockers'),
                      ],
                    ),
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
