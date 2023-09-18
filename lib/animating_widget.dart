import 'dart:math';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AnimateTheWidget extends StatefulWidget {
  AnimateTheWidget(
      {required this.child, required this.onEnd, required this.needAnimate});
  final Widget child;
  final VoidCallback onEnd;
  bool needAnimate;
  @override
  State<AnimateTheWidget> createState() => _AnimateTheWidgetState();
}

class _AnimateTheWidgetState extends State<AnimateTheWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late Animation<double> rotation;
  late Animation<double> scale;

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = Tween(begin: 1.5, end: 1.0).animate(animationController);
    rotation = Tween(begin: -pi, end: 0.0).animate(animationController);
    scale =
        CurveTween(curve: Curves.easeInOutCubic).animate(animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.needAnimate) {
      animationController.forward().then((value) {
        widget.onEnd();
      });
      widget.needAnimate = false;
      setState(() {});
    }
    return AnimatedBuilder(
      // animation: animation,
      child: widget.child,
      // builder: (context, child) {
      //   return Transform.scale(scale: animation.value, child: child!);
      // },
      animation: Listenable.merge([rotation, scale]),
      // child: widget.child,
      builder: (context, child) {
        return ScaleTransition(
            scale: scale,
            child: Transform.rotate(angle: rotation.value, child: child!));
      },
    );
  }
}
