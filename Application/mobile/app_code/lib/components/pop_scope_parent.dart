import 'package:flutter/cupertino.dart';

class MyPopScope extends StatelessWidget {
  final Widget child;

  const MyPopScope({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: child,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, true);
      },
    );
  }
}
