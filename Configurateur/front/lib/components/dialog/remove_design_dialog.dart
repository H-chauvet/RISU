import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

class Face {
  Face({required this.name, required this.clicked});

  final String name;
  bool clicked;
}

List<Face> clicked = [
  Face(name: 'Devant', clicked: false),
  Face(name: 'Derrière', clicked: false),
  Face(name: 'Haut', clicked: false),
  Face(name: 'Gauche', clicked: false),
  Face(name: 'Bas', clicked: false),
  Face(name: 'Droite', clicked: false),
];

class RemoveDesignDialog extends StatefulWidget {
  const RemoveDesignDialog({
    super.key,
    required this.callback,
  });

  final Future<void> Function(bool, int) callback;

  @override
  State<RemoveDesignDialog> createState() => RemoveDesignDialogState();
}

///
/// RemoveDesignDialog
///
class RemoveDesignDialogState extends State<RemoveDesignDialog> {
  bool getClicked(String face) {
    for (int i = 0; i < clicked.length; i++) {
      if (clicked[i].name == face) {
        return clicked[i].clicked;
      }
    }
    return false;
  }

  void setClicked(String face, bool value) {
    for (int i = 0; i < clicked.length; i++) {
      if (clicked[i].name == face) {
        clicked[i].clicked = value;
      }
    }
  }

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
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Retirer une image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 500,
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Quelle image souhaitez-vous retirer ?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                            if (value == true) {
                              setState(() {
                                setClicked('Devant', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Devant', false);
                              });
                            }
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
                            if (value == true) {
                              setState(() {
                                setClicked('Derrière', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Derrière', false);
                              });
                            }
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
                            if (value == true) {
                              setState(() {
                                setClicked('Gauche', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Gauche', false);
                              });
                            }
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
                            if (value == true) {
                              setState(() {
                                setClicked('Droite', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Droite', false);
                              });
                            }
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
                            if (value == true) {
                              setState(() {
                                setClicked('Haut', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Haut', false);
                              });
                            }
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
                            if (value == true) {
                              setState(() {
                                setClicked('Bas', true);
                              });
                            } else {
                              setState(() {
                                setClicked('Bas', false);
                              });
                            }
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
                      child: const Text('Retirer'),
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
