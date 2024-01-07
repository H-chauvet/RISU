import 'package:flutter/material.dart';

import 'details_state.dart';

class ContainerDetailsPage extends StatefulWidget {
  final String containerId;

  const ContainerDetailsPage({ Key? key, required this.containerId }) : super(key: key);

  @override
  State<ContainerDetailsPage> createState() => ContainerDetailsState();
}
