import 'package:flutter/material.dart';

import 'opinion_state.dart';

class OpinionPage extends StatefulWidget {
  final int itemId;

  const OpinionPage({
    super.key,
    required this.itemId,
  });

  @override
  State<OpinionPage> createState() => OpinionPageState();
}
