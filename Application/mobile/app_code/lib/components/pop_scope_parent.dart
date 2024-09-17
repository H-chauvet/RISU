import 'package:flutter/cupertino.dart';

/// A widget that wraps a child widget and prevents the user from popping the
/// current route.
/// This is useful when you want to prevent the user from accidentally
/// navigating back to a previous screen.
/// params:
/// [child] - The child widget to display.
/// [onPopInvoked] - A callback that is called when the user attempts to pop the
/// current route. The callback is passed a boolean value that indicates whether
/// the pop was successful.
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
