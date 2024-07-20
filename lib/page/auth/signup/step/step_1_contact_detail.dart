import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/validator.dart';
import 'package:esmartbazaar/widget/drop_down.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepContactDetail extends GetView<SignupController> {
  const StepContactDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Form(
        key: controller.stepOneFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Contact Details", style: Get.textTheme.headline6,),
            MobileTextField(
              controller: controller.mobileInputController,
            ),
            EmailTextField(
              controller: controller.emailInputController,
            ),
            AppTextField(
              controller: controller.panInputController,
              label: "Pan Number",
              hint: "10 characters pan number",
              maxLength: 10,
              validator: (value) => FormValidatorHelper.isValidPanCardNo(value),
            ),

            AadhaarTextField(controller: controller.aadhaarInputController),
            AppDropDown(
              label: "Select State",
                hint: "Required*",
                validator: (value) {
                  if (controller.selectedState == null) {
                    return "Select Country State";
                  } else {
                    return null;
                  }
                },
                list: controller.stateList.map((e) => e.name.toString())
                    .toList(), onChange: (value){
                controller.selectedState = value;
            }),

            AppTextField(
              controller: controller.cityInputController,
              label: "City Name",
              hint: "Required*",
              maxLength: 56,
              validator: (value) => FormValidatorHelper.normalValidation(value),
            ),

            AppTextField(
              controller: controller.pinCodeInputController,
              label: "Pin Code",
              hint: "6 digits pincode",
              maxLength: 6,
              inputType: TextInputType.number,
              validator: (value) => FormValidatorHelper.pincode(value),
            ),

            SizedBox(height: 16,),

            Container(
              decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4)
              ),
              padding: EdgeInsets.all(5),
              child: Text(
                "Note :- Your name in Aadhaar Card and PAN Name Should be Same."
                    " If Name will be different in PAN Card then your PAN No will be accepted.",
                style: Get.textTheme.caption?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                    height: 1.4
                ),),
            ),

            const SizedBox(
              height: 32,
            ),
          ],
        ),
      );
  }
}

