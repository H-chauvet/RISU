import 'package:flutter/material.dart';

const List<String> faceList = <String>['Toutes', 'Devant', 'Derrière'];
const List<String> directionList = <String>['Largeur', 'Hauteur'];

class AutoFillDialog extends StatefulWidget {
  const AutoFillDialog({super.key, required this.callback});

  final Function(String) callback;

  @override
  State<AutoFillDialog> createState() => AutoFillDialogState();
}

///
/// AutoFillDialog
///
class AutoFillDialogState extends State<AutoFillDialog> {
  String face = faceList.first;
  String direction = directionList.first;

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
                'Ajouter',
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
