import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';

/// Show a modal bottom sheet with a title and content.
/// It is used when displaying the map.
/// params:
/// [context] - context of the widget.
/// [title] - title of the bottom sheet.
/// [content] - content of the bottom sheet.
/// [showCloseButton] - show close button or not.
/// [color] - color of the bottom sheet.
/// [subtitle] - subtitle of the bottom sheet.
void myShowModalBottomSheet(BuildContext context, String title, Widget content,
    {bool showCloseButton = true,
    Color color = Colors.white,
    String? subtitle}) {
  double borderRadius = 32;
  double padding = 8;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        key: const Key('bottom_sheet'),
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: context.select((ThemeProvider themeProvider) =>
              themeProvider.currentTheme.bottomSheetTheme.backgroundColor),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (showCloseButton)
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: content,
              ),
            ],
          ),
        ),
      );
    },
  );
}
