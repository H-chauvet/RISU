import 'package:flutter/material.dart';

void myShowModalBottomSheet(BuildContext context, String title, Widget content,
    {bool showCloseButton = true, Color color = Colors.white}) {
  double borderRadius = 32;
  double padding = 8;

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: color,
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
                        icon: const Icon(Icons.close, color: Colors.grey,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
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
