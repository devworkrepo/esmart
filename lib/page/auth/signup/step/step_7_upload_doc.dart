import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepUploadDoc extends GetView<SignupController> {
  const StepUploadDoc({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Upload Docs", style: Get.textTheme.headline6,),

        /*  AppTextField(
            label: "Aadhaar Photo",
            controller: controller.docAadhaarController,
          onFieldTab: (){
            controller.showImagePickerBottomSheetDialog(SignUpFileType.aadhaar);
          },),*/
          AppTextField(
            label: "PAN Photo",
            controller: controller.docPanController,
            onFieldTab: (){
              controller.showImagePickerBottomSheetDialog(SignUpFileType.pan);
            },),

          const SizedBox(
            height: 32,
          ),
        ],
      );
  }
}

