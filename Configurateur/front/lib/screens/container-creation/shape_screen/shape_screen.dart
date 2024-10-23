import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_header.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'shape_screen_style.dart';

/// ShapeScreen
///
/// Shape of the container
class ShapeScreen extends StatefulWidget {
  const ShapeScreen({super.key});

  @override
  State<ShapeScreen> createState() => ShapeScreenState();
}

/// ShapeScreenState
///
class ShapeScreenState extends State<ShapeScreen> {
  int row = 5;
  int column = 12;
  double width = 0;
  double height = 0;
  int nbLockers = 0;
  bool isRemoveClicked = false;
  int iteration = 0;
  late List<Widget> container = initContainer();
  List<bool> isClicked = List.generate(60, (index) => false);
  List<Color?> colors = List.generate(60, (index) => Colors.grey[200]);

  Future<void> checkContainer() async {
    var storageData = await getContainerFromStorage();
    if (storageData != "") {
      Map<String, dynamic> data = jsonDecode(storageData);
      List<List<String>> containerList =
          jsonDecode(data['containerMappingShape']);
      row = data['height'];
      column = data['width'];
      setState(() {
        colors = List.generate(row * column, (index) {
          if (containerList[(index / column).floor()][index % column] == '0') {
            return Colors.grey[200];
          } else {
            return Colors.grey[600];
          }
        });
        isClicked = List.generate(row * column, (index) => false);
      });
    }
  }

  @override
  void initState() {
    MyAlertTest.checkSignInStatus(context);
    checkContainer().then((result) {
      setState(() {
        calculateDimension();
        super.initState();
      });
    });
  }

  Future<String> getContainerFromStorage() async {
    String? data = await storageService.readStorage('containerData');

    data ??= '';
    return data;
  }

  /// [Function] : Calculate the container's dimension
  void calculateDimension() {
    width = column / 2;
    height = row / 2;
    nbLockers = row * column * 2;
    if (colors.length < row * column) {
      for (int i = colors.length; i < row * column; i++) {
        colors.add(Colors.grey[200]);
      }
    }
    if (isClicked.length < row * column) {
      for (int i = isClicked.length; i < row * column; i++) {
        isClicked.add(false);
      }
    }
  }

  /// [Function] : Remove a locker in the container
  void removeLockers() {
    for (int i = 0; i < isClicked.length; i++) {
      if (isClicked[i] == true) {
        nbLockers -= 2;
        colors[i] = Colors.grey[600];
        isClicked[i] = false;
      }
    }
  }

