import 'package:flutter/material.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

/// [faceList] : show the selected face of the container
/// The face have this values :
/// - "Devant": Show the front of the container.
/// - "Derrière": Show the back of the container.
const List<String> faceList = <String>['Devant', 'Derrière'];

/// [directionList] : show the lenght or height of the container
/// The direction have this values :
/// - "Largeur": Show the lenght of the container.
/// - "Hauteur": Show the height of the container.
const List<String> directionList = <String>['Haut', 'Bas'];

///
/// [StatefulWidget] : ContainerDialog
///
/// [callback] :
/// [size] : size of the container
/// [width] : width of the container
/// [height] : height of the container
class ContainerDialog extends StatefulWidget {
  const ContainerDialog(
      {super.key,
      required this.callback,
      required this.size,
      required this.width,
      required this.height});

  final Function(LockerCoordinates, bool) callback;
  final int size;
  final int width;
  final int height;

  @override
  State<ContainerDialog> createState() => ContainerDialogState();
}

///
/// ContainerDialogState
///
class ContainerDialogState extends State<ContainerDialog> {
  final _formKey = GlobalKey<FormState>();

  String x = '';
  String y = '';
  String face = faceList.first;
  String direction = directionList.first;
  String size = '';
  int lockerSize = 0;

  /// [Function] : Get the theme of the app
  ///
  Color getColor() {
    if (Provider.of<ThemeService>(context).isDark) {
      return lightTheme.primaryColor;
    } else {
      return darkTheme.primaryColor;
    }
  }

  /// [Function] : Get the theme of the app for the text color
  ///
  Color? getTextColor() {
    if (Provider.of<ThemeService>(context).isDark) {
      return darkTheme.primaryColor;
    } else {
      return lightTheme.primaryColor;
    }
  }

  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ajouter un casier',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: getTextColor()),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Quelle type de casier voulez-vous ajouter ?",
                    style: TextStyle(color: getTextColor())),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          getColor(),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: size == 'Petit',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            size = 'Petit';
                            lockerSize = 1;
                          });
                        } else {
                          setState(() {
                            size = '';
                            lockerSize = 0;
                          });
                        }
                      },
                      child: Text(
                        'Petit',
                        style: TextStyle(color: getTextColor()),
                      ),
                    ),
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: size == 'Moyen',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            size = 'Moyen';
                            lockerSize = 2;
                          });
                        } else {
                          setState(() {
                            size = '';
                            lockerSize = 0;
                          });
                        }
                      },
                      child: Text('Moyen',
                          style: TextStyle(color: getTextColor())),
                    ),
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: size == 'Grand',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            size = 'Grand';
                            lockerSize = 3;
                          });
                        } else {
                          setState(() {
                            size = '';
                            lockerSize = 0;
                          });
                        }
                      },
                      child: Text('Grand',
                          style: TextStyle(color: getTextColor())),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Entrez la colonne du casier',
                      labelText: 'numéro de colonne',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      x = value!;
                    },
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        if (int.parse(value) <= 0) {
                          return 'Position invalide';
                        }
                        if (int.parse(value) > widget.width) {
                          return 'Position invalide';
                        }
                      }
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Entrez la ligne du casier',
                      labelText: 'numéro de ligne',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onChanged: (String? value) {
                      y = value!;
                    },
                    validator: (String? value) {
                      if (value != null && value.isNotEmpty) {
                        if (int.parse(value) < 0) {
                          return 'Position invalide';
                        }
                        if (direction == 'Haut' &&
                            int.parse(value) + lockerSize - 1 > widget.height) {
                          return 'Position invalide';
                        }
                        if (direction == 'Bas' &&
                            int.parse(value) - lockerSize - 1 < 0) {
                          return 'Position invalide';
                        }
                      }
                      if (value == null || value.isEmpty) {
                        return 'Veuillez remplir ce champ';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text("Sur quelle face du conteneur voulez-vous l'ajouter ?",
                    style: TextStyle(color: getTextColor())),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: face == 'Devant',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            face = 'Devant';
                          });
                        } else {
                          setState(() {
                            face = '';
                          });
                        }
                      },
                      child: Text(
                        'Devant',
                        style: TextStyle(color: getTextColor()),
                      ),
                    ),
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: face == 'Derrière',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            face = 'Derrière';
                          });
                        } else {
                          setState(() {
                            face = '';
                          });
                        }
                      },
                      child: Text('Derrière',
                          style: TextStyle(color: getTextColor())),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Text(
                      'Ajouter',
                      style: TextStyle(
                        color: getTextColor(),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (face == '' || size == '') {
                          await showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: Text(
                                        "Veuillez remplir tous les champs"),
                                  ));
                          return;
                        }
                        if (widget.callback(
                                LockerCoordinates(int.parse(x), int.parse(y),
                                    face, direction, lockerSize),
                                false) ==
                            'overwriteError') {
                          await showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: Text(
                                        "Vous ne pouvez pas réaliser cette action, la position est déjà occupée"),
                                  ));
                        } else {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
