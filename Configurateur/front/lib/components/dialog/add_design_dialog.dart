import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

///
/// Face class who represent the faces of the container
/// [name] : name of the actual face
/// [clicked] : true if it's the selected face, else if it's not
///
class Face {
  Face({required this.name, required this.clicked});

  final String name;
  bool clicked;
}

/// List of the Face class to define all the faces
List<Face> clicked = [
  Face(name: 'Devant', clicked: false),
  Face(name: 'Derrière', clicked: false),
  Face(name: 'Haut', clicked: false),
  Face(name: 'Gauche', clicked: false),
  Face(name: 'Bas', clicked: false),
  Face(name: 'Droite', clicked: false),
];

/// [StatefulWidget] : AddDesignDialog
///
/// Add a new dialog to create design for a container's face
class AddDesignDialog extends StatefulWidget {
  const AddDesignDialog({
    super.key,
    required this.file,
    required this.callback,
  });

  final Future<void> Function(bool, {Uint8List? fileData, int? faceLoad})
      callback;
  final FilePickerResult? file;

  @override
  State<AddDesignDialog> createState() => AddDesignDialogState();
}

/// AddDesignDialogState
///
class AddDesignDialogState extends State<AddDesignDialog> {
  /// [Function] : getClicked
  /// Get the click for the design dialog
  ///
  /// [face] : Selected face of the container
  bool getClicked(String face) {
    for (int i = 0; i < clicked.length; i++) {
      if (clicked[i].name == face) {
        return clicked[i].clicked;
      }
    }
    return false;
  }

  /// [Function] : Set the click for the design dialog
  ///
  /// [face] : Selected face of the container
  /// [value] : Define the face who is clicked
  void setClicked(String face, bool value) {
    for (int i = 0; i < clicked.length; i++) {
      if (clicked[i].name == face) {
        clicked[i].clicked = value;
      }
    }
  }

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
            AppLocalizations.of(context)!.containerAdd,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: getTextColor(),
            ),
          ),
          const SizedBox(height: 20),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.memory(
                      widget.file!.files.first.bytes!,
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(
                      width: 500.0,
                      child: Column(
                        children: <Widget>[
                          Text(widget.file!.files.first.name),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.askDesign,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: getTextColor(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100.0),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Devant'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Devant', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.front,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Derrière'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Derrière', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.back,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Gauche'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Gauche', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Droite'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Droite', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.right,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Haut'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Haut', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.up,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                              CheckboxMenuButton(
                                style: ButtonStyle(
                                  fixedSize: WidgetStateProperty.all<Size>(
                                    const Size.fromWidth(100),
                                  ),
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          getColor()),
                                  shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                ),
                                value: getClicked('Bas'),
                                onChanged: (bool? value) {
                                  setState(() {
                                    setClicked('Bas', value!);
                                  });
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.down,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: getTextColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              for (int i = 0; i < clicked.length; i++) {
                                if (clicked[i].clicked) {
                                  await widget.callback(
                                    false,
                                    fileData: widget.file!.files.first.bytes,
                                    faceLoad: i,
                                  );
                                  clicked[i].clicked = false;
                                }
                              }
                              if (mounted) {
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              AppLocalizations.of(context)!.add,
                              style: TextStyle(color: getTextColor()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
