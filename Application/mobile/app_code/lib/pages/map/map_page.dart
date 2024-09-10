import 'package:flutter/material.dart';

import 'map_state.dart';

/// Map page.
/// This page displays a map.
/// params:
/// [displayGoogleMap] - if true, displays a google map, otherwise displays a map with a marker.
/// [containerId] - the id of the container to display the map in.
class MapPage extends StatefulWidget {
  final bool displayGoogleMap;
  final int? containerId;

  const MapPage({
    super.key,
    this.displayGoogleMap = true,
    this.containerId,
  });

  @override
  State<MapPage> createState() => MapPageState();
}
