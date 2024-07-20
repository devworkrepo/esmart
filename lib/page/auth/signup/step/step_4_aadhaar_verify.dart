import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepAadhaarVerify extends GetView<SignupController> {
  const StepAadhaarVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Aadhaar OTP", style: Get.textTheme.headline6,),
          
          OtpTextField(controller: controller.aadhaarOtpController,maxLength: 6,),

          const SizedBox(height: 16,),
          Align(
            alignment: Alignment.centerRight,
              child: TextButton(onPressed: (){
                controller.verifyCaptchaAndSendEKycOtp(resendOtp: true);
              }, child: Text("Resend Otp"))),


          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}

