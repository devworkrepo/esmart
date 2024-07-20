import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/app_constant.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepCaptchaVerify extends GetView<SignupController> {
  const StepCaptchaVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Verify Captcha", style: Get.textTheme.headline6,),

          AppTextField(controller: controller.captchaController,
          label: "Captcha",
          hint: "captcha from below image",),

          const SizedBox(height: 16,),

          Row(children: [
            Expanded(
              child: Container(
               decoration: BoxDecoration(
                 color: Colors.blue.withOpacity(0.2),
                 borderRadius: BorderRadius.circular(5)
               ),
                height: 90,
                child: Obx((){
                  var url = controller.captchaUrl.value;
                  if(url.isEmpty) {
                    return const SizedBox();
                  } else {
                    return Image.network(AppConstant.baseCaptchaUrl+url,fit: BoxFit.fill,);
                  }
                }),
              ),
            ),
            const SizedBox(width: 16,),
            TextButton(onPressed: (){
              controller.fetchCaptcha(reCaptcha: true);
            }, child: Text("Refresh\nCaptcha"))
          ],),


          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}

