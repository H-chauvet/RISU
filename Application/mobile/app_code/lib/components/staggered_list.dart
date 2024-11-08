import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

// Custom staggered list widget that animates the displaying of items
// params:
// [itemCount] - is the number of items in the list.
// [itemBuilder] - is the function to build the item at the given index.
// [reverse] - is a boolean to reverse the list.
// [staggeredDelay] - is the delay between each item animation.
class StaggeredList extends StatefulWidget {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final bool reverse;
  final Duration staggeredDelay;

  const StaggeredList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.reverse = false,
    this.staggeredDelay = const Duration(milliseconds: 200),
  });

  @override
  StaggeredListState createState() => StaggeredListState();
}

class StaggeredListState extends State<StaggeredList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: max(widget.itemCount ~/ 4, 1)),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      reverse: widget.reverse,
      itemCount: widget.itemCount,
      itemBuilder: (context, index) {
        final animation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(
              (index * (widget.staggeredDelay.inMilliseconds / 1000)),
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - animation.value)),
                // Slide in effect
                child: BlurredCard(
                  blurValue: (1 - animation.value) * 5, // Blur effect
                  child: widget.itemBuilder(context, index),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Custom card widget with blur effect
// params:
// [blurValue] - is the value of the blur effect.
// [child] - is the child widget to be displayed.
class BlurredCard extends StatelessWidget {
  final double blurValue;
  final Widget child;

  const BlurredCard({
    super.key,
    required this.blurValue,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
        child: child,
      ),
    );
  }
}
