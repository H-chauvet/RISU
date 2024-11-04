import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/dialog/help_dialog/help_dialog.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];

/// [StatefulWidget] : DeleteContainerDialog
///
/// Add a new dialog to delete design for a container's face
class DeleteContainerDialog extends StatefulWidget {
  const DeleteContainerDialog({super.key, required this.callback});

  final Function(LockerCoordinates, bool) callback;

  @override
  State<DeleteContainerDialog> createState() => DeleteContainerDialogState();
}

///
/// DeleteContainerDialog
///
class DeleteContainerDialogState extends State<DeleteContainerDialog> {
  final _formKey = GlobalKey<FormState>();

  String x = '';
  String y = '';
  String face = faceList.first;
  String direction = directionList.first;
  String size = '';
  int lockerSize = 0;

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
      iconPadding: const EdgeInsets.all(0),
      icon: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          hoverColor: Colors.transparent,
          iconSize: 30.0,
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    HelpDialog(content: 'delete_container_dialog'));
          },
          icon: Icon(
            Icons.help_outline,
            color: darkTheme.primaryColor,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.deleteContainer,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: getTextColor(),
            ),
          ),
          const SizedBox(height: 20),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const Key('locker-column'),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.columnNumberAsk,
                      labelText: AppLocalizations.of(context)!.columnNumber,
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
                          return AppLocalizations.of(context)!.invalidPosition;
                        }
                        if (int.parse(value) > 12) {
                          return AppLocalizations.of(context)!.invalidPosition;
                        }
                      }
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.askCompleteField;
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextFormField(
                    key: const Key('locker-row'),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.rowNumberAsk,
                      labelText: AppLocalizations.of(context)!.rowNumber,
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
                          return AppLocalizations.of(context)!.invalidPosition;
                        }
                        if (int.parse(value) > 12) {
                          return AppLocalizations.of(context)!.invalidPosition;
                        }
                      }
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.askCompleteField;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  AppLocalizations.of(context)!.askRemoveContainerSide,
                  style: TextStyle(color: getTextColor()),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: face == 'Devant',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            face = 'Devant';
                          });
                        } else {
                          setState(() {
                            face = '';
                          });
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.front,
                        style: TextStyle(color: getTextColor()),
                      ),
                    ),
                    CheckboxMenuButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(getColor()),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                      value: face == 'Derrière',
                      onChanged: (bool? value) {
                        if (value == true) {
                          setState(() {
                            face = 'Derrière';
                          });
                        } else {
                          setState(() {
                            face = '';
                          });
                        }
                      },
                      child: Text(
                        AppLocalizations.of(context)!.back,
                        style: TextStyle(color: getTextColor()),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0))),
                    child: Text(
                      AppLocalizations.of(context)!.delete,
                      style: TextStyle(
                        color: getTextColor(),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        String ret = widget.callback(
                            LockerCoordinates(int.parse(x), int.parse(y), face,
                                direction, lockerSize),
                            false);
                        if (ret == 'deleteError') {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .spaceAllreadyEmpty,
                                style: TextStyle(
                                  color: getTextColor(),
                                ),
                              ),
                            ),
                          );
                        } else if (ret == 'wrongPositionError') {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .invalidPositionAskAnotherPosition,
                                style: TextStyle(
                                  color: getTextColor(),
                                ),
                              ),
                            ),
                          );
                        } else if (ret == 'notFoundError') {
                          await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text(
                                AppLocalizations.of(context)!
                                    .invalidPositionAskAnotherPosition,
                                style: TextStyle(
                                  color: getTextColor(),
                                ),
                              ),
                            ),
                          );
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
