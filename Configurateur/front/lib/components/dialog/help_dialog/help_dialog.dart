import 'package:flutter/material.dart';
import 'package:front/components/dialog/help_dialog/help_content.dart';

/// [StatefulWidget] : HelpDialog
///
class HelpDialog extends StatefulWidget {
  const HelpDialog({super.key, required this.content});

  final String content;

  @override
  State<HelpDialog> createState() => HelpDialogState();
}

///
/// HelpDialog
///
class HelpDialogState extends State<HelpDialog> {
  /// [Widget] : Build the AlertDialog
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(help_content[widget.content]?['title'] ?? ""),
      content: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              debugPrint(help_content[widget.content]?['title']);
            },
            child: Text("test"),
          )
        ],
      ),
    );
  }
}
