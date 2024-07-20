import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/util/app_util.dart';

class ShowDeviceRegisterDialog extends StatelessWidget {

  final String deviceName;
  final String message;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ShowDeviceRegisterDialog({Key? key,required this.deviceName,required this.message,required this.onAccept,required this.onReject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Icon(Icons.device_unknown,size: 120,color: Get.theme.primaryColor,),
            const SizedBox(height: 16,),
            Text("New Device Found",style: Get.textTheme.headline3?.copyWith(color: Colors.black),),
            Text(deviceName,style: Get.textTheme.headline3?.copyWith(color: Colors.black),),
            const SizedBox(height: 8,),
            Text(message,style: Get.textTheme.bodyText1?.copyWith(fontSize: 16,color: Colors.black54),),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 32),
              child: AppButton(text: "Register Device", onClick: onAccept),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 0),
              child: AppButton(text: "Reject It", onClick: onReject,background: Colors.red,),
            )
        ],),
      ),
    );
  }
}
