// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/dialog/add_design_dialog.dart';
import 'package:front/components/dialog/remove_design_dialog.dart';
import 'package:front/components/dialog/save_dialog.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

import '../../../components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../../components/progress_bar.dart';
import '../../../components/recap_panel/recap_panel.dart';
import '../../../network/informations.dart';
import 'design_screen_style.dart';

/// List of the Face class to define all the faces
const List<String> faceList = <String>[
  'Devant',
  'Derrière',
  'Droite',
  'Gauche',
  'Haut',
  'Bas'
];

/// Design for a container
/// [face] : Contient les face du conteneur
/// [design] : Contient le design du conteneur
class Design {
  Design(this.face, this.design);

  String face;
  List<int> design;

  Map<String, dynamic> toJson() => {
        'face': face,
        'design': design,
      };

  factory Design.fromJson(Map<String, dynamic> json) {
    return Design(
      json['face'] as String,
      json['design'] as List<int>,
    );
  }
}

/// DesignScreen
/// Creation of container's design
// ignore: must_be_immutable
class DesignScreen extends StatefulWidget {
  DesignScreen(
      {super.key,
      this.lockers,
      this.amount,
      this.containerMapping,
      this.id,
      this.container,
      this.width,
      this.height});

  String? lockers;
  int? amount;
  String? containerMapping;
  String? id;
  String? container;
  String? width;
  String? height;

  @override
  State<DesignScreen> createState() => DesignScreenState();
}

/// DesignScreenState
///
class DesignScreenState extends State<DesignScreen> {
  late List<Sp3dObj> objs = [];

  Sp3dWorld? world;
  bool isLoaded = false;
  List<Locker> lockerss = [];
  double actualRotationDegree = 0.0;
  String jwtToken = '';
  int imageIndex = 0;
  int materialIndex = 1;
  FilePickerResult? picked;
  bool unitTest = false;
  String face = faceList.first;
  List<Design> designss = [];

