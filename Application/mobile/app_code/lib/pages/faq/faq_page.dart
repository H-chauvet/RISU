import 'package:flutter/material.dart';

import 'faq_state.dart';

class FaqPage extends StatefulWidget {
  final List<dynamic> questions;

  const FaqPage({
    super.key,
    this.questions = const [],
  });

  @override
  State<FaqPage> createState() => FaqPageState();
}
