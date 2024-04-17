import 'package:flutter/material.dart';

import 'container_state.dart';

class ContainerPage extends StatefulWidget {
  final Function(int?) onDirectionClicked;

  const ContainerPage({
    super.key,
    required this.onDirectionClicked,
  });

  @override
  State<ContainerPage> createState() => ContainerPageState();
}
