import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/page/dmt_upi/sender_add/sender_add_controller.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/counter_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/validator.dart';

class UpiSenderAddPage extends GetView<UpiSenderAddController> {
  const UpiSenderAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UpiSenderAddController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register UPI Sender"),
      ),
      body: _buildSenderAddForm(),
    );
  }

  _buildSenderAddForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: controller.senderAddFormKey,
            child: SingleChildScrollView(
              child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MobileTextField(
                          enable: false,
                          controller: controller.mobileNumberController),
                     if(controller.actionType.value == SenderAddActionType.requestOtp) AppTextField(
                          enable: controller.isTextFieldEnable(),
                          hint: "Enter First Name",
                          label: "First Name",
                          validator: FormValidatorHelper.normalValidation,
                          controller: controller.firstNameController),
                      if(controller.actionType.value == SenderAddActionType.requestOtp)  AppTextField(
                          enable: controller.isTextFieldEnable(),
                          hint: "Enter Last Name",
                          label: "Last Name",
                          validator: FormValidatorHelper.normalValidation,
                          controller: controller.lastNameController),
                      (controller.actionType.value ==
                                  SenderAddActionType.addSender)
                          ? OtpTextField(
                              maxLength: 4,
                              controller: controller.otpController)
                          : const SizedBox(),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(
                        text: controller.getButtonText(),
                        onClick: controller.onButtonClick,
                      ),

                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
