import 'package:flutter/material.dart';
import 'package:front/services/theme_service.dart';
import 'package:front/styles/themes.dart';
import 'package:provider/provider.dart';

///
/// Progress bar
///
/// Display progress bar during the container's creation
///
/// [length] : lenght of the progressBar
/// [progress] : define where you are in the progressBar
/// [previous] : Go to the previous part of the container's creation
/// [next] : Go to the next part of the container's creation
/// [previousFunc] : Go to the previous function
/// [nextFunc] : Go to the next function
class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {super.key,
      required this.length,
      required this.progress,
      required this.previous,
      required this.next,
      required this.previousFunc,
      required this.nextFunc});

  final int length;
  final int progress;
  final String previous;
  final String next;
  final VoidCallback previousFunc;
  final VoidCallback nextFunc;

  /// [Function] : Get the correct color and return it
  Color getCorrectColor(index, context) {
    if (progress == index) {
      return Provider.of<ThemeService>(context).isDark
          ? progressBarCheckedDarkTheme
          : progressBarCheckedLightTheme;
    } else {
      return Provider.of<ThemeService>(context).isDark
          ? progressBarUncheckedDarkTheme!
          : progressBarUncheckedLightTheme!;
    }
  }

  /// [Widget] : build de progressBar component
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(children: [
      ElevatedButton(
        key: const Key('previous'),
        onPressed: previousFunc,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        child: Text(
          previous,
          style: TextStyle(
            color: Provider.of<ThemeService>(context).isDark
                ? darkTheme.primaryColor
                : lightTheme.colorScheme.background,
          ),
        ),
      ),
      const SizedBox(
        width: 10,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < length; i++)
            Container(
              key: Key("circleShape_$i"),
              height: 10,
              width: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: getCorrectColor(i, context), shape: BoxShape.circle),
            )
        ],
      ),
      ElevatedButton(
        key: const Key('terminate'),
        onPressed: nextFunc,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
        child: Text(next,
            style: TextStyle(
              color: Provider.of<ThemeService>(context).isDark
                  ? darkTheme.primaryColor
                  : lightTheme.colorScheme.background,
            )),
      ),
    ]));
  }
}
