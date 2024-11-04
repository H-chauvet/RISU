import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:front/components/dialog/help_dialog/help_content.dart';
import 'package:front/services/locker_service.dart';
import 'package:front/styles/themes.dart';

/// [StatefulWidget] : HelpDialog
///
class HelpDialog extends StatefulWidget {
  const HelpDialog({super.key});

  final String content = 'add_dialog';

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
