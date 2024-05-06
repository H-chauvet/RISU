import 'package:flutter/material.dart';

import 'map_state.dart';

class MapPage extends StatefulWidget {
  final bool displayGoogleMap;
  final int? containerId;

  const MapPage({
    super.key,
    this.displayGoogleMap = true,
    this.containerId,
  });

  static const String routeName = '/map';

  @override
  State<MapPage> createState() => MapPageState();
}
