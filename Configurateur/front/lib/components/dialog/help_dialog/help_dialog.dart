import 'package:flutter/material.dart';
import 'package:front/components/custom_popup.dart';
import 'package:front/components/dialog/help_dialog/help_content.dart';
import 'package:front/services/language_service.dart';

/// [StatefulWidget] : HelpDialog
///
/// Create a new dialog with a specific content to help user
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
    return CustomPopup(
      title: language == 'fr'
          ? '${french_help_content[widget.content]?['title']}'
          : '${english_help_content[widget.content]?['title']}',
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
