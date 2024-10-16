import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:front/components/alert_dialog.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/custom_footer.dart';
import 'package:front/components/custom_toast.dart';
import 'package:front/components/dialog/autofill_dialog.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/components/dialog/delete_container_dialog.dart';
import 'package:front/components/dialog/save_dialog.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel/recap_panel.dart';
import 'package:front/network/informations.dart';
import 'package:front/screens/container-creation/container_creation/container_creation_style.dart';
import 'package:front/services/http_service.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/size_service.dart';
import 'package:front/services/storage_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/globalStyle.dart';
import 'package:front/styles/themes.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:tuple/tuple.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';

/// ContainerCreation
///
/// Creation of the container
/// [container] : Informations about the container
/// [containerMapping] : String that contains numbers representing where lockers is positioned in the container.
/// [width] : Container's width
/// [height] : Container's height
// ignore: must_be_immutable
class ContainerCreation extends StatefulWidget {
  ContainerCreation({
    super.key,
    this.id,
    this.container,
    this.containerMapping,
    this.width,
    this.height,
  });

  String? id;
  String? container;
  String? containerMapping;
  String? width;
  String? height;

  @override
  State<ContainerCreation> createState() => ContainerCreationState();
}

/// ContainerCreationState
///
class ContainerCreationState extends State<ContainerCreation> {
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;
  bool isLoaded = false;
  List<Locker> lockers = [];
  double actualRotationDegree = 0.0;
  String jwtToken = '';
  bool unitTest = false;
  String? containerMappingStocked = '';
  late int width = 0;
  late int height = 0;
  List<String> inputLockers = [];

  /// [Function] : Check the token in the storage service
  void checkToken() async {
    String? token = await storageService.readStorage('token');
    if (token != "") {
      jwtToken = token!;
    } else {
      jwtToken = "";
    }
  }

  Future<void> checkContainer() async {
    var storageData = await getContainerFromStorage();
    if (storageData != "") {
      setState(() {
        dynamic data = jsonDecode(storageData);
        if (data['container'] != '') {
          widget.container = data['container'];
        }
        widget.containerMapping = data['containerMappingShape'];
        containerMappingStocked = data['containerMapping'];
        widget.width = data['width'];
        widget.height = data['height'];
        if (data['input'] != null) {
          inputLockers = jsonDecode(data['input']);
        }

        widget.id = data['id'];
      });
    }
  }

  @override
  void initState() {
    MyAlertTest.checkSignInStatus(context);
    checkToken();

    world = Sp3dWorld(objs);

    checkContainer().then((result) {
      setState(() {
        if (widget.container != null) {
          dynamic container = jsonDecode(widget.container!);
          width = int.parse(container['width']);
          height = int.parse(container['height']);
        } else if (widget.width != null && widget.height != null) {
          width = int.parse(widget.width!);
          height = int.parse(widget.height!);
        }

        Sp3dObj obj = UtilSp3dGeometry.cube(
            cubeWidth, cubeHeight - 20, 50, width, height, 2);
        obj.materials.add(FSp3dMaterial.green.deepCopy());
        obj.materials.add(FSp3dMaterial.red.deepCopy());
        obj.materials.add(FSp3dMaterial.blue.deepCopy());
        obj.materials.add(FSp3dMaterial.black.deepCopy());
        obj.materials[0] = FSp3dMaterial.grey.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        obj.materials[1] = FSp3dMaterial.green.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        obj.materials[2] = FSp3dMaterial.red.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        obj.materials[3] = FSp3dMaterial.blue.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        obj.materials[4] = FSp3dMaterial.black.deepCopy()
          ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
        objs.add(obj);
        loadImage();
        bool loaded = false;
        if (widget.container != null) {
          loadContainer();
          dynamic container = jsonDecode(widget.container!);
          loadLockers(container['containerMapping'],
              design: jsonDecode(container['designs']));
          loaded = true;
        }

        if (containerMappingStocked != '') {
          if (loaded == false) {
            loadLockers(containerMappingStocked!);
            loaded = true;
          }
          for (int i = 0; i < containerMappingStocked!.length; i++) {
            objs[0].fragments[i].faces[0].materialIndex =
                int.parse(containerMappingStocked![i]);
            objs[0].fragments[i].faces[1].materialIndex =
                int.parse(containerMappingStocked![i]);
            objs[0].fragments[i].faces[2].materialIndex =
                int.parse(containerMappingStocked![i]);
            objs[0].fragments[i].faces[3].materialIndex =
                int.parse(containerMappingStocked![i]);
            objs[0].fragments[i].faces[4].materialIndex =
                int.parse(containerMappingStocked![i]);
            objs[0].fragments[i].faces[5].materialIndex =
                int.parse(containerMappingStocked![i]);
          }
        }
        if (widget.containerMapping != null) {
          dynamic decoded = jsonDecode(widget.containerMapping!);
          setState(() {
            if (loaded == false) {
              loadLockers(widget.containerMapping!);
              loaded = true;
            }
            for (int i = 0; i < decoded.length; i++) {
              for (int j = 0; j < decoded[i].length; j++) {
                if (decoded[i][j].toString() == '2') {
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[0]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[1]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[2]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[3]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[4]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[(decoded[i].length * i) + j]
                      .faces[5]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[0]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[1]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[2]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[3]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[4]
                      .materialIndex = 4;
                  objs[0]
                      .fragments[
                          ((decoded[i].length * i) + j) + (width * height)]
                      .faces[5]
                      .materialIndex = 4;
                }
              }
            }
          });
        }
        super.initState();
      });
    });
  }

