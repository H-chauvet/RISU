import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message, bool isSuccessful) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  bool isOverlayEntryActive = true;


  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 50,
      right: 10.0,
      child: Material(
        color: Colors.transparent,
        child: CustomToast(
          message: message,
          isSuccessful: isSuccessful,
          onClose: () {
            if (isOverlayEntryActive) {
              overlayEntry.remove();
              isOverlayEntryActive = false;
            }
          },
        ),
      ),
    ),
  );


  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 3), () {
    if (isOverlayEntryActive) {
      overlayEntry.remove();
      isOverlayEntryActive = false;
    }
  });

}

class CustomToast extends StatefulWidget {
  final String message;
  final bool isSuccessful;
  final VoidCallback onClose;

  const CustomToast({
    Key? key,
    required this.message,
    required this.isSuccessful,
    required this.onClose,
  }) : super(key: key);

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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(
                  widget.isSuccessful ? Icons.check : Icons.error,
                  color: Colors.black,
                  size: 30.0,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.isSuccessful ? "Succès !" : "Erreur !",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 16.0,
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
          ),
        ),
      ],
    );
  }
}
