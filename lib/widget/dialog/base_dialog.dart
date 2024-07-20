import 'package:flutter/material.dart';

class BaseDialogWidget extends StatelessWidget {
  final Widget child;
  final bool backPress;
  final int padding;

  const BaseDialogWidget(
      {this.backPress = true,
      this.padding = 50,
      required this.child,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(backPress),
      child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(padding.toDouble()),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                child: child,
              ),
            ],
          )),
    );
  }
}
