import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

class DesignScreen extends StatefulWidget {
  const DesignScreen(
      {super.key,
      this.lockers,
      this.amount,
      this.containerMapping,
      this.id,
      this.container});

  final String? lockers;
  final int? amount;
  final String? containerMapping;
  final String? id;
  final String? container;

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
  List<Design> designss = [];

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
    if (widget.container != null) {
      decodeDesigns();
    }
  }

  void decodeLockers() {
    dynamic decode = jsonDecode(widget.lockers!);

    for (int i = 0; i < decode.length; i++) {
      lockerss.add(Locker(decode[i]['type'], decode[i]['price']));
    }
  }

  void decodeDesigns() {
    dynamic container = jsonDecode(widget.container!);

    dynamic decode = jsonDecode(container['designs']);

    for (int i = 0; i < decode.length; i++) {
      loadImage(false,
          fileData: decode[i]['design'],
          faceLoad: int.parse(decode[i]['face']));
    }

    setState(() {
      isLoaded = true;
    });
  }

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
      }
      lockerss.add(Locker('design personnalisé', 50));
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
    if (objs[0].fragments[0].faces[faceIndex].materialIndex == 0) {
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
          isLoaded = true;
        });
      } else {
        isLoaded = true;
      }
    });
  }

  void removeDesign(int faceIndex) {
    for (int i = 0; i < lockerss.length; i++) {
      if (lockerss[i].type == 'design personnalisé') {
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

  void saveContainer() async {
    var header = <String, String>{
      'Authorization': jwtToken,
      'Content-Type': 'application/json; charset=UTF-8',
      'Access-Control-Allow-Origin': '*',
    };

    if (widget.id == null) {
      HttpService().request('http://$serverIp:3000/api/container/create',
          header, <String, String>{
        'containerMapping': widget.containerMapping!,
        'designs': json.encode(designss),
        'height': '5',
        'width': '12',
      }).then((value) {
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
      HttpService().putRequest('http://$serverIp:3000/api/container/update',
          header, <String, String>{
        'id': widget.id!,
        'containerMapping': widget.containerMapping!,
        'price': sumPrice().toString(),
        'width': '12',
        'height': '5',
        'city': '',
        'informations': '',
        'adress': '',
      }).then((value) {
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
        'height': '5',
        'width': '12',
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
      'containerMapping': widget.containerMapping,
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
                      onSaved: saveContainer,
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
