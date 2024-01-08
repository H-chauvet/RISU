import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/services/http_service.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

import '../../components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../components/progress_bar.dart';
import '../../components/recap_panel.dart';
import '../../network/informations.dart';
import '../../services/storage_service.dart';

const List<String> faceList = <String>[
  'Devant',
  'Derrière',
  'Droite',
  'Gauche',
  'Haut',
  'Bas'
];

class DesignScreen extends StatefulWidget {
  const DesignScreen(
      {super.key, this.lockers, this.amount, this.containerMapping});

  final String? lockers;
  final int? amount;
  final String? containerMapping;

  @override
  State<DesignScreen> createState() => DesignScreenState();
}

///
/// ContainerCreation
///
/// page d'inscription pour le configurateur
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
  String face = faceList.first;
  List<List<int>> designss = [];

  @override
  void initState() {
    if (token != "") {
      jwtToken = token;
    } else {
      context.go(
        '/login',
      );
    }
    /*StorageService().readStorage('token').then((value) => {
          if (value == null)
            {context.go("/login")}
          else
            {
              jwtToken = value,
            }
        });*/
    super.initState();
    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());

    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    objs.add(obj);
    loadImage(false).then((value) => null);
    if (widget.lockers != null) {
      decodeLockers();
    }
  }

  void decodeLockers() {
    final decode = jsonDecode(widget.lockers!);

    for (int i = 0; i < decode.length; i++) {
      lockerss.add(Locker(decode[i]['type'], decode[i]['price']));
    }
  }

  Future<void> loadImage(bool unitTesting, {Uint8List? fileData}) async {
    if (fileData != null) {
      int faceIndex = 0;
      switch (face) {
        case 'Devant':
          lockerss.add(Locker('design face avant', 50));
          faceIndex = 0;
          break;
        case 'Derrière':
          lockerss.add(Locker('design face arrière', 50));
          faceIndex = 1;
          break;
        case 'Bas':
          lockerss.add(Locker('design face du dessous', 50));
          faceIndex = 4;
          break;
        case 'Gauche':
          lockerss.add(Locker('design côté gauche', 50));
          faceIndex = 3;
          break;
        case 'Haut':
          lockerss.add(Locker('design face du haut', 50));
          faceIndex = 2;
          break;
        case 'Droite':
          lockerss.add(Locker('design côté droit', 50));
          faceIndex = 5;
          break;
        default:
          lockerss.add(Locker('design face avant', 50));
          faceIndex = 0;
          break;
      }
      objs[0].materials.add(FSp3dMaterial.black);
      objs[0].materials[materialIndex] = FSp3dMaterial.green.deepCopy()
        ..imageIndex = imageIndex
        ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
      objs[0].fragments[0].faces[faceIndex].materialIndex = materialIndex;
      objs[0].images.add(fileData);
      designss.add(picked!.files.first.bytes!.toList());
      imageIndex++;
      materialIndex++;
    }
    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
      if (unitTesting == false) {
        setState(() {
          isLoaded = true;
        });
      } else {
        isLoaded = true;
      }
    });
  }

  Future<void> removeImage(bool unitTesting) async {
    picked = null;
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
    removeDesign(faceIndex);
    objs[0].fragments[0].faces[faceIndex].materialIndex = 0;

    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
      if (unitTesting == false) {
        setState(() {
          isLoaded = true;
        });
      } else {
        isLoaded = true;
      }
    });
  }

  void removeDesign(int faceIndex) {
    for (int i = 0; i < lockerss.length; i++) {
      if (lockerss[i].type == 'design face avant' && faceIndex == 0) {
        lockerss.removeAt(i);
        return;
      } else if (lockerss[i].type == 'design face arrière' && faceIndex == 1) {
        lockerss.removeAt(i);
        return;
      } else if (lockerss[i].type == 'design face du dessous' &&
          faceIndex == 4) {
        lockerss.removeAt(i);
        return;
      } else if (lockerss[i].type == 'design côté gauche' && faceIndex == 3) {
        lockerss.removeAt(i);
        return;
      } else if (lockerss[i].type == 'design face du haut' && faceIndex == 2) {
        lockerss.removeAt(i);
        return;
      } else if (lockerss[i].type == 'design côté droit' && faceIndex == 5) {
        lockerss.removeAt(i);
        return;
      }
    }
  }

  int sumPrice() {
    int price = 0;
    for (int i = 0; i < lockerss.length; i++) {
      price += lockerss[i].price;
    }
    return price;
  }

  String getContainerMapping() {
    String mapping = "";
    for (int i = 0; i < objs[0].fragments.length; i++) {
      mapping += objs[0].fragments[i].faces[0].materialIndex.toString();
    }
    return mapping;
  }

  void goNext() async {
    HttpService().request(
      'http://$serverIp:3000/api/container/create',
      <String, String>{
        'Authorization': jwtToken,
        'Content-Type': 'application/json; charset=UTF-8',
        'Access-Control-Allow-Origin': '*',
      },
      <String, dynamic>{
        'designs': json.encode(designss),
      },
    ).then((value) {
      if (value.statusCode != 200) {
        return;
      }
      dynamic response = jsonDecode(value.body);

      var data = {
        'id': response['id'],
        'amount': sumPrice(),
        'containerMapping': widget.containerMapping,
        'lockers': jsonEncode(lockerss),
      };
      context.go("/container-creation/recap", extra: jsonEncode(data));
    });
  }

  void goPrevious() {
    var data = {
      'amount': sumPrice(),
      'containerMapping': getContainerMapping(),
      'lockers': jsonEncode(lockerss),
    };
    context.go("/container-creation", extra: jsonEncode(data));
  }

  Widget fileName() {
    if (picked?.files.first.name != null) {
      return Text("Image: ${picked!.files.first.name}");
    }
    return const Text("Aucun fichier sélectionner");
  }

  Widget loadCube() {
    if (world != null) {
      return Sp3dRenderer(
        const Size(800, 800),
        const Sp3dV2D(400, 400),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Design',
          context: context,
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProgressBar(
              length: 4,
              progress: 1,
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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 100,
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: const Text('Importer une image'),
                      onPressed: () async {
                        picked = await FilePicker.platform.pickFiles();
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      child: const Text("Retirer l'image sélectionner"),
                      onPressed: () async {
                        removeImage(false);
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    fileName(),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      width: 400,
                      child: Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownMenu<String>(
                        key: const Key('design-face'),
                        initialSelection: faceList.first,
                        onSelected: (String? value) {
                          setState(() {
                            face = value!;
                          });
                        },
                        dropdownMenuEntries: faceList
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: const Text('Appliquer'),
                      onPressed: () async {
                        loadImage(false, fileData: picked!.files.first.bytes);
                      },
                    ),
                  ],
                ),
              ),
            ),
            loadCube(),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: RecapPanel(
                      articles: lockerss,
                      onSaved: () => {},
                    )),
              ),
            ),
            const SizedBox(
              width: 50,
            )
          ],
        ));
  }
}
