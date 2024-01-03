import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:front/components/custom_app_bar.dart';
import 'package:front/components/progress_bar.dart';
import 'package:front/components/recap_panel.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_3d/simple_3d.dart';
import 'package:simple_3d_renderer/simple_3d_renderer.dart';
import 'package:util_simple_3d/util_simple_3d.dart';

class VisualizationScreen extends StatefulWidget {
  const VisualizationScreen(
      {super.key, this.lockers, this.amount, this.containerMapping});

  final String? lockers;
  final int? amount;
  final String? containerMapping;

  @override
  State<VisualizationScreen> createState() => VisualizationScreenState();
}

///
/// Login screen
///
/// page de connexion pour le configurateur
///
class VisualizationScreenState extends State<VisualizationScreen> {
  List<Locker> lockerss = [];
  late List<Sp3dObj> objs = [];
  late Sp3dWorld world;
  bool isLoaded = false;

  void goPrevious() {
    context.go('/container-creation');
  }

  void goNext() async {
    var data = {
      'amount': widget.amount,
      'containerMapping': widget.containerMapping,
      'lockers': jsonEncode(lockerss)
    };

    context.go("/container-creation/recap", extra: jsonEncode(data));
  }

  @override
  void initState() {
    super.initState();
    Sp3dObj obj = UtilSp3dGeometry.cube(200, 100, 50, 1, 1, 1);
    obj.materials.add(FSp3dMaterial.green.deepCopy());
    obj.materials.add(FSp3dMaterial.red.deepCopy());
    obj.materials.add(FSp3dMaterial.blue.deepCopy());
    obj.materials.add(FSp3dMaterial.black.deepCopy());
    obj.materials[0] = FSp3dMaterial.grey.deepCopy()
      ..strokeColor = const Color.fromARGB(255, 0, 0, 255);
    objs.add(obj);
    loadImage();

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

  void loadImage() async {
    world = Sp3dWorld(objs);
    world.initImages().then((List<Sp3dObj> errorObjs) {
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          'Visualisation',
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
          children: [
            const SizedBox(
              width: 300,
            ),
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
            Flexible(
              child: Align(
                alignment: Alignment.centerRight,
                child: FractionallySizedBox(
                    widthFactor: 0.4,
                    heightFactor: 0.6,
                    child: RecapPanel(
                      articles: lockerss,
                      onSaved: goNext,
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
