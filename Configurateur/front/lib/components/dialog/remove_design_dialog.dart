import 'package:flutter/material.dart';
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

/// [StatefulWidget] : RemoveDesignDialog
///
/// Add a new dialog to remove design.
class RemoveDesignDialog extends StatefulWidget {
  const RemoveDesignDialog({
    super.key,
    required this.callback,
  });

  final Future<void> Function(bool, int) callback;

  @override
  State<RemoveDesignDialog> createState() => RemoveDesignDialogState();
}

/// RemoveDesignDialogState
///
class RemoveDesignDialogState extends State<RemoveDesignDialog> {
  /// [Function] : Get the click for the design dialog
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
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Retirer une image',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: getTextColor(),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 500,
                child: Column(
                  children: <Widget>[
                    Text(
                      "Quelle image souhaitez-vous retirer ?",
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
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Devant',
                            style: TextStyle(
                              fontSize: 12,
                              color: getTextColor(),
                            ),
                          ),
                        ),
                        CheckboxMenuButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Derrière',
                            style: TextStyle(
                              fontSize: 12,
                              color: getTextColor(),
                            ),
                          ),
                        ),
                        CheckboxMenuButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Gauche',
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
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Droite',
                            style: TextStyle(
                              fontSize: 12,
                              color: getTextColor(),
                            ),
                          ),
                        ),
                        CheckboxMenuButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Haut',
                            style: TextStyle(
                              fontSize: 12,
                              color: getTextColor(),
                            ),
                          ),
                        ),
                        CheckboxMenuButton(
                          style: ButtonStyle(
                            fixedSize: MaterialStateProperty.all<Size>(
                              const Size.fromWidth(100),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(getColor()),
                            shape: MaterialStateProperty.all<
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
                            'Bas',
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
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      onPressed: () {
                        for (int i = 0; i < clicked.length; i++) {
                          if (clicked[i].clicked) {
                            widget.callback(
                              false,
                              i,
                            );
                            clicked[i].clicked = false;
                          }
                        }
                        if (mounted) {
                          setState(() {});
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Retirer',
                        style: TextStyle(
                          color: getTextColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
