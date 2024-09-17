import 'package:flutter/material.dart';

import 'answer_state.dart';

/// AnswerPage.
/// This class is the main class for the AnswerPage.
/// params:
/// [question] - the question object.
class AnswerPage extends StatefulWidget {
  final dynamic question;

  const AnswerPage({
    super.key,
    this.question = const {},
  });

  @override
  State<AnswerPage> createState() => AnswerPageState(question: question);
}
