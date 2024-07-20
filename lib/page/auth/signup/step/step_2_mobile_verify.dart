import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepMobileVerify extends GetView<SignupController> {
  const StepMobileVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Mobile Number", style: Get.textTheme.headline6,),

          OtpTextField(controller: controller.mobileOtpController),

          const SizedBox(height: 16,),
          Align(
            alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){
                controller.sendMobileOtp();
              }, child: Text("Send Otp"))),


          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}

