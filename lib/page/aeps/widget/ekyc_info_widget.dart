import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/res/style.dart';

class EkycInfoWidget extends StatelessWidget {
  final VoidCallback onClick;
  final VoidCallback onCancel;
  final String title;
  final String message;

  const EkycInfoWidget(
      {required this.title, required this.message,required this.onClick, required this.onCancel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        onCancel();
        return false;
      },
      child: Container(
        decoration: AppStyle.bottomSheetDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.headline4,textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16,),
               Text(
                 message,
              style: Get.textTheme.bodyText1,textAlign: TextAlign.center,),
              const SizedBox(height: 32,),
              AppButton(text: "Proceed", onClick: onClick),
              const SizedBox(height: 16,),
              AppButton(text: "Cancel", onClick: onCancel,background: Colors.red,),
            ],
          ),
        ),
      ),
    );
  }
}
