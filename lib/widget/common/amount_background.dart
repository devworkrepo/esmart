import 'package:esmartbazaar/res/color.dart';
import 'package:flutter/material.dart';

class AmountBackgroundWidget extends StatelessWidget {
  final Widget child;
  const AmountBackgroundWidget({Key? key,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: AppColor.backgroundColor),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