  /// [Function] : Load the container's informations
  void loadContainer() {
    dynamic container = jsonDecode(widget.container!);
    width = int.parse(container['width']);
    height = int.parse(container['height']);

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

  /// [Function] : Load the lockers' informations in the container
  void loadLockers(dynamic containerMapping, {design}) {
    int littleLocker = 0;
    int mediumLocker = 0;
    int bigLocker = 0;

    for (int i = 0; i < containerMapping.length; i++) {
      if (containerMapping[i] == '1') {
        littleLocker++;
      } else if (containerMapping[i] == '2') {
        mediumLocker++;
      } else if (containerMapping[i] == '3') {
        bigLocker++;
      }
    }

    if (design != null) {
      for (int i = 0; i < design.length; i++) {
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

  /// [Function] : Update the size of the container
  String updateCube(LockerCoordinates coordinates, bool unitTesting) {
    int fragment = coordinates.x - 1 + (coordinates.y - 1) * width;
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

    inputLockers.add(jsonEncode(coordinates.toJson()));

    if (coordinates.face == 'Derrière') {
      fragment += width * height;
    }

    if (coordinates.direction == 'Haut') {
      increment += width;
    } else if (coordinates.direction == 'Bas') {
      increment -= width;
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
        if (unitTest == false) {
          saveContainerToStorage();
        }
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
      if (unitTest == false) {
        saveContainerToStorage();
      }
    }
    return "";
  }

  /// [Widget] : Open dialog for the name of the container
  Widget openDialog() {
    if (widget.container != null) {
      return SaveDialog(name: jsonDecode(widget.container!)['saveName']);
    } else {
      return SaveDialog();
    }
  }

  /// [Function] : Allow the locker to be moved
  void moveLocker(
      int x, int y, int size, int oldX, int oldY, int fragmentIncrement) {
    for (int i = 0; i < size; i++) {
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[0]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[1]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[2]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[3]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[4]
          .materialIndex = 0;
      objs[0]
          .fragments[oldX + (oldY + i) * width + fragmentIncrement]
          .faces[5]
          .materialIndex = 0;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[0]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[1]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[2]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[3]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[4]
          .materialIndex = size;
      objs[0]
          .fragments[x + (y + i) * width + fragmentIncrement]
          .faces[5]
          .materialIndex = size;
    }
  }

  /// [Function] : Handle the locker
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

  /// [Function] : Optimize the space in the containers by automatically filling the lockers
  void autoFilling(int fragmentIncrement) {
    List<String> freeSpace = [];
    int widths = width;
    int heights = height;
    Tuple2<int, int> ret = const Tuple2<int, int>(0, 0);

    for (int i = 0; i < widths; i++) {
      for (int j = 0; j < heights;) {
        int counter = 0;
        if (objs[0]
                .fragments[j * widths + i + fragmentIncrement]
                .faces[0]
                .materialIndex ==
            0) {
          int k = 0;
          for (k = j * widths + i + fragmentIncrement;
              counter + j < heights &&
                  objs[0].fragments[k].faces[0].materialIndex == 0;
              k += widths, counter++) {}

          freeSpace.add("$i,$j,$counter");
        }
        if (objs[0]
                .fragments[j * widths + i + fragmentIncrement]
                .faces[0]
                .materialIndex ==
            4) {
          counter = 1;
        }
        if (objs[0]
                    .fragments[j * widths + i + fragmentIncrement]
                    .faces[0]
                    .materialIndex !=
                0 &&
            objs[0]
                    .fragments[j * widths + i + fragmentIncrement]
                    .faces[0]
                    .materialIndex !=
                4) {
          int size = objs[0]
              .fragments[j * widths + i + fragmentIncrement]
              .faces[0]
              .materialIndex!;
          if (freeSpace.isNotEmpty) {
            ret = handleMoveLocker(freeSpace, i, j, fragmentIncrement, size);
            if (ret.item1 != -1) {
              i = ret.item1;
              j = ret.item2;
            } else {
              j += size;
            }
          } else {
            j += size;
          }
        } else {
          j += counter;
        }
        if (j == heights) {
          break;
        }
      }
    }
  }

  /// [Function] : Optimize the space in the containers by automatically decrease the container's size
  void autoFillContainer(String face, bool unitTesting) {
    int fragmentIncrement = 0;

    if (face == 'Derrière') {
      fragmentIncrement = width * height;
    }

    autoFilling(fragmentIncrement);

    if (face == "Toutes") {
      fragmentIncrement = width * height;
      autoFilling(fragmentIncrement);
    }
    if (unitTesting == false) {
      setState(() {
        isLoaded = true;
        if (unitTest == false) {
          saveContainerToStorage();
        }
      });
    } else {
      isLoaded = true;
      if (unitTest == false) {
        saveContainerToStorage();
      }
    }
  }

  /// [Function] : Load an image for the container's design
  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  /// [Function] : Sum of the price of the lockers
  int sumPrice() {
    int price = 0;
    for (int i = 0; i < lockers.length; i++) {
      price += lockers[i].price;
    }
    return price;
  }

  /// [Function] : Reset the container
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
        if (unitTest == false) {
          saveContainerToStorage();
        }
      });
    } else {
      lockers = [];
      if (unitTest == false) {
        saveContainerToStorage();
      }
    }
  }

