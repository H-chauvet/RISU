import 'package:flutter/material.dart';
import 'package:front/components/container_dialog.dart';
import 'package:front/services/locker_service.dart';

const List<String> faceList = <String>['Devant', 'Derrière'];
const List<String> directionList = <String>['Haut', 'Bas'];

class InteractivePanel extends StatefulWidget {
  const InteractivePanel({super.key, required this.callback});

  final Function(LockerCoordinates) callback;

  @override
  State<InteractivePanel> createState() => InteractivePanelState();
}

///
/// InteractivePanel
///
class InteractivePanelState extends State<InteractivePanel> {
  final _formKey = GlobalKey<FormState>();

  String face = faceList.first;
  String direction = directionList.first;

  @override
  Widget build(BuildContext context) {
    String x = '';
    String y = '';

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
              SizedBox(
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Conteneurs alentours',
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ))),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                      const Text("Petit casier"),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                      const Text("Moyen casier"),
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
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
                      const Text("Grand casier"),
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
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('vue 3D'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('vue 2D'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('vue côté'),
                      ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('zoom avant'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('zoom arrière'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 80,
                          child: Image.asset(
                            'assets/3d_logo.png',
                          ),
                        ),
                        const Text('casiers ouverts'),
                      ]),
                    ],
                  ),
                ],
              )
            ]));
  }
}
