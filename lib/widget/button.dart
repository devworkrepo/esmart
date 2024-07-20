import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final int? width;
  final int? height;
  final Color? background;
  final bool isRounded;

  const AppButton(
      {this.height,
      this.width,
      this.background,
      this.isRounded = false,
      required this.text,
      required this.onClick,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    getOnClick(){
      return (onClick!=null) ? onClick : null;
    }

    var style = ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(background ?? Get.theme.primaryColor),
        shape:
             MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(((isRounded) ? 100 : 4)),
              ))
            );

    return SizedBox(
      width: width?.toDouble() ?? Get.width.toDouble(),
      height: height?.toDouble() ?? 48,
      child: ElevatedButton(
          style: style, onPressed:   (onClick != null)  ? onClick : null, child: Text(text,textAlign: TextAlign.center,)),
    );
  }
}

class AppButtonOutline extends StatelessWidget {

  final String text;
  final VoidCallback onClick;
  const AppButtonOutline({Key? key, required this.text, required this.onClick}) : super(key: key);





  @override
  Widget build(BuildContext context) {


    return OutlinedButton(
      onPressed: onClick,
      child: Text(text),
      style:  OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: Get.theme.primaryColorLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))
      ),
    );
  }
}

