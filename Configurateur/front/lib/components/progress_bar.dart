import 'package:flutter/material.dart';

///
/// Progress bar
///
class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, this.progress, this.previous, this.next});

  final int? progress;
  final String? previous;
  final String? next;

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
          onPressed: () {
            Navigator.pushNamed(context, previous!);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
          child: Text(previous!)),
      const SizedBox(
        width: 10,
      ),
      Container(
        height: 10,
        width: 10,
        decoration:
            BoxDecoration(color: getCorrectColor(0), shape: BoxShape.circle),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        height: 10,
        width: 10,
        decoration:
            BoxDecoration(color: getCorrectColor(1), shape: BoxShape.circle),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        height: 10,
        width: 10,
        decoration:
            BoxDecoration(color: getCorrectColor(2), shape: BoxShape.circle),
      ),
      const SizedBox(
        width: 10,
      ),
      Container(
        height: 10,
        width: 10,
        decoration:
            BoxDecoration(color: getCorrectColor(3), shape: BoxShape.circle),
      ),
      const SizedBox(
        width: 10,
      ),
      ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, next!);
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
          child: Text(next!)),
    ]));
  }
}
