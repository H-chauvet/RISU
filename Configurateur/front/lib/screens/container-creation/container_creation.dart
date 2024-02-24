import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/components/dialog/delete_container_dialog.dart';
import 'package:front/components/dialog/save_dialog.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:tuple/tuple.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';

import '../../components/dialog/autofill_dialog.dart';

// ignore: must_be_immutable
class ContainerCreation extends StatefulWidget {
  ContainerCreation({super.key, this.id, this.container});

  final String? id;
  String? container;

  @override
  State<ContainerCreation> createState() => ContainerCreationState();
}

///
/// ContainerCreation
///
/// page d'inscription pour le configurateur
class ContainerCreationState extends State<ContainerCreation> {
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;
  bool isLoaded = false;
  List<Locker> lockers = [];
  double actualRotationDegree = 0.0;
  String jwtToken = '';
  dynamic decodedContainer;
  bool unitTest = false;

  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      jwtToken = "";
    }
  }

  @override
  void initState() {
    checkToken();
    MyAlertTest.checkSignInStatus(context);
    super.initState();
    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 12, 5, 2);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    objs.add(obj);
    loadImage();
    if (widget.container != null) {
      loadContainer();

      loadLockers();
    }
  }

  void loadContainer() {
    dynamic container = jsonDecode(widget.container!);
    for (int i = 0; i < container['containerMapping'].length; i++) {
      if (container['containerMapping'] != '0') {
        objs[0].fragments[i].faces[0].materialIndex =
            int.parse(container['containerMapping'][i]);
        objs[0].fragments[i].faces[1].materialIndex =
            int.parse(container['containerMapping'][i]);
        objs[0].fragments[i].faces[2].materialIndex =
            int.parse(container['containerMapping'][i]);
        objs[0].fragments[i].faces[3].materialIndex =
            int.parse(container['containerMapping'][i]);
        objs[0].fragments[i].faces[4].materialIndex =
            int.parse(container['containerMapping'][i]);
        objs[0].fragments[i].faces[5].materialIndex =
            int.parse(container['containerMapping'][i]);
      }
    }
    setState(() {
      isLoaded = true;
    });
  }

  void loadLockers() {
    int littleLocker = 0;
    int mediumLocker = 0;
    int bigLocker = 0;
    dynamic container = jsonDecode(widget.container!);

    for (int i = 0; i < container['containerMapping'].length; i++) {
      if (container['containerMapping'][i] == '1') {
        littleLocker++;
      } else if (container['containerMapping'][i] == '2') {
        mediumLocker++;
      } else if (container['containerMapping'][i] == '3') {
        bigLocker++;
      }
    }

    decodedContainer = jsonDecode(container['designs']);

    if (decodedContainer != null) {
      for (int i = 0; i < decodedContainer.length; i++) {
        lockers.add(Locker('Design personnalisé', 50));
      }
    }

    for (int i = 0; i < littleLocker; i++) {
      lockers.add(Locker('Petit casier', 50));
    }
    for (int i = 0; i < mediumLocker / 2; i++) {
      lockers.add(Locker('Moyen casier', 100));
    }
    for (int i = 0; i < bigLocker / 3; i++) {
      lockers.add(Locker('Grand casier', 150));
    }
  }

  String updateCube(LockerCoordinates coordinates, bool unitTesting) {
    int fragment = coordinates.x - 1 + (coordinates.y - 1) * 12;
    int increment = 0;
    int color = 0;

    switch (coordinates.size) {
      case 1:
        color = 1;
        break;
      case 2:
        color = 2;
        break;
      case 3:
        color = 3;
        break;
      default:
        color = 1;
        coordinates.size = 1;
        break;
    }

    if (coordinates.face == 'Derrière') {
      fragment += 60;
    }

    if (coordinates.direction == 'Haut') {
      increment += 12;
    } else if (coordinates.direction == 'Bas') {
      increment -= 12;
    }

    for (int i = 0; i < coordinates.size; i++) {
      if (objs[0].fragments[fragment].faces[0].materialIndex != 0) {
        return "overwriteError";
      }
      fragment += increment;
    }

    fragment -= coordinates.size * increment;

    for (int i = 0; i < coordinates.size; i++) {
      objs[0].fragments[fragment].faces[0].materialIndex = color;
      objs[0].fragments[fragment].faces[1].materialIndex = color;
      objs[0].fragments[fragment].faces[2].materialIndex = color;
      objs[0].fragments[fragment].faces[3].materialIndex = color;
      objs[0].fragments[fragment].faces[4].materialIndex = color;
      objs[0].fragments[fragment].faces[5].materialIndex = color;
      fragment += increment;
    }

    if (unitTesting == false) {
      setState(() {
        switch (coordinates.size) {
          case 1:
            lockers.add(Locker('Petit casier', 50));
            break;
          case 2:
            lockers.add(Locker('Moyen casier', 100));
            break;
          case 3:
            lockers.add(Locker('Grand casier', 150));
            break;
          default:
            lockers.add(Locker('Petit casier', 50));
            break;
        }
        isLoaded = true;
      });
    } else {
      switch (coordinates.size) {
        case 1:
          lockers.add(Locker('Petit casier', 50));
          break;
        case 2:
          lockers.add(Locker('Moyen casier', 100));
          break;
        case 3:
          lockers.add(Locker('Grand casier', 150));
          break;
        default:
          break;
      }
    }
    return "";
  }

  Widget openDialog() {
    if (widget.container != null) {
      return SaveDialog(name: jsonDecode(widget.container!)['saveName']);
    } else {
      return SaveDialog();
    }
  }

  void moveLocker(
      int x, int y, int size, int oldX, int oldY, int fragmentIncrement) {
    for (int i = 0; i < size; i++) {
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[0]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[1]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[2]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[3]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[4]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * 12 + fragmentIncrement]
          .faces[5]
          .materialIndex = 0;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[0]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[1]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[2]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[3]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[4]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * 12 + fragmentIncrement]
          .faces[5]
          .materialIndex = size;
    }
  }

  Tuple2<int, int> handleMoveLocker(
      List<String> freeSpace, int i, int j, int fragmentIncrement, int size) {
    for (int k = 0; k < freeSpace.length; k++) {
      List<String> coordinates = freeSpace[k].split(',');
      int x = int.parse(coordinates[0]);
      int y = int.parse(coordinates[1]);
      int counter = int.parse(coordinates[2]);

      if (counter >= size) {
        moveLocker(x, y, size, i, j, fragmentIncrement);
        freeSpace.clear();
        return const Tuple2(0, 0);
      }
    }
    return const Tuple2(-1, -1);
  }

  void autoFilling(int fragmentIncrement) {
    List<String> freeSpace = [];
    int width = 12;
    int height = 5;
    Tuple2<int, int> ret = const Tuple2<int, int>(0, 0);

    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height;) {
        int counter = 0;
        if (objs[0]
                .fragments[j * width + i + fragmentIncrement]
                .faces[0]
                .materialIndex ==
            0) {
          int k = 0;
          for (k = j * width + i + fragmentIncrement;
              counter + j < height &&
                  objs[0].fragments[k].faces[0].materialIndex == 0;
              k += width, counter++) {}
          freeSpace.add("$i,$j,$counter");
        }
        if (objs[0]
                .fragments[j * width + i + fragmentIncrement]
                .faces[0]
                .materialIndex !=
            0) {
          int size = objs[0]
              .fragments[j * width + i + fragmentIncrement]
              .faces[0]
              .materialIndex!;
          if (freeSpace.isNotEmpty) {
            ret = handleMoveLocker(freeSpace, i, j, fragmentIncrement, size);
            if (ret.item1 != -1) {
              i = ret.item1;
              j = ret.item2;
            }
          }
          j += size;
        } else {
          j += counter;
        }
        if (j == height) {
          break;
        }
      }
    }
  }

  void autoFillContainer(String face, bool unitTesting) {
    int fragmentIncrement = 0;

    if (face == 'Derrière') {
      fragmentIncrement = 60;
    }

    autoFilling(fragmentIncrement);

    if (face == "Toutes") {
      fragmentIncrement = 60;
      autoFilling(fragmentIncrement);
    }
    if (unitTesting == false) {
      setState(() {
        isLoaded = true;
      });
    } else {
      isLoaded = true;
    }
  }

  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  int sumPrice() {
    int price = 0;
    for (int i = 0; i < lockers.length; i++) {
      price += lockers[i].price;
    }
    return price;
  }

  void resetContainer() {
    for (int i = 0; i < objs[0].fragments.length; i++) {
      objs[0].fragments[i].faces[0].materialIndex = 0;
      objs[0].fragments[i].faces[1].materialIndex = 0;
      objs[0].fragments[i].faces[2].materialIndex = 0;
      objs[0].fragments[i].faces[3].materialIndex = 0;
      objs[0].fragments[i].faces[4].materialIndex = 0;
      objs[0].fragments[i].faces[5].materialIndex = 0;
    }

    if (unitTest == false) {
      setState(() {
        lockers = [];
      });
    } else {
      lockers = [];
    }
  }

  String deleteLocker(LockerCoordinates coord, bool unitTesting) {
    int fragment = coord.x - 1 + (coord.y - 1) * 12;
    int increment = 12;

    if (coord.face == 'Derrière') {
      fragment += 60;
    }

    int size = objs[0].fragments[fragment].faces[0].materialIndex!;

    if (objs[0].fragments[fragment].faces[0].materialIndex == 0) {
      return "deleteError";
    }

    for (int i = 0; i < size; i++) {
      if (objs[0].fragments[fragment].faces[0].materialIndex != size) {
        return "wrongPositionError";
      }
      fragment += increment;
    }

    fragment -= size * increment;

    for (int i = 0; i < size; i++) {
      objs[0].fragments[fragment].faces[0].materialIndex = 0;
      objs[0].fragments[fragment].faces[1].materialIndex = 0;
      objs[0].fragments[fragment].faces[2].materialIndex = 0;
      objs[0].fragments[fragment].faces[3].materialIndex = 0;
      objs[0].fragments[fragment].faces[4].materialIndex = 0;
      objs[0].fragments[fragment].faces[5].materialIndex = 0;
      fragment += increment;
    }

    if (unitTesting == false) {
      setState(() {
        for (int i = 0; i < lockers.length; i++) {
          if (lockers[i].type == 'Petit casier' && size == 1) {
            lockers.removeAt(i);
            break;
          }
          if (lockers[i].type == 'Moyen casier' && size == 2) {
            lockers.removeAt(i);
            break;
          }
          if (lockers[i].type == 'Grand casier' && size == 3) {
            lockers.removeAt(i);
            break;
          }
        }
        isLoaded = true;
      });
    } else {
      for (int i = 0; i < lockers.length; i++) {
        if (lockers[i].type == 'Petit Casier' && size == 1) {
          lockers.removeAt(i);
          break;
        }
        if (lockers[i].type == 'Moyen Casier' && size == 2) {
          lockers.removeAt(i);
          break;
        }
        if (lockers[i].type == 'Grand Casier' && size == 3) {
          lockers.removeAt(i);
          break;
        }
      }
    }
    return "deleted";
  }

  String getContainerMapping() {
    String mapping = "";
    for (int i = 0; i < objs[0].fragments.length; i++) {
      mapping += objs[0].fragments[i].faces[0].materialIndex.toString();
    }
    return mapping;
  }

  void goNext() async {
    var data = {
      'amount': sumPrice(),
      'containerMapping': getContainerMapping(),
      'lockers': jsonEncode(lockers),
      'id': widget.id,
      'container': widget.container,
    };
    context.go("/container-creation/design", extra: jsonEncode(data));
  }

  void saveContainer(String name) async {
    var header = <String, String>{
      'Authorization': jwtToken,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    if (widget.id == null) {
      dynamic body;
      if (widget.container != null) {
        body = {
          'containerMapping': getContainerMapping(),
          'designs': jsonDecode(widget.container!)['designs'],
          'width': '12',
          'height': '5',
          'saveName': name,
        };
      } else {
        body = {
          'containerMapping': getContainerMapping(),
          'width': '12',
          'height': '5',
          'saveName': name,
        };
      }

      HttpService()
          .request('http://$serverIp:3000/api/container/create', header, body)
          .then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          Fluttertoast.showToast(
            msg: "Echec de la sauvegarde",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
        }
      });
    } else {
      dynamic body;
      if (widget.container != null) {
        body = {
          'id': widget.id!,
          'containerMapping': getContainerMapping(),
          'price': sumPrice().toString(),
          'designs': jsonDecode(widget.container!)['designs'],
          'width': '12',
          'height': '5',
          'city': '',
          'informations': '',
          'address': '',
          'saveName': name,
        };
      } else {
        body = {
          'id': widget.id!,
          'containerMapping': getContainerMapping(),
          'price': sumPrice().toString(),
          'width': '12',
          'height': '5',
          'city': '',
          'informations': '',
          'address': '',
          'saveName': name,
        };
      }
      HttpService()
          .putRequest(
              'http://$serverIp:3000/api/container/update', header, body)
          .then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          Fluttertoast.showToast(
            msg: "Echec de la sauvegarde",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
          );
        }
      });
    }
  }

  void goPrevious() {
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Configurateur',
          context: context,
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 4,
              progress: 0,
              previous: 'Précédent',
              next: 'Suivant',
              previousFunc: goPrevious,
              nextFunc: goNext,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
        body: Stack(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 50,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) => ContainerDialog(
                                  callback: updateCube,
                                  size: 1,
                                ));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      label: const Text(
                        'Ajouter un casier',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        String name = await showDialog(
                            context: context,
                            builder: (context) => openDialog());
                        saveContainer(name);
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      label: const Text(
                        'Sauvegarder',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        String face = await showDialog(
                            context: context,
                            builder: (context) =>
                                AutoFillDialog(callback: autoFillContainer));
                        autoFillContainer(face, false);
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      label: const Text(
                        'Remplissage',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.auto_fix_high,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 225,
                      child: Divider(
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
                      onPressed: () async {
                        await showDialog(
                            context: context,
                            builder: (context) =>
                                DeleteContainerDialog(callback: deleteLocker));
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      label: const Text(
                        'Supprimer un casier',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: resetContainer,
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(250),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      label: const Text(
                        'Réinitialiser le conteneur',
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Sp3dRenderer(
                      const Size(1000, 1000),
                      const Sp3dV2D(400, 400),
                      world,
                      // If you want to reduce distortion, shoot from a distance at high magnification.
                      Sp3dCamera(Sp3dV3D(0, 0, 3000), 6000),
                      Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
                      allowUserWorldRotation: true,
                      allowUserWorldZoom: false,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.6,
                    child: RecapPanel(
                      articles: lockers,
                      onSaved: () async {
                        String name = await showDialog(
                            context: context,
                            builder: (context) => openDialog());
                        saveContainer(name);
                      },
                    )),
              ),
              const SizedBox(
                width: 50,
              )
            ],
          )
        ]));
  }
}
