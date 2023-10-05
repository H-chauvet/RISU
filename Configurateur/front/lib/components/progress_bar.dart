import 'package:flutter/material.dart';

///
/// Progress bar
///
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

  Color getCorrectColor(index) {
    if (progress == index) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Row(children: [
      ElevatedButton(
          onPressed: previousFunc,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
          child: Text(previous)),
      const SizedBox(
        width: 10,
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < length; i++)
            Container(
              height: 10,
              width: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: getCorrectColor(i), shape: BoxShape.circle),
            )
        ],
      ),
      ElevatedButton(
          onPressed: nextFunc,
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
          child: Text(next)),
    ]));
  }
}
