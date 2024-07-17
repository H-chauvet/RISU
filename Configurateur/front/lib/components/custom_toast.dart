import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message, bool isSuccessful) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: CustomToast(message: message, isSuccessful: isSuccessful),
      ),
    ),
  );
  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

class CustomToast extends StatefulWidget {
  final String message;
  final bool isSuccessful;

  const CustomToast(
      {Key? key, required this.message, required this.isSuccessful})
      : super(key: key);

  @override
  CustomToastState createState() => CustomToastState();
}

class CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _widthAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double toastWidth = MediaQuery.of(context).size.width * 0.20;

    return Stack(
      children: [
        Container(
          width: toastWidth,
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: widget.isSuccessful
                ? const Color(0xFF80CEC1)
                : const Color(0xFFF08F74),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(widget.isSuccessful ? Icons.check : Icons.close,
                      color: Colors.black),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Text(
                      widget.isSuccessful ? "Succès !" : "Echec !",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            child: AnimatedBuilder(
              animation: _widthAnimation,
              builder: (context, child) {
                return Container(
                  width: toastWidth * _widthAnimation.value,
                  height: 5.0,
                  color: Colors.white,
                );
              },
            ))
      ],
    );
  }
}
