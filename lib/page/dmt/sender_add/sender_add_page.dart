import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/common/counter_widget.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/page/dmt/sender_add/sender_add_controller.dart';
import 'package:esmartbazaar/util/validator.dart';

class SenderAddPage extends GetView<SenderAddController> {
  const SenderAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderAddController());
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
              child: Obx(() => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MobileTextField(
                          enable: false,
                          controller: controller.mobileNumberController),
                      AppTextField(
                          enable: controller.isTextFieldEnable(),
                          hint: "Enter First Name",
                          label: "First Name",
                          validator: FormValidatorHelper.normalValidation,
                          controller: controller.firstNameController),
                      AppTextField(
                          enable: controller.isTextFieldEnable(),
                          hint: "Enter Last Name",
                          label: "Last Name",
                          validator: FormValidatorHelper.normalValidation,
                          controller: controller.lastNameController),
                      (controller.actionType.value ==
                              SenderAddActionType.addSender)
                          ? OtpTextField(
                              maxLength: 6,
                              controller: controller.otpController)
                          : const SizedBox(),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(
                        text: controller.getButtonText(),
                        onClick: controller.onButtonClick,
                      ),
                      (controller.actionType.value ==
                              SenderAddActionType.addSender)
                          ? Padding(
                              padding: const EdgeInsets.only(top: 24, bottom: 8),
                              child: (controller
                                      .resendButtonVisibilityObs.value)
                                  ? SizedBox(
                                      width: Get.width,
                                      height: 48,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          controller.onResendOtp();
                                        },
                                        child: const Text("Resend Otp"),
                                        style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Get.theme.primaryColor)),
                                      ))
                                  : CounterWidget(
                                      onTimerComplete: () {
                                        controller.resendButtonVisibilityObs
                                            .value = true;
                                      },
                                    ),
                            )
                          : const SizedBox()
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
