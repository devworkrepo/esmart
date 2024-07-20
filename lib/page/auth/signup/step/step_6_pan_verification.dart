import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepPanVerification extends GetView<SignupController> {
  const StepPanVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify Pan Number",
          style: Get.textTheme.headline6,
        ),
        AppTextField(
          controller: controller.panInput2Controller,
          label: "Pan Number",
          hint: "10 characters pan number",
          maxLength: 10,
          validator: (value) => FormValidatorHelper.isValidPanCardNo(value),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name in PAN :-",
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Obx(()=>Text(controller.panName.value,
                  style: Get.textTheme.subtitle1,
                )),
              ],
            )),
            SizedBox(
              width: 16,
            ),
            TextButton(onPressed: () {
              controller.verifyPanNumber();
            }, child: Text("Verify Pan"))
          ],
        ),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}
