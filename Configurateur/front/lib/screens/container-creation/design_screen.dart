import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

import '../../components/custom_app_bar.dart';
import 'package:go_router/go_router.dart';
import '../../components/progress_bar.dart';
import '../../components/recap_panel.dart';

const List<String> faceList = <String>[
  'Devant',
  'Derrière',
  'Droite',
  'Gauche',
  'Haut',
  'Bas'
];

class DesignScreen extends StatefulWidget {
  const DesignScreen({super.key});

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
  List<Locker> lockers = [];
  double actualRotationDegree = 0.0;
  String jwtToken = '';
  int imageIndex = 0;
  int materialIndex = 1;
  FilePickerResult? picked;
  String face = faceList.first;

  @override
  void initState() {
    /*if (token != "") {
      jwtToken = token;
    } else {
      context.go(
        '/login',
      );
    }*/
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
    loadImage().then((value) => null);
  }

  Future<void> loadImage({Uint8List? fileData}) async {
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
      objs[0].materials.add(FSp3dMaterial.black);
      objs[0].materials[materialIndex] = FSp3dMaterial.green.deepCopy()
        ..imageIndex = imageIndex;
      objs[0].fragments[0].faces[faceIndex].materialIndex = materialIndex;
      objs[0].images.add(fileData);
      imageIndex++;
      materialIndex++;
    }
    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  Future<void> removeImage(int face) async {
    picked = null;
    objs[0].fragments[0].faces[face].materialIndex = 0;

    world = Sp3dWorld(objs);
    await world?.initImages().then((List<Sp3dObj> errorObjs) {
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
    };
    context.go("/container-creation/visualization", extra: jsonEncode(data));
  }

  void goPrevious() {
    var data = {
      'amount': sumPrice(),
      'containerMapping': getContainerMapping(),
      'lockers': jsonEncode(lockers),
    };
    context.go("/container-creation", extra: jsonEncode(data));
  }

  Widget fileName() {
    if (picked?.files.first.name != null) {
      return Text(picked!.files.first.name);
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
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadCube(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  child: const Text('UPLOAD FILE'),
                  onPressed: () async {
                    picked = await FilePicker.platform.pickFiles();
                    setState(() {});
                  },
                ),
                fileName(),
                ElevatedButton(
                  child: const Text('REMOVE FILE'),
                  onPressed: () async {
                    removeImage(0);
                    setState(() {});
                  },
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
                    dropdownMenuEntries:
                        faceList.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Appliquer'),
                  onPressed: () async {
                    loadImage(fileData: picked!.files.first.bytes);
                  },
                ),
              ],
            )
          ],
        ));
  }
}
