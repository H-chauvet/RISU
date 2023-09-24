import 'package:flutter/material.dart';

///
/// InteractivePanel
///
class InteractivePanel extends StatelessWidget {
  const InteractivePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Expanded(child: Text('Conteneurs alentours')),
                          Icon(Icons.chevron_right),
                        ],
                      ))),
              const SizedBox(height: 20),
              SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Kits'),
                          Icon(Icons.chevron_right),
                        ],
                      ))),
              const SizedBox(height: 20),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
                          ),
                        ),
                        Text('vue 3D'),
                      ]),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
                          ),
                        ),
                        Text('vue 2D'),
                      ]),
                      const SizedBox(
                        width: 30,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
                          ),
                        ),
                        Text('vue côté'),
                      ]),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
                          ),
                        ),
                        const Text('zoom avant'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
                          ),
                        ),
                        const Text('zoom arrière'),
                      ]),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(children: [
                        SizedBox(
                          width: 50,
                          child: Image.asset(
                            'assets/google.png',
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
