import 'package:flutter/material.dart';
import 'package:front/services/locker_service.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];

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
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: DropdownMenu<String>(
                    hintText: 'Face du casier',
                    label: const Text('Face du casier'),
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
                    hintText: 'Direction du casier',
                    label: const Text('Direction du casier'),
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: const Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (widget.callback(LockerCoordinates(int.parse(x),
                                int.parse(y), face, direction, widget.size)) ==
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
