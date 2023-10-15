import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/interactive_panel.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:front/screens/landing-page/landing_page.dart';
import 'package:front/services/locker_service.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:util_simple_3d/util_simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';

class ContainerCreation extends StatefulWidget {
  const ContainerCreation({super.key});

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

  @override
  void initState() {
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
  }

  void updateCube(LockerCoordinates coordinates) {
    int fragment = coordinates.x - 1 + (coordinates.y - 1) * 12;
    int increment = 0;
    int color = 0;

    switch (coordinates.color) {
      case 'Vert':
        color = 1;
        break;
      case 'Rouge':
        color = 2;
        break;
      case 'Bleu':
        color = 3;
        break;
      case 'Noir':
        color = 4;
        break;
      default:
        color = 1;
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
        return;
      }
      fragment += increment;
    }

    fragment = coordinates.x - 1 + (coordinates.y - 1) * 12;

    for (int i = 0; i < coordinates.size; i++) {
      objs[0].fragments[fragment].faces[0].materialIndex = color;
      objs[0].fragments[fragment].faces[1].materialIndex = color;
      objs[0].fragments[fragment].faces[2].materialIndex = color;
      objs[0].fragments[fragment].faces[3].materialIndex = color;
      objs[0].fragments[fragment].faces[4].materialIndex = color;
      objs[0].fragments[fragment].faces[5].materialIndex = color;
      fragment += increment;
    }

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
  }

  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  void goNext() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
  }

  void goPrevious() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LandingPage()));
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
              length: 2,
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
          children: [
            const SizedBox(
              width: 50,
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  heightFactor: 0.7,
                  child: InteractivePanel(callback: updateCube),
                ),
              ),
            ),
            Column(
              children: [
                Sp3dRenderer(
                  const Size(800, 800),
                  const Sp3dV2D(400, 400),
                  world,
                  // If you want to reduce distortion, shoot from a distance at high magnification.
                  Sp3dCamera(Sp3dV3D(0, 0, 3000), 6000),
                  Sp3dLight(Sp3dV3D(0, 0, -1), syncCam: true),
                  allowUserWorldRotation: true,
                  allowUserWorldZoom: false,
                ),
              ],
            ),
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                    widthFactor: 0.7,
                    heightFactor: 0.7,
                    child: RecapPanel(
                      articles: lockers,
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
