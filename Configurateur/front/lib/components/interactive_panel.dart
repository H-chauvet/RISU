import 'package:flutter/material.dart';

///
/// InteractivePanel
///
class InteractivePanel extends StatelessWidget {
  const InteractivePanel({super.key});

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
              LongPressDraggable(
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
                  ])),
              const SizedBox(
                height: 5,
              ),
              LongPressDraggable(
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
                  ])),
              const SizedBox(
                height: 5,
              ),
              LongPressDraggable(
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
                  ])),
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