  /// [Function] : Check in storage service is the token is available
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      if (mounted) {
        context.go(
          '/login',
        );
      }
    }
  }

  Future<void> checkContainer() async {
    var storageData = await getContainerFromStorage();
    if (storageData != "") {
      setState(() {
        dynamic decode = jsonDecode(storageData);
        widget.id = decode['id'];
        if (decode['container'] != '') {
          widget.container = decode['container'];
        }
        widget.containerMapping = decode['containerMapping'];
        widget.width = decode['width'];
        widget.height = decode['height'];
        widget.amount = decode['amount'];
        widget.lockers = decode['lockers'];
      });
    }
  }

  @override
  void initState() {
    checkToken();
    super.initState();

    checkContainer().then((result) {
      setState(() {
        Sp3dObj obj =
            UtilSp3dGeometry.cube(cubeWidth, cubeHeight - 20, 50, 1, 1, 1);
        obj.materials.add(FSp3dMaterial.green.deepCopy());

        obj.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        objs.add(obj);
        loadImage(false).then((value) => null);
        if (widget.lockers != null) {
          decodeLockers();
        }
        if (widget.container != null) {
          decodeDesigns();
        }
      });
    });
  }

  /// [Function] : Decode lockers for the container in json
  void decodeLockers() {
    dynamic decode = jsonDecode(widget.lockers!);

    for (int i = 0; i < decode.length; i++) {
      if (decode[i]['type'] == 'Design personnalisé') {
        continue;
      }
      lockerss.add(Locker(decode[i]['type'], decode[i]['price']));
    }
  }

  /// [Function] : Save the container in the storage service
  void saveContainerToStorage() {
    dynamic design = jsonEncode(designss);
    dynamic decode = {
      'containerMapping': '',
      'designs': '',
      'height': '',
      'width': '',
    };
    if (widget.container != null) {
      decode = jsonDecode(widget.container!);
    }

    if (widget.container != null) {
      decode['designs'] = jsonEncode(designss);
      decode['containerMapping'] = widget.containerMapping;
    } else {
      decode = {
        'containerMapping': widget.containerMapping,
        'designs': design,
        'height': widget.height,
        'width': widget.width,
      };
    }

    var data = {
      'container': jsonEncode(decode),
      'id': widget.id,
      'width': widget.width,
      'height': widget.height,
      'amount': widget.amount,
      'lockers': jsonEncode(lockerss),
      'containerMapping': widget.containerMapping,
    };

    storageService.writeStorage('containerData', jsonEncode(data));
  }

  Future<String> getContainerFromStorage() async {
    String? data = await storageService.readStorage('containerData');

    data ??= '';
    return data;
  }

  /// [Function] : Decode designs for the container in json
  void decodeDesigns() {
    dynamic container = jsonDecode(widget.container!);

    dynamic decode = jsonDecode(container['designs']);

    if (decode != null) {
      for (int i = 0; i < decode.length; i++) {
        loadImage(false,
            fileData: Uint8List.fromList(decode[i]['design']),
            faceLoad: int.parse(decode[i]['face']));
      }
    }

    setState(() {
      isLoaded = true;
    });
  }

  /// [Function] : Load an image for the container's design
  Future<void> loadImage(bool unitTesting,
      {Uint8List? fileData, int? faceLoad}) async {
    if (fileData != null) {
      int faceIndex = 0;
      switch (face) {
        case 'Devant':
          faceIndex = 0;
          break;
        case 'Derrière':
          faceIndex = 1;
          break;
        case 'Bas':
          faceIndex = 4;
          break;
        case 'Gauche':
          faceIndex = 3;
          break;
        case 'Haut':
          faceIndex = 2;
          break;
        case 'Droite':
          faceIndex = 5;
          break;
        default:
          faceIndex = 0;
          break;
      }
      if (faceLoad != null) {
        faceIndex = faceLoad;
        lockerss.add(Locker('Design personnalisé', 50));
      } else {
        lockerss.add(Locker('Design personnalisé', 50));
      }

      if (objs[0].fragments[0].faces[faceIndex].materialIndex != 0) {
        removeDesign(faceIndex);
      }

      objs[0].materials.add(FSp3dMaterial.black);
      objs[0].materials[materialIndex] = FSp3dMaterial.green.deepCopy()
        ..imageIndex = imageIndex
        ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
      objs[0].fragments[0].faces[faceIndex].materialIndex = materialIndex;
      objs[0].images.add(fileData);
      designss.add(Design(faceIndex.toString(), fileData));
      imageIndex++;
      materialIndex++;
    }
    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
      if (unitTesting == false) {
        setState(() {
          if (unitTest == false) {
            saveContainerToStorage();
          }
          isLoaded = true;
        });
      } else {
        if (unitTest == false) {
          saveContainerToStorage();
        }
        isLoaded = true;
      }
    });
  }

  /// [Function] : Delete image of container's face
  ///
  /// [faceIndex] : Selected face of the container
  Future<void> removeImage(bool unitTesting, int faceIndex) async {
    picked = null;

    if (objs[0].fragments[0].faces[faceIndex].materialIndex == 0 &&
        unitTesting == false) {
      return;
    }
    for (int i = 0; i < designss.length; i++) {
      if (designss[i].face == faceIndex.toString()) {
        designss.removeAt(i);
        break;
      }
    }
    removeDesign(faceIndex);
    objs[0].fragments[0].faces[faceIndex].materialIndex = 0;

    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
      if (unitTesting == false) {
        setState(() {
          if (unitTest == false) {
            saveContainerToStorage();
          }
          isLoaded = true;
        });
      } else {
        if (unitTest == false) {
          saveContainerToStorage();
        }
        isLoaded = true;
      }
    });
  }

  /// [Function] : Open dialog to pick an image for the design
  void openAddDialog(context) async {
    await showDialog(
        context: context,
        builder: (context) =>
            AddDesignDialog(file: picked, callback: loadImage));
  }

  /// [Function] : Remove design of a container
  ///
  /// [faceIndex] : Selected face of the container
  void removeDesign(int faceIndex) {
    for (int i = 0; i < lockerss.length; i++) {
      if (lockerss[i].type == 'Design personnalisé') {
        lockerss.removeAt(i);
        break;
      }
    }

    for (int i = 0; i < designss.length; i++) {
      if (designss[i].face == faceIndex.toString()) {
        designss.removeAt(i);
        return;
      }
    }
  }

  /// [Function] : Calculating the price of lockers
  /// return the total price
  int sumPrice() {
    int price = 0;
    for (int i = 0; i < lockerss.length; i++) {
      price += lockerss[i].price;
    }
    return price;
  }

  /// [Function] : Get the containerMapping of a container
  String getContainerMapping() {
    String mapping = "";
    for (int i = 0; i < objs[0].fragments.length; i++) {
      mapping += objs[0].fragments[i].faces[0].materialIndex.toString();
    }
    return mapping;
  }

  /// [Widget] : Open dialog
  Widget openDialog() {
    if (widget.container != null) {
      return SaveDialog(name: jsonDecode(widget.container!)['saveName']);
    } else {
      return SaveDialog();
    }
  }

  /// [Function] : Save data of the container
  ///
  /// [name] : Name of the container
  void saveContainer(String name) async {
    var header = <String, String>{
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    if (widget.id == null) {
      HttpService().request('http://$serverIp:3000/api/container/create',
          header, <String, String>{
        'containerMapping': widget.containerMapping!,
        'designs': json.encode(designss),
        'height': widget.height.toString(),
        'width': widget.width.toString(),
        'saveName': name,
      }).then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          showCustomToast(context, value.body, false);
        }
      });
    } else {
      dynamic container = jsonDecode(widget.container!);
      HttpService().putRequest('http://$serverIp:3000/api/container/update',
          header, <String, String>{
        'id': widget.id!,
        'containerMapping': widget.containerMapping!,
        'price': sumPrice().toString(),
        'designs': json.encode(designss),
        'width': container['width'],
        'height': container['height'],
        'city': '',
        'informations': '',
        'address': '',
        'saveName': name,
      }).then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          showCustomToast(context, value.body, false);
        }
      });
    }
  }

  /// [Function] : Go to the next page
  void goNext() async {
    if (widget.id == null) {
      HttpService().request(
        'http://$serverIp:3000/api/container/create',
        <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        <String, dynamic>{
          'designs': json.encode(designss),
          'height': widget.height,
          'width': widget.width,
        },
      ).then((value) {
        if (value.statusCode != 200) {
          showCustomToast(context, value.body, false);
          return;
        }
        dynamic response = jsonDecode(value.body);
        widget.id = response['id'];
        var data = {
          'id': response['id'],
          'amount': sumPrice(),
          'containerMapping': widget.containerMapping,
          'lockers': jsonEncode(lockerss),
          'container': jsonEncode(response),
        };
        if (unitTest == false) {
          saveContainerToStorage();
        }
        context.go("/container-creation/recap", extra: jsonEncode(data));
      });
    } else {
      dynamic container = jsonDecode(widget.container!);

      HttpService().putRequest(
        'http://$serverIp:3000/api/container/update',
        <String, String>{
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json; charset=UTF-8',
          'Access-Control-Allow-Origin': '*',
        },
        <String, dynamic>{
          'id': widget.id!,
          'containerMapping': widget.containerMapping!,
          'price': sumPrice().toString(),
          'designs': json.encode(designss),
          'width': container['width'],
          'height': container['height'],
          'city': '',
          'informations': '',
          'address': '',
        },
      ).then((value) {
        if (value.statusCode != 200) {
          showCustomToast(context, value.body, false);
        }
        dynamic response = jsonDecode(value.body);
        var data = {
          'id': response['id'],
          'amount': sumPrice(),
          'containerMapping': widget.containerMapping,
          'lockers': jsonEncode(lockerss),
          'container': jsonEncode(response),
        };
        if (unitTest == false) {
          saveContainerToStorage();
        }
        context.go("/container-creation/recap", extra: jsonEncode(data));
      });
    }
  }

  /// [Function] : Go to the previous page
  void goPrevious() {
    if (widget.container != null) {
      dynamic decode = jsonDecode(widget.container!);
      decode['designs'] = jsonEncode(designss);
      decode['containerMapping'] = widget.containerMapping;

      var data = {
        'id': widget.id,
        'container': jsonEncode(decode),
        'width': widget.width,
        'height': widget.height,
      };
      if (unitTest == false) {
        saveContainerToStorage();
      }
      context.go("/container-creation", extra: jsonEncode(data));
    } else {
      dynamic design = jsonEncode(designss);
      var container = {
        'containerMapping': widget.containerMapping!,
        'designs': design!,
        'height': widget.height,
        'width': widget.width,
      };

      var data = {
        'container': jsonEncode(container),
      };
      if (unitTest == false) {
        saveContainerToStorage();
      }
      context.go("/container-creation", extra: jsonEncode(data));
    }
  }

  /// [Function] : Load the container form
  Widget loadCube() {
    if (world != null) {
      return Sp3dRenderer(
        Size(cubeCameraWidth, cubeCameraHeight),
        Sp3dV2D(cubeCameraWidth / 2, cubeCameraHeight / 2),
        world!,
        // If you want to reduce distortion, shoot from a distance at high magnification.
        Sp3dCamera(Sp3dV3D(0, 0, 3000), 6000),
        Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
        allowUserWorldRotation: true,
        allowUserWorldZoom: false,
      );
    } else {
      return Container();
    }
  }

  /// [Widget] : Build the design page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      appBar: CustomAppBar(
        AppLocalizations.of(context)!.design,
        context: context,
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProgressBar(
            length: 6,
            progress: 2,
            previous: AppLocalizations.of(context)!.previous,
            next: AppLocalizations.of(context)!.next,
            previousFunc: goPrevious,
            nextFunc: goNext,
          ),
          const SizedBox(
            height: 50,
          )
        ],
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DottedBorder(
                      color: Colors.grey[600]!,
                      padding: EdgeInsets.zero,
                      strokeWidth: 3,
                      child: Container(
                        alignment: Alignment.center,
                        height: screenFormat == ScreenFormat.desktop
                            ? desktopImportContainerHeight
                            : tabletImportContainerHeight,
                        width: screenFormat == ScreenFormat.desktop
                            ? desktopImportContainerWidth
                            : tabletImportContainerWidth,
                        color: Colors.grey[400],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload,
                              size: 32.0,
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              AppLocalizations.of(context)!.imageClickToAdd,
                              textAlign: TextAlign.center,
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
                              height: 10,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0))),
                              onPressed: () async {
                                picked = await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );

                                if (!mounted) {
                                  return;
                                }
                                if (picked != null) {
                                  if (picked!.files.single.bytes!.length >
                                      1000000) {
                                    showCustomToast(
                                      context,
                                      AppLocalizations.of(context)!
                                          .imageSizeMax,
                                      false,
                                    );
                                  } else {
                                    openAddDialog(context);
                                  }
                                }
                                setState(() {});
                              },
                              child: Text(
                                AppLocalizations.of(context)!.browse,
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
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: sizedBoxWidth,
                      child: const Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 30,
                        endIndent: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromWidth(
                              screenFormat == ScreenFormat.desktop
                                  ? desktopButtonWidth
                                  : tabletButtonWidth),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) =>
                              RemoveDesignDialog(callback: removeImage),
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.imageRemoval,
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
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(
                            screenFormat == ScreenFormat.desktop
                                ? desktopButtonWidth
                                : tabletButtonWidth),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () async {
                        String name = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => openDialog());
                        if (name != '') {
                          saveContainer(name);
                        }
                      },
                      icon: Icon(
                        Icons.save,
                        color: Provider.of<ThemeService>(context).isDark
                            ? darkTheme.primaryColor
                            : lightTheme.primaryColor,
                      ),
                      label: Text(
                        AppLocalizations.of(context)!.saveAction,
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
                ),
              ],
            ),
          ),
          loadCube(),
          Flexible(
            child: FractionallySizedBox(
              widthFactor: screenFormat == ScreenFormat.desktop
                  ? desktopRecapPanelWidth
                  : tabletRecapPanelWidth,
              heightFactor: 0.7,
              child: RecapPanel(
                articles: lockerss,
                screenFormat: screenFormat,
                fullscreen: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
