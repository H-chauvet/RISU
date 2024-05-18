import 'package:flutter/material.dart';

/// [faceList] : show the selected face of the container
/// The face have this values :
/// - "Devant": Show the front of the container.
/// - "Derrière": Show the back of the container.
const List<String> faceList = <String>['Toutes', 'Devant', 'Derrière'];

/// [directionList] : show the lenght or height of the container
/// The direction have this values :
/// - "Largeur": Show the lenght of the container.
/// - "Hauteur": Show the height of the container.
const List<String> directionList = <String>['Largeur', 'Hauteur'];

/// [StatefulWidget] : AddDesignDialog
///
/// Add a new dialog to create design for a container's face
class AutoFillDialog extends StatefulWidget {
  const AutoFillDialog({super.key, required this.callback});

  final Function(String, bool) callback;

  @override
  State<AutoFillDialog> createState() => AutoFillDialogState();
}

///
/// AutoFillDialog
///
/// [face] : show the selected face of the container
/// The face have this values :
/// - "Toutes": Show all the faces of the container.
/// - "Devant": Show the front of the container.
/// - "Derrière": Show the back of the container.
/// [direction] : show the lenght or height of the container
/// The direction have this values :
/// - "Largeur": Show the lenght of the container.
/// - "Hauteur": Show the height of the container.
class AutoFillDialogState extends State<AutoFillDialog> {
  String face = faceList.first;
  String direction = directionList.first;

  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
              'Quelle(s) face(s) du conteneur voulez-vous ranger automatiquement ?'),
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownMenu<String>(
              key: const Key('face'),
              hintText: 'Face du conteneur',
              label: const Text('Face du conteneur'),
              initialSelection: faceList.first,
              onSelected: (String? value) {
                setState(() {
                  face = value!;
                });
              },
              dropdownMenuEntries:
                  faceList.map<DropdownMenuEntry<String>>((String value) {
                return DropdownMenuEntry<String>(value: value, label: value);
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
                'Trier',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, face);
              },
            ),
          ),
        ],
      ),
    );
  }
}