  bool checkCoordinates(LockerCoordinates coord) {
    for (int i = 0; i < inputLockers.length; i++) {
      dynamic decoded = jsonDecode(inputLockers[i]);
      if (decoded['x'] == coord.x &&
          decoded['y'] == coord.y &&
          decoded['face'] == coord.face) {
        inputLockers.removeAt(i);
        return true;
      }
    }
    return false;
  }

  /// [Function] : Delete a locker
  /// [coord] : the locker's position in the container
  /// [unitTesting] : Boolean that says if we came here from unit test or not
  String deleteLocker(LockerCoordinates coord, bool unitTesting) {
    int fragment = coord.x - 1 + (coord.y - 1) * width;
    int increment = width;

    if (coord.face == 'Derrière') {
      fragment += width * height;
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

    if (checkCoordinates(coord) == false) {
      return "notFoundError";
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

  /// [Function] : Save the container in the storage service
  void saveContainerToStorage() {
    dynamic input;
    if (inputLockers.isNotEmpty) {
      input = jsonEncode(inputLockers);
    } else {
      input = [];
    }
    var data = {
      'amount': sumPrice(),
      'containerMapping': getContainerMapping(),
      'lockers': jsonEncode(lockers),
      'id': widget.id,
      'container': widget.container,
      'width': width.toString(),
      'height': height.toString(),
      'input': input,
    };

    storageService.writeStorage('containerData', jsonEncode(data));
  }

  Future<String> getContainerFromStorage() async {
    String? data = await storageService.readStorage('containerData');

    data ??= '';
    return data;
  }

  /// [Function] : Get the containerMapping of a container
  String getContainerMapping() {
    String mapping = "";
    if (objs.isNotEmpty) {
      for (int i = 0; i < objs[0].fragments.length; i++) {
        mapping += objs[0].fragments[i].faces[0].materialIndex.toString();
      }
    }
    return mapping;
  }

  /// [Function] : Go to the next page
  void goNext() async {
    var data = {
      'amount': sumPrice(),
      'containerMapping': getContainerMapping(),
      'lockers': jsonEncode(lockers),
      'id': widget.id,
      'container': widget.container,
      'width': width.toString(),
      'height': height.toString(),
    };
    if (unitTest == false) {
      saveContainerToStorage();
    }
    context.go("/container-creation/design", extra: jsonEncode(data));
  }

  /// [Function] : Save the container
  /// [name] : name of the container
  void saveContainer(String name) async {
    var header = <String, String>{
      'Authorization': 'Bearer $jwtToken',
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    if (widget.id == null) {
      dynamic body;
      if (widget.container != null) {
        body = {
          'containerMapping': getContainerMapping(),
          'designs': jsonDecode(widget.container!)['designs'],
          'width': width,
          'height': height,
          'saveName': name,
          'input': jsonEncode(inputLockers),
        };
      } else {
        body = {
          'containerMapping': getContainerMapping(),
          'width': width,
          'height': height,
          'saveName': name,
          'input': jsonEncode(inputLockers),
        };
      }

      HttpService()
          .request('http://$serverIp:3000/api/container/create', header, body)
          .then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          showCustomToast(context, value.body, false);
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
          'width': width,
          'height': height,
          'city': '',
          'informations': '',
          'address': '',
          'saveName': name,
          'input': jsonEncode(inputLockers),
        };
      } else {
        body = {
          'id': widget.id!,
          'containerMapping': getContainerMapping(),
          'price': sumPrice().toString(),
          'width': width,
          'height': height,
          'city': '',
          'informations': '',
          'address': '',
          'saveName': name,
          'input': jsonEncode(inputLockers),
        };
      }
      HttpService()
          .putRequest(
              'http://$serverIp:3000/api/container/update', header, body)
          .then((value) {
        if (value.statusCode == 200) {
          context.go("/confirmation-save");
        } else {
          showCustomToast(context, value.body, false);
        }
      });
    }
  }

  /// [Function] : Go to the previous page
  void goPrevious() {
    context.go('/container-creation/shape');
  }

  /// [Widget]: build the configurator page
  @override
  Widget build(BuildContext context) {
    ScreenFormat screenFormat = SizeService().getScreenFormat(context);

    return Scaffold(
      appBar: CustomAppBar(
        AppLocalizations.of(context)!.configurator,
        context: context,
      ),
      body: FooterView(
        flex: 8,
        footer: Footer(
          child: const CustomFooter(),
        ),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.85,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                                  width: width,
                                  height: height,
                                ),
                              );
                              if (unitTest == false) {
                                saveContainerToStorage();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                    screenFormat == ScreenFormat.desktop
                                        ? desktopButtonWidth
                                        : tabletButtonWidth),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            label: Text(
                              AppLocalizations.of(context)!.lockerAdd,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                            icon: Icon(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              Icons.add,
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
                                fixedSize: Size.fromWidth(
                                    screenFormat == ScreenFormat.desktop
                                        ? desktopButtonWidth
                                        : tabletButtonWidth),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
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
                            icon: Icon(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              Icons.save,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              String face = await showDialog(
                                  context: context,
                                  builder: (context) => AutoFillDialog(
                                      callback: autoFillContainer));
                              autoFillContainer(face, false);
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                    screenFormat == ScreenFormat.desktop
                                        ? desktopButtonWidth
                                        : tabletButtonWidth),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            label: Text(
                              AppLocalizations.of(context)!.filling,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                            icon: Icon(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              Icons.auto_fix_high,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: sizedBoxWidth,
                            child: Divider(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
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
                                  builder: (context) => DeleteContainerDialog(
                                      callback: deleteLocker));
                              if (unitTest == false) {
                                saveContainerToStorage();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                    screenFormat == ScreenFormat.desktop
                                        ? desktopButtonWidth
                                        : tabletButtonWidth),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            label: Text(
                              AppLocalizations.of(context)!.deleteLocker,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                            icon: Icon(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              Icons.delete,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton.icon(
                            onPressed: resetContainer,
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size.fromWidth(
                                    screenFormat == ScreenFormat.desktop
                                        ? desktopButtonWidth
                                        : tabletButtonWidth),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0))),
                            label: Text(
                              AppLocalizations.of(context)!.containerReset,
                              style: TextStyle(
                                color: Provider.of<ThemeService>(context).isDark
                                    ? darkTheme.primaryColor
                                    : lightTheme.primaryColor,
                                fontSize: screenFormat == ScreenFormat.desktop
                                    ? desktopFontSize
                                    : tabletFontSize,
                              ),
                            ),
                            icon: Icon(
                              color: Provider.of<ThemeService>(context).isDark
                                  ? darkTheme.primaryColor
                                  : lightTheme.primaryColor,
                              Icons.refresh,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Sp3dRenderer(
                            Size(cubeCameraWidth, cubeCameraHeight),
                            Sp3dV2D(cubeCameraWidth / 2, cubeCameraHeight / 2),
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
                    const SizedBox(
                      width: 50,
                    ),
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: screenFormat == ScreenFormat.desktop
                            ? desktopRecapPanelWidth
                            : tabletRecapPanelWidth,
                        heightFactor: 0.7,
                        child: RecapPanel(
                          articles: lockers,
                          screenFormat: screenFormat,
                          fullscreen: false,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ProgressBar(
                length: 6,
                progress: 1,
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
        ],
      ),
    );
  }
}
