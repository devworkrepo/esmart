import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceVerificationDialog extends StatelessWidget {
  const DeviceVerificationDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min,
        children: [
          Container(

            child: Stack(
              fit: StackFit.loose,
              children: [
              Center(child: SizedBox(height : 120, width: 120,child: CircularProgressIndicator(strokeWidth: 8,))),
              Positioned(
                top: 0,
                  right: 0,
                  bottom: 0,
                  left: 0,
                  child: Icon(Icons.device_unknown,size: 60,color: Get.theme.primaryColor,))
            ],),
          ),
          const SizedBox(height: 16,),
          Text("Verifying",style: Get.textTheme.headline3?.copyWith(color: Colors.black),),
          const SizedBox(height: 8,),
        ],),
      ),
    );
  }
}
