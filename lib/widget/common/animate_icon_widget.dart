import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppAnimatedWidget extends StatefulWidget {
  final Widget child;

  const AppAnimatedWidget( {Key? key,required this.child})
      : super(key: key);

  @override
  _AnimateStatusIconWidgetState createState() =>
      _AnimateStatusIconWidgetState();
}

class _AnimateStatusIconWidgetState extends State<AppAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animation = Tween<double>(begin: 40, end: 45)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {

      return SizedBox(height: animation.value,
          child: widget.child);

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
