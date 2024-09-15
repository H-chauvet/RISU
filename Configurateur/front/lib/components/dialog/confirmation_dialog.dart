import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

/// [StatefulWidget] : ConfirmationDialogState
///
/// Create a new dialog to save container with specific [name]
class ConfirmationDialog extends StatefulWidget {
  ConfirmationDialog({
    super.key,
  });

  @override
  State<ConfirmationDialog> createState() => ConfirmationDialogState();
}

/// ConfirmationDialogState
///
class ConfirmationDialogState extends State<ConfirmationDialog> {
  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirmation",
          style: TextStyle(
            color: Provider.of<ThemeService>(context).isDark
                ? darkTheme.primaryColor
                : lightTheme.primaryColor,
          )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Etes-vous certains de vouloir faire cette action ?",
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    backgroundColor: Colors.red[400]),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text(
                  'Annuler',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text(
                  'Confirmer',
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.colorScheme.background,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
