import 'package:flutter/material.dart';

import 'details_state.dart';

class ContainerDetailsPage extends StatefulWidget {
  final String containerId;

  const ContainerDetailsPage({
    super.key,
    required this.containerId,
  });

  @override
  State<ContainerDetailsPage> createState() => ContainerDetailsState();
}
