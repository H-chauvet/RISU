import 'package:flutter/material.dart';

import 'opinion_state.dart';

class OpinionPage extends StatefulWidget {
  final int itemId;
  final List<dynamic> testOpinions;

  const OpinionPage({
    super.key,
    required this.itemId,
    this.testOpinions = const [],
  });

  @override
  State<OpinionPage> createState() => OpinionPageState(itemId: itemId);
}
