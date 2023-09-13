import 'package:flutter/material.dart';

///
/// InteractivePanel
///
class InteractivePanel extends StatelessWidget {
  const InteractivePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
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
                          Text('Conteneurs alentours'),
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
              Container(
                  child: Column(
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
                        const Text('vue 3D'),
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
                        const Text('vue 2D'),
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
                        const Text('vue côté'),
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
              ))
            ]),
          ],
        ));
  }
}
