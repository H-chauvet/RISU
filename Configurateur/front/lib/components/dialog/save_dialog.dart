import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable

/// [StatefulWidget] : SaveDialogState
///
/// Create a new dialog to save container with specific [name]
class SaveDialog extends StatefulWidget {
  SaveDialog({super.key, this.name});

  String? name = '';

  @override
  State<SaveDialog> createState() => SaveDialogState();
}

/// SaveDialogState
///
class SaveDialogState extends State<SaveDialog> {
  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.save,
        style: TextStyle(
          color: Provider.of<ThemeService>(context).isDark
              ? darkTheme.primaryColor
              : lightTheme.primaryColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.askSaveName,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: AppLocalizations.of(context)!.saveName,
            ),
            initialValue: widget.name,
            onChanged: (String value) {
              setState(() {
                widget.name = value;
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(
                    context,
                    '',
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0))),
                child: Text(
                  AppLocalizations.of(context)!.saveAction,
                  style: TextStyle(
                    color: Provider.of<ThemeService>(context).isDark
                        ? darkTheme.primaryColor
                        : lightTheme.primaryColor,
                  ),
                ),
                onPressed: () {
                  if (widget.name == '' || widget.name == null) {
                    widget.name = AppLocalizations.of(context)!.saveData(
                        DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(DateTime.now()));
                  }
                  storageService.removeStorage('containerData');
                  Navigator.pop(
                    context,
                    widget.name,
                  );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
