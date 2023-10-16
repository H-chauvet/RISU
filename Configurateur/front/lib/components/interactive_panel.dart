import 'package:flutter/material.dart';
import 'package:front/components/container_dialog.dart';
import 'package:front/services/locker_service.dart';

class InteractivePanel extends StatefulWidget {
  const InteractivePanel(
      {super.key,
      required this.callback,
      required this.rotateFrontCallback,
      required this.rotateBackCallback,
      required this.rotateLeftCallback,
      required this.rotateRightCallback});

  final Function(LockerCoordinates) callback;
  final Function() rotateFrontCallback;
  final Function() rotateBackCallback;
  final Function() rotateLeftCallback;
  final Function() rotateRightCallback;

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
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Configuration du container",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              /*SizedBox(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Conteneurs alentours',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.chevron_right, color: Colors.white),
                        ],
                      ))),
              const SizedBox(height: 20),*/
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
              /*LongPressDraggable(
                  feedback: Image.asset(
                    "assets/cube.png",
                    width: 40,
                    height: 40,
                  ),
                  child: Column(children: [
                    const Text("petit casier"),
                    Image.asset(
                      "assets/cube.png",
                      width: 40,
                      height: 40,
                    ),
                  ])),*/
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
              /*LongPressDraggable(
                  feedback: Image.asset(
                    "assets/cube.png",
                    width: 60,
                    height: 60,
                  ),
                  child: Column(children: [
                    const Text("moyen casier"),
                    Image.asset(
                      "assets/cube.png",
                      width: 60,
                      height: 60,
                    ),
                  ])),*/
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
              /*LongPressDraggable(
                  feedback: Image.asset(
                    "assets/cube.png",
                    width: 80,
                    height: 80,
                  ),
                  child: Column(children: [
                    const Text("grand casier"),
                    Image.asset(
                      "assets/cube.png",
                      width: 80,
                      height: 80,
                    ),
                  ])),*/
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
