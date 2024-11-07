import 'package:flutter/material.dart';
import 'package:front/components/dialog/help_dialog/help_content.dart';
import 'package:front/services/language_service.dart';

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
      title: language == 'fr'
          ? Text(french_help_content[widget.content]?['title'] ?? "")
          : Text(english_help_content[widget.content]?['title'] ?? ""),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          language == 'fr'
              ? Text(
                  french_help_content[widget.content]?['content'] ?? "",
                  textAlign: TextAlign.justify,
                )
              : Text(
                  english_help_content[widget.content]?['content'] ?? "",
                  textAlign: TextAlign.justify,
                ),
        ],
      ),
    );
  }
}
