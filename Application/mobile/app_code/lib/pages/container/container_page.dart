import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'container_list_data.dart';
import 'container_state.dart';

class ContainerPage extends StatefulWidget {
  final Function(int?) onDirectionClicked;
  final List<ContainerList> testContainers;
  final LatLng? testPosition;

  const ContainerPage({
    super.key,
    required this.onDirectionClicked,
    this.testContainers = const [],
    this.testPosition,
  });

  @override
  State<ContainerPage> createState() => ContainerPageState();
}
