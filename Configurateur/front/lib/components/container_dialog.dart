import 'package:flutter/material.dart';
import 'package:front/services/locker_service.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];
const List<String> colorList = <String>['Rouge', 'Vert', 'Bleu', 'Noir'];

class ContainerDialog extends StatefulWidget {
  const ContainerDialog(
      {super.key, required this.callback, required this.size});

  final Function(LockerCoordinates) callback;
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
  String color = colorList.first;

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
                        if (direction == 'Haut' &&
                            int.parse(value) + widget.size > 6) {
                          return 'Position invalide';
                        }
                        if (direction == 'Bas' &&
                            int.parse(value) - widget.size <= 1) {
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
                  child: DropdownMenu<String>(
                    initialSelection: faceList.first,
                    onSelected: (String? value) {
                      setState(() {
                        face = value!;
                      });
                    },
                    dropdownMenuEntries:
                        faceList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                Padding(
                  key: const Key("container-dialog-direction-dropdown"),
                  padding: const EdgeInsets.all(8),
                  child: DropdownMenu<String>(
                    initialSelection: directionList.first,
                    onSelected: (String? value) {
                      setState(() {
                        direction = value!;
                      });
                    },
                    dropdownMenuEntries: directionList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownMenu<String>(
                    initialSelection: colorList.first,
                    onSelected: (String? value) {
                      setState(() {
                        color = value!;
                      });
                    },
                    dropdownMenuEntries: colorList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    child: const Text('Ajouter'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        widget.callback(LockerCoordinates(int.parse(x),
                            int.parse(y), face, direction, widget.size, color));
                        Navigator.pop(context);
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
