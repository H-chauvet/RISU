import 'package:flutter/material.dart';
import 'package:cubixd/cubixd.dart';
import 'package:vector_math/vector_math_64.dart' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: Row(children: [
            CubixD(
              size: 200,
              onSelected: ((SelectedSide opt, math.Vector2 test) =>
                  opt == SelectedSide.bottom ? false : true),
              left: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              front: Container(
                color: Colors.blue,
              ),
              back: Container(
                color: Colors.red,
              ),
              top: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              right: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              delta: math.Vector2(2, 2),
            ),
            const SizedBox(
              width: 100,
            ),
            CubixD(
              size: 200,
              onSelected: ((SelectedSide opt, math.Vector2 test) =>
                  opt == SelectedSide.bottom ? false : true),
              left: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              front: Container(
                color: Colors.blue,
              ),
              back: Container(
                color: Colors.red,
              ),
              top: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              right: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              delta: math.Vector2(2, 2),
            ),
            const SizedBox(
              width: 100,
            ),
            CubixD(
              size: 200,
              onSelected: ((SelectedSide opt, math.Vector2 test) =>
                  opt == SelectedSide.bottom ? false : true),
              left: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              front: Container(
                color: Colors.blue,
              ),
              back: Container(
                color: Colors.red,
              ),
              top: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              bottom: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              right: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/troll.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              delta: math.Vector2(2, 2),
            ),
          ]),
        ));
  }
}
