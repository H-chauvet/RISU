import 'package:flutter/material.dart';
import 'package:front/components/dialog/container_dialog.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

class InteractivePanel extends StatefulWidget {
  const InteractivePanel(
      {super.key,
      required this.callback,
      required this.rotateFrontCallback,
      required this.rotateBackCallback,
      required this.rotateLeftCallback,
      required this.rotateRightCallback,
      required this.width,
      required this.height});

  final Function(LockerCoordinates, bool) callback;
  final Function() rotateFrontCallback;
  final Function() rotateBackCallback;
  final Function() rotateLeftCallback;
  final Function() rotateRightCallback;
  final int width;
  final int height;

  @override
  State<InteractivePanel> createState() => InteractivePanelState();
}

///
/// InteractivePanel
///
class InteractivePanelState extends State<InteractivePanel> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: Provider.of<ThemeService>(context).isDark
            ? boxDecorationDarkTheme
            : boxDecorationLightTheme,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Configuration du conteneur",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => ContainerDialog(
                              callback: widget.callback,
                              size: 1,
                              width: widget.width,
                              height: widget.height,
                            ));
                  },
                  child: Column(
                    children: [
                      const Text("Petit casier",
                          style: TextStyle(color: Colors.white)),
                      Image.asset(
                        "assets/cube.png",
                        width: 40,
                        height: 40,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => ContainerDialog(
                              callback: widget.callback,
                              size: 2,
                              width: widget.width,
                              height: widget.height,
                            ));
                  },
                  child: Column(
                    children: [
                      const Text("Moyen casier",
                          style: TextStyle(color: Colors.white)),
                      Image.asset(
                        "assets/cube.png",
                        width: 60,
                        height: 60,
                      ),
                    ],
                  )),
              const SizedBox(
                height: 5,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0))),
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (context) => ContainerDialog(
                              callback: widget.callback,
                              size: 3,
                              width: widget.width,
                              height: widget.height,
                            ));
                  },
                  child: Column(
                    children: [
                      const Text("Grand casier",
                          style: TextStyle(color: Colors.white)),
                      Image.asset(
                        "assets/cube.png",
                        width: 80,
                        height: 80,
                      ),
                    ],
                  )),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        key: const Key('front-view'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: widget.rotateFrontCallback,
                        child: Column(children: [
                          SizedBox(
                            width: 80,
                            child: Image.asset(
                              'assets/3d_logo.png',
                            ),
                          ),
                          const Text('vue devant',
                              style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        key: const Key('back-view'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: widget.rotateBackCallback,
                        child: Column(children: [
                          SizedBox(
                            width: 80,
                            child: Image.asset(
                              'assets/3d_logo.png',
                            ),
                          ),
                          const Text('vue derrière',
                              style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        key: const Key('left-view'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: widget.rotateLeftCallback,
                        child: Column(children: [
                          SizedBox(
                            width: 80,
                            child: Image.asset(
                              'assets/3d_logo.png',
                            ),
                          ),
                          const Text('vue gauche',
                              style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        key: const Key('right-view'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0))),
                        onPressed: widget.rotateRightCallback,
                        child: Column(children: [
                          SizedBox(
                            width: 80,
                            child: Image.asset(
                              'assets/3d_logo.png',
                            ),
                          ),
                          const Text('vue droite',
                              style: TextStyle(color: Colors.white)),
                        ]),
                      ),
                    ],
                  )
                ],
              )
            ]));
  }
}