  /// [Widget] : Create the remove button for lockers
  List<Widget> removeButtons(ScreenFormat screenFormat) {
    List<Widget> buttons = [];

    if (isRemoveClicked == false) {
      buttons.add(
        ElevatedButton(
          key: const Key('remove-lockers'),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            setState(() {
              isRemoveClicked = true;
            });
          },
          child: Text(
            AppLocalizations.of(context)!.removeLocker,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
                  ? desktopFontSize
                  : tabletFontSize,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.colorScheme.background,
            ),
          ),
        ),
      );
    } else {
      buttons.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            key: const Key('remove'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              setState(() {
                removeLockers();
                saveContainerToStorage(generateContainerMapping());
                isRemoveClicked = false;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          ElevatedButton(
            key: const Key('cancel'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              setState(() {
                isClicked = List.generate(60, (index) => false);
                isRemoveClicked = false;
              });
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: Provider.of<ThemeService>(context).isDark
                    ? darkTheme.primaryColor
                    : lightTheme.primaryColor,
                fontSize: screenFormat == ScreenFormat.desktop
                    ? desktopFontSize
                    : tabletFontSize,
              ),
            ),
          ),
        ],
      ));
    }

    return buttons;
  }

  /// [Widget] : Initialization of the container
  List<Widget> initContainer() {
    List<Widget> rows = [];
    List<Widget> line = [];

    for (int i = 0; i < row; i++) {
      for (int j = 0; j < column; j++) {
        j == 0
            ? line.add(
                Container(
                  width: 2.0,
                  height: desktopContainerSize, // +2
                  color: Colors.black,
                ),
              )
            : Container();
        line.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              i == 0
                  ? Container(
                      width: desktopContainerSize,
                      height: 2.0,
                      color: Colors.black,
                    )
                  : Container(),
              InkWell(
                onTap: () => {
                  if (isRemoveClicked == true)
                    {
                      setState(() {
                        isClicked[(i * column) + j] =
                            !isClicked[(i * column) + j];
                      }),
                    },
                },
                child: Container(
                  width: desktopContainerSize,
                  height: desktopContainerSize,
                  color: colors[i * column + j],
                  alignment: Alignment.topRight,
                  child: isRemoveClicked
                      ? Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipOval(
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                color: isClicked[(i * column) + j]
                                    ? Colors.red
                                    : Colors.grey[200],
                              ),
                              width: ovalClipSize,
                              height: ovalClipSize,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              Container(
                  width: desktopContainerSize,
                  height: 2.0,
                  color: Colors.black),
            ],
          ),
        );

        line.add(
          Container(
            width: 2.0,
            height: desktopContainerSize,
            color: Colors.black,
          ),
        );
      }
      rows.add(Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: line,
      ));
      line = [];
    }
    return rows;
  }

  /// [Function] : Go to the previous page
  void goPrevious() {
    context.go('/');
  }

  List<List<String>> generateContainerMapping() {
    List<List<String>> containerList;

    containerList = List.generate(row, (index) => []);
    int rowIndex = 0;
    for (int i = 0; i < colors.length; i++) {
      if ((i % (column)) == 0 && i != 0) {
        rowIndex++;
      }
      if (colors[i] == Colors.grey[600]) {
        containerList[rowIndex].add('1');
      } else if (colors[i] == Colors.grey[200]) {
        containerList[rowIndex].add('0');
      }
    }

    return containerList;
  }

  List<List<String>> reverseContainerMapping(List<List<String>> containerList) {
    List<List<String>> containerListTmp = List.generate(row, (index) => []);
    for (int i = 0; i < containerList.length; i++) {
      containerListTmp[i] = List.generate(column, (index) => '0');
    }
    for (int i = 0; i < containerList.length; i++) {
      for (int j = 0; j < containerList[i].length; j++) {
        if (containerList[i][j] == '1') {
          int rowToUp = 0;
          bool mid = false;
          if (i < row / 2) {
            rowToUp = (row - i) - (i + 1);
          } else {
            rowToUp = (i - row) + (i + 1);
            mid = true;
          }
          int index = mid == true ? i - rowToUp : i + rowToUp;
          containerListTmp[index][j] = '2';
        }
      }
    }

    return containerListTmp;
  }

  /// [Function] : Go to the next page
  void goNext() {
    List<List<String>> containerListTmp =
        reverseContainerMapping(generateContainerMapping());
    saveContainerToStorage(containerListTmp);
    context.go('/container-creation',
        extra: jsonEncode({
          'containerMapping': jsonEncode(containerListTmp),
          'height': row,
          'width': column
        }));
  }

  void saveContainerToStorage(List<List<String>> containerListTmp) {
    storageService.writeStorage(
        'containerData',
        jsonEncode({
          'containerMappingShape': jsonEncode(containerListTmp),
          'height': row,
          'width': column,
          'container': '',
          'containerMapping': ''
        }));
  }

  /// [Widget] : Build the container's shape page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Scaffold(
      body: FooterView(
        flex: 8,
        footer: Footer(
          child: CustomFooter(),
        ),
        children: [
          LandingAppBar(context: context),
          Text(
            AppLocalizations.of(context)!.shape,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: screenFormat == ScreenFormat.desktop
                  ? desktopBigFontSize
                  : tabletBigFontSize,
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.secondaryHeaderColor
                  : lightTheme.secondaryHeaderColor,
              shadows: [
                Shadow(
                  color: Provider.of<ThemeService>(context).isDark
                      ? darkTheme.secondaryHeaderColor
                      : lightTheme.secondaryHeaderColor,
                  offset: const Offset(0.75, 0.75),
                  blurRadius: 1.5,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.rowNumbers,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            key: const Key('row-remove'),
                            onTap: () {
                              setState(() {
                                if (row > 1) {
                                  row--;
                                  colors = List.generate(column * row,
                                      (index) => Colors.grey[200]);
                                  isClicked = List.generate(
                                      column * row, (index) => false);
                                  calculateDimension();
                                  saveContainerToStorage(
                                      generateContainerMapping());
                                }
                              });
                            },
                            child: Icon(
                              Icons.remove,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Provider.of<ThemeService>(context).isDark
                                  ? lightTheme.primaryColor
                                  : darkTheme.primaryColor,
                            ),
                            child: Text(
                              row.toString(),
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            key: const Key('row-add'),
                            onTap: () {
                              setState(() {
                                if (row < 10) {
                                  row++;
                                  colors = List.generate(column * row,
                                      (index) => Colors.grey[200]);
                                  isClicked = List.generate(
                                      column * row, (index) => false);
                                  calculateDimension();
                                  saveContainerToStorage(
                                      generateContainerMapping());
                                }
                              });
                            },
                            child: Icon(Icons.add,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        AppLocalizations.of(context)!.columnNumbers,
                        style: TextStyle(
                          color: Provider.of<ThemeService>(context).isDark
                              ? darkTheme.primaryColor
                              : lightTheme.primaryColor,
                          fontSize: screenFormat == ScreenFormat.desktop
                              ? desktopFontSize
                              : tabletFontSize,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            key: const Key('column-remove'),
                            onTap: () {
                              setState(() {
                                if (column > 1) {
                                  column--;
                                  colors = List.generate(column * row,
                                      (index) => Colors.grey[200]);
                                  isClicked = List.generate(
                                      column * row, (index) => false);
                                  calculateDimension();
                                  saveContainerToStorage(
                                      generateContainerMapping());
                                }
                              });
                            },
                            child: Icon(Icons.remove,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor),
                          ),
                          const SizedBox(width: 10.0),
                          Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              color: Provider.of<ThemeService>(context).isDark
                                  ? lightTheme.primaryColor
                                  : darkTheme.primaryColor,
                            ),
                            child: Text(
                              column.toString(),
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            key: const Key('column-add'),
                            onTap: () {
                              setState(() {
                                if (column < 20) {
                                  column++;
                                  colors = List.generate(column * row,
                                      (index) => Colors.grey[200]);
                                  isClicked = List.generate(
                                      column * row, (index) => false);
                                  calculateDimension();
                                  saveContainerToStorage(
                                      generateContainerMapping());
                                }
                              });
                            },
                            child: Icon(Icons.add,
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: removeButtons(screenFormat),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: initContainer(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: screenFormat == ScreenFormat.desktop
                        ? desktopPanelWidth
                        : tabletPanelWidth,
                    height: desktopPanelHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Provider.of<ThemeService>(context).isDark
                            ? lightTheme.primaryColor
                            : darkTheme.primaryColor,
                        borderRadius: BorderRadius.circular(30.0),
                        boxShadow: [
                          BoxShadow(
                            color: Provider.of<ThemeService>(context).isDark
                                ? darkTheme.primaryColor.withOpacity(0.3)
                                : lightTheme.primaryColor.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.width,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.meters(width),
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.height,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                              Text(
                                AppLocalizations.of(context)!.meters(height),
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.locationsNumber,
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                              Text(
                                '$nbLockers',
                                style: TextStyle(
                                  color:
                                      Provider.of<ThemeService>(context).isDark
                                          ? darkTheme.primaryColor
                                          : lightTheme.primaryColor,
                                  fontSize: screenFormat == ScreenFormat.desktop
                                      ? desktopFontSize
                                      : tabletFontSize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                length: 6,
                progress: 0,
                previous: AppLocalizations.of(context)!.previous,
                next: AppLocalizations.of(context)!.next,
                previousFunc: goPrevious,
                nextFunc: goNext,
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
    );
  }
}
