import 'package:flutter/material.dart';

import 'answer_state.dart';

class AnswerPage extends StatefulWidget {
  final dynamic question;

  const AnswerPage({
    super.key,
    this.question = const {},
  });

  @override
  State<AnswerPage> createState() => AnswerPageState(question: question);
}
