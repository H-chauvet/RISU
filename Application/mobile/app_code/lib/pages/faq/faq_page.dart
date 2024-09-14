import 'package:flutter/material.dart';

import 'faq_state.dart';

/// FAQ page.
/// this page will show the list of questions and answers.
/// params:
/// [questions] - list of questions and answers.
class FaqPage extends StatefulWidget {
  final List<dynamic> questions;

  const FaqPage({
    super.key,
    this.questions = const [],
  });

  @override
  State<FaqPage> createState() => FaqPageState();
}
