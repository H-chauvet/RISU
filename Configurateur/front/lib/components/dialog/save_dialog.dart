import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class SaveDialog extends StatefulWidget {
  SaveDialog({super.key, this.name});

  String? name;

  @override
  State<SaveDialog> createState() => SaveDialogState();
}

///
/// SaveDialog
///
class SaveDialogState extends State<SaveDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Sauvegarde"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Voulez-vous donner un nom à votre sauvegarde ?"),
          const SizedBox(height: 20),
          TextFormField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nom de la sauvegarde',
            ),
            initialValue: widget.name,
            onChanged: (String value) {
              setState(() {
                widget.name = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0))),
            child: const Text(
              'Sauvegarder',
            ),
            onPressed: () {
              if (widget.name == '') {
                widget.name =
                    'Sauvegarde - ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}';
              }
              Navigator.pop(
                context,
                widget.name,
              );
            },
          ),
        ],
      ),
    );
  }
}
