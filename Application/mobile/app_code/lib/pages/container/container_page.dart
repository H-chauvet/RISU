import 'package:flutter/material.dart';

import 'container_list_data.dart';
import 'container_state.dart';

class ContainerPage extends StatefulWidget {
  final Function(int?) onDirectionClicked;
  final List<ContainerList> testContainers;

  const ContainerPage({
    super.key,
    required this.onDirectionClicked,
    this.testContainers = const [],
  });

  @override
  State<ContainerPage> createState() => ContainerPageState();
}
