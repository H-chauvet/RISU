import 'package:flutter/material.dart';

import 'home_state.dart';

/// Home page.
/// this is the main page of the application.
class HomePage extends StatefulWidget {
  final bool firebase;

  const HomePage({
    super.key,
    this.firebase = true,
  });

  @override
  State<HomePage> createState() => HomePageState();
}
