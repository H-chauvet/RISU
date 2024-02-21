import 'package:flutter/material.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];

class DeleteContainerDialog extends StatefulWidget {
  const DeleteContainerDialog({super.key, required this.callback});

  final Function(LockerCoordinates, bool) callback;

  @override
  State<DeleteContainerDialog> createState() => DeleteContainerDialogState();
}

///
/// DeleteContainerDialog
///
class DeleteContainerDialogState extends State<DeleteContainerDialog> {
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
          const Text('Supprimer un conteneur',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "Sur quelle face du casier voulez-vous le supprimer ?"),
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
                    child: const Text(
                      'Supprimer',
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String ret = widget.callback(
                            LockerCoordinates(int.parse(x), int.parse(y), face,
                                direction, lockerSize),
                            false);
                        if (ret == 'deleteError') {
                          await showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: Text(
                                        "Vous ne pouvez pas réalisé cette action, la position est déjà vide"),
                                  ));
                        } else if (ret == 'wrongPositionError') {
                          await showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                    content: Text(
                                        "Vous ne pouvez pas réalisé cette action, la position est invalide. Veuillez indiquer la position à la base du casier."),
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
