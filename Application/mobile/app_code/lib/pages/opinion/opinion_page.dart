import 'package:flutter/material.dart';

import 'opinion_state.dart';

class OpinionPage extends StatefulWidget {
  final int itemId;
  final List<dynamic> opinions;

  const OpinionPage({
    super.key,
    required this.itemId,
    this.opinions = const [],
  });

  @override
  State<OpinionPage> createState() =>
      OpinionPageState(itemId: itemId, opinionsList: opinions);
}
