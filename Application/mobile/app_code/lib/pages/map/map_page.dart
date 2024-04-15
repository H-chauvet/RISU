import 'package:flutter/material.dart';

import 'map_state.dart';

class MapPage extends StatefulWidget {
  final bool displayGoogleMap;

  const MapPage({
    super.key,
    this.displayGoogleMap = true,
  });

  @override
  State<MapPage> createState() => MapPageState();
}
