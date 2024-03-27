import 'package:flutter/material.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];

class ContainerDialog extends StatefulWidget {
  const ContainerDialog(
      {super.key, required this.callback, required this.size});

  final Function(LockerCoordinates, bool) callback;
  final int size;

  @override
  State<ContainerDialog> createState() => ContainerDialogState();
}

///
/// ContainerDialog
///
class ContainerDialogState extends State<ContainerDialog> {
  final _formKey = GlobalKey<FormState>();

  String x = '';
  String y = '';
  String face = faceList.first;
  String direction = directionList.first;
  String size = '';
  int lockerSize = 0;

  Color getColor() {
    if (Provider.of<ThemeService>(context).isDark) {
      return checkBoxMenuButtonColorDarkTheme;
    } else {
      return checkBoxMenuButtonColorLightTheme;
    }
  }

  Color? getTextColor() {
    if (Provider.of<ThemeService>(context).isDark) {
      return containerDialogTextColorDarkTheme;
    } else {
      return lightTheme.colorScheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Ajouter un conteneur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text("Quelle taille de casier voulez-vous ajouter ?"),
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
                        if (int.parse(value) > 12) {
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
                            int.parse(value) + widget.size > 6) {
                          return 'Position invalide';
                        }
                        if (direction == 'Bas' &&
                            int.parse(value) - widget.size < 0) {
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
                const Text("Sur quelle face du casier voulez-vous l'ajouter ?"),
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
                                        "Vous ne pouvez pas réalisé cette action, la position est déjà occupée"),
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
