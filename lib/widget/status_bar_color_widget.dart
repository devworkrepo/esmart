import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/widget_util.dart';

class StatusBarColorWidget extends StatefulWidget {
  final Color? color;
  final Widget child;
  const StatusBarColorWidget({required this.child,this.color,Key? key}) : super(key: key);

  @override
  _StatusBarColorWidgetState createState() => _StatusBarColorWidgetState();
}

class _StatusBarColorWidgetState extends State<StatusBarColorWidget> {



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      setState(() {
        WidgetUtil.statusBarColor(widget.color ?? Get.theme.primaryColorDark);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetUtil.statusBarColor(widget.color ?? Get.theme.primaryColorDark);
    return widget.child;
  }
}
