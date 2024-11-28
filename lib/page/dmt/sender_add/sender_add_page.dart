import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/counter_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../sender_add_2/sender_add_controller.dart';

class SenderAddPage2 extends GetView<SenderAddController2> {
  const SenderAddPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderAddController2());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Sender"),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MobileTextField(
                      enable: false,
                      controller: controller.mobileNumberController),
                  if (controller.sender?.isname == true)
                    AppTextField(
                        enable: true,
                        hint: "Enter First Name",
                        label: "First Name",
                        validator: FormValidatorHelper.normalValidation,
                        controller: controller.firstNameController),
                  if (controller.sender?.isname == true)
                    AppTextField(
                        enable: true,
                        hint: "Enter Last Name",
                        label: "Last Name",
                        validator: FormValidatorHelper.normalValidation,
                        controller: controller.lastNameController),
                  if (controller.sender?.isotp == true)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: OtpTextField(
                          maxLength: 4,
                          controller: controller.otpController,
                        )),
                        const SizedBox(
                          width: 8,
                        ),
                        SizedBox(
                            width: 100,
                            child: AppButton(
                                text: "Send Otp",
                                onClick: () =>
                                    controller.requestOtp()))
                      ],
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                  AppButton(
                    text: "Register Remitter",
                    onClick: () => controller.senderRegistration(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
