import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/hex_color.dart';

class AppBackgroundImage extends StatelessWidget {
  final Widget child;
  const AppBackgroundImage({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment.bottomRight  ,
              stops:[
                0.1,
                1
              ],
              colors: [
            // Get.theme.primaryColorDark,
            // Get.theme.primaryColor,
            // Get.theme.colorScheme.secondary
                HexColor("990c78"),
                HexColor("2000ff")

          ])
        ),
        child: child,
      );
  }
}
