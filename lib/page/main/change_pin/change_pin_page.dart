import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:esmartbazaar/widget/button.dart';
import 'package:esmartbazaar/widget/text_field.dart';

import '../../../widget/common/counter_widget.dart';
import 'change_pin_controller.dart';

class ChangePinPage extends GetView<ChangePinController> {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePinController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change MPin"),
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
             text: (controller.changePinActionTypeObs.value ==
                 ChangePinActionType.requestOtp)
                 ? "Request OTP"
                 : "Verify OTP",
             onClick: () {
               if (controller.formKey.currentState!.validate()) {
                 if (controller.changePinActionTypeObs.value ==
                     ChangePinActionType.requestOtp) {
                   controller.requestOtp();
                 } else {
                   controller.verifyOtp();
                 }
               }
             }))
        ],
      ),
    );
  }
}

class _BuildFormWidget extends GetView<ChangePinController> {
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
              "MPIN",
              style: Get.textTheme.subtitle1,
            ),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  AppTextField(
                    controller: controller.newMPinController,
                    label: "Enter New MPIN",
                    inputType: TextInputType.number,
                    hint: "Required*",
                    passwordMode: true,
                    maxLength: 6,
                    validator: (value) {
                      if (value!.length > 3 || value.length < 6) {
                        return null;
                      } else {
                        return "Enter 4 - 6 digits MPIN";
                      }
                    },
                  ),
                  AppTextField(
                    controller: controller.confirmMPinController,
                    label: "Confirm New MPIN",
                    inputType: TextInputType.number,
                    hint: "Required*",
                    passwordMode: true,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null) {
                        return "Confirm MPIN didn't matched!";
                      } else {
                        if (controller.newMPinController.text == value) {
                          return null;
                        } else {
                          return "Confirm MPIN didn't matched!";
                        }
                      }
                    },
                  ),
                  Obx(() => (controller.changePinActionTypeObs.value ==
                          ChangePinActionType.changePin)
                      ? OtpTextField(
                          controller: controller.otpController,
                          maxLength: 6,
                        )
                      : const SizedBox()),
                  Obx(() => (controller.changePinActionTypeObs.value ==
                          ChangePinActionType.changePin)
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
