import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';
import 'package:esmartbazaar/util/validator.dart';

import '../../../widget/common/counter_widget.dart';
import 'change_password_controller.dart';

class ChangePasswordPage extends GetView<ChangePasswordController> {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: const [_BuildFormWidget()],
                ),
              ),
            ),
          ),
          Obx(()=> AppButton(
              text: (controller.changePasswordActionTypeObs.value ==
                  ChangePasswordActionType.requestOtp)
                  ? "Request OTP"
                  : "Verify OTP",
              onClick: () {
                if (controller.formKey.currentState!.validate()) {
                  if (controller.changePasswordActionTypeObs.value ==
                      ChangePasswordActionType.requestOtp) {
                    controller.requestOtp();
                  } else {
                    controller.changePassword();
                  }
                }
              }))
        ],
      ),
    );
  }
}

class _BuildFormWidget extends GetView<ChangePasswordController> {
  const _BuildFormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change Password",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [

                  PasswordTextField(
                    controller: controller.oldPasswordController,
                    label: "Old Password",
                    hint: "Required*",
                  ),
                  PasswordTextField(
                    controller: controller.newPasswordController,
                    label: "New Password",
                    hint: "Required*",

                  ),
                  PasswordTextField(
                    controller: controller.confirmPasswordController,
                    label: "Confirm Password",
                    hint: "Required*",
                    validator: (value){
                      var messageOne = "Enter Confirm Password";
                      var messageTwo = "Password didn't matched";
                      if(value == null){
                        return messageOne;
                      }
                      if(value.isEmpty){
                        return messageOne;
                      }
                      if(controller.newPasswordController.text != value){
                        return messageTwo;
                      }
                      return null;
                    },
                  ),

                  Obx(() => (controller.changePasswordActionTypeObs.value ==
                      ChangePasswordActionType.changePassword)
                      ? OtpTextField(
                    controller: controller.otpController,
                    maxLength: 6,
                  )
                      : const SizedBox()),

                  Obx(() => (controller.changePasswordActionTypeObs.value ==
                      ChangePasswordActionType.changePassword)
                      ? Column(
                    children: [
                      SizedBox(
                        height: 24,
                      ),
                      (controller.resendButtonVisibilityObs.value)
                          ? SizedBox(
                          width: 200,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              controller.resendOtp();
                            },
                            child: const Text("Resend Otp"),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(
                                            100.0),
                                        side: const BorderSide(
                                            color: Colors.red)))),
                          ))
                          : CounterWidget(
                        onTimerComplete: () {
                          controller.resendButtonVisibilityObs
                              .value = true;
                        },
                      )
                    ],
                  )
                      : SizedBox())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
